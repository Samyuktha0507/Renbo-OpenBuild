import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:renbo/services/journal_storage.dart';
import 'package:renbo/api/gemini_service.dart';
import 'package:renbo/utils/theme.dart';
// ✅ Import the generated translations file
import 'package:renbo/l10n/gen/app_localizations.dart';

// Screen Imports
import 'package:renbo/screens/chat_screen.dart';
import 'package:renbo/screens/meditation_screen.dart';
import 'package:renbo/screens/hotlines_screen.dart';
import 'package:renbo/screens/stress_tap_game.dart';
import 'package:renbo/screens/settings_page.dart';
import 'package:renbo/screens/gratitude_bubbles_screen.dart';
import 'package:renbo/screens/calendar_screen.dart';
import 'package:renbo/screens/capsule_vault_screen.dart';
import 'package:renbo/screens/non_verbal_screen.dart';
import 'package:renbo/screens/mood_pulse_screen.dart';

// Widget Imports
import 'package:renbo/widgets/mood_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = "User";
  String? _thoughtOfTheDay; // Made nullable so we can detect if it's loading
  final GeminiService _geminiService = GeminiService();

  bool _isMigrating = false;
  final PageController _aftercareController = PageController();
  int _currentAftercarePage = 0;

  @override
  void initState() {
    super.initState();
    _fetchThoughtOfTheDay();
    _loadUserData();
  }

  @override
  void dispose() {
    _aftercareController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (mounted && user != null) {
        setState(() {
          _userName = user.displayName ?? "User";
        });

        if (!_isMigrating) {
          _isMigrating = true;
          await _runMigration();
        }
      }
    });
  }

  Future<void> _runMigration() async {
    try {
      await JournalStorage.migrateHiveToFirestore();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.cloudSyncComplete), // ✅ Translated
            duration: const Duration(seconds: 2),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      }
    } catch (e) {
      debugPrint("Migration failed: $e");
    }
  }

  void _fetchThoughtOfTheDay() async {
    try {
      final thought = await _geminiService.generateThoughtOfTheDay();
      if (mounted) {
        setState(() => _thoughtOfTheDay = thought);
      }
    } catch (e) {
      if (mounted) {
        // Fallback uses local string if API fails
        setState(() => _thoughtOfTheDay = null); 
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Helper to get translations easily
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Renbo',
            style: TextStyle(
                color: AppTheme.darkGray, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const SettingsPage())),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ✅ Translated "Hello User" with parameter
              Text(l10n.helloUser(_userName),
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray)),
              const SizedBox(height: 16),
              
              MoodCard(
                title: l10n.thoughtOfDay, // ✅ Translated
                // Use fetched thought, or fallback to translated default
                content: _thoughtOfTheDay ?? l10n.defaultThought, 
                image: 'assets/lottie/axolotl.json',
              ),
              const SizedBox(height: 24),

              Text(l10n.selfCareCheckIn, // ✅ Translated
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGray.withOpacity(0.8))),
              const SizedBox(height: 12),
              _buildAftercareSection(l10n), // Pass l10n to helper

              const SizedBox(height: 24),
              _buildMainButtons(context, l10n),
              const SizedBox(height: 24),

              Center(
                child: SizedBox(
                  height: 180,
                  child: Lottie.asset('assets/lottie/help.json'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ Updated to accept l10n
  Widget _buildAftercareSection(AppLocalizations l10n) {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: PageView(
            controller: _aftercareController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (int index) =>
                setState(() => _currentAftercarePage = index),
            children: [
              _buildAftercareItem(
                  icon: Icons.local_drink_rounded,
                  label: l10n.hydrate, // ✅ Translated
                  color: Colors.blue.shade100,
                  iconColor: Colors.blue.shade700,
                  subtitle: l10n.hydrateDesc), // ✅ Translated
              _buildAftercareItem(
                  icon: Icons.restaurant_rounded,
                  label: l10n.nourish, // ✅ Translated
                  color: Colors.orange.shade100,
                  iconColor: Colors.orange.shade700,
                  subtitle: l10n.nourishDesc), // ✅ Translated
              _buildAftercareItem(
                  icon: Icons.bedtime_rounded,
                  label: l10n.rest, // ✅ Translated
                  color: Colors.purple.shade100,
                  iconColor: Colors.purple.shade700,
                  subtitle: l10n.restDesc), // ✅ Translated
              _buildAftercareItem(
                  icon: Icons.air_rounded,
                  label: l10n.breathe, // ✅ Translated
                  color: Colors.green.shade100,
                  iconColor: Colors.green.shade700,
                  subtitle: l10n.breatheDesc), // ✅ Translated
            ],
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(4, (index) => _buildDotIndicator(index)),
        ),
      ],
    );
  }

  Widget _buildDotIndicator(int index) {
    bool isActive = _currentAftercarePage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? AppTheme.primaryColor
            : AppTheme.darkGray.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildAftercareItem(
      {required IconData icon,
      required String label,
      required Color color,
      required Color iconColor,
      required String subtitle}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: color.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color, width: 1.5)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: iconColor))
          ]),
          const SizedBox(height: 12),
          Expanded(
              child: Text(subtitle,
                  style: TextStyle(
                      fontSize: 13,
                      height: 1.4,
                      color: Colors.black87.withOpacity(0.8)))),
        ],
      ),
    );
  }

  // ✅ Updated to accept l10n
  Widget _buildMainButtons(BuildContext context, AppLocalizations l10n) {
    return Column(
      children: [
        _buttonRow(context, Icons.edit_note, l10n.journal, const CalendarScreen(),
            Icons.chat_bubble_outline, l10n.chatRen, const ChatScreen()),
        const SizedBox(height: 16),
        _buttonRow(
            context,
            Icons.headphones_outlined,
            l10n.meditation,
            const MeditationScreen(),
            Icons.videogame_asset_outlined,
            l10n.game,
            const RelaxGame()),
        const SizedBox(height: 16),
        _buttonRow(
            context,
            Icons.bubble_chart,
            l10n.gratitude,
            const GratitudeBubblesScreen(),
            Icons.auto_awesome_motion,
            l10n.vault,
            const CapsuleVaultScreen()),
        const SizedBox(height: 16),
        _buttonRow(
            context,
            Icons.fingerprint,
            l10n.zenSpace,
            const NonVerbalSessionScreen(),
            Icons.vibration,
            l10n.moodPulse,
            const MoodPulseScreen()),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildButton(context,
                icon: Icons.phone_in_talk,
                label: l10n.hotlines,
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => HotlinesScreen())))
          ],
        ),
      ],
    );
  }

  Widget _buttonRow(BuildContext context, IconData i1, String l1, Widget s1,
      IconData i2, String l2, Widget s2) {
    return Row(
      children: [
        _buildButton(context,
            icon: i1,
            label: l1,
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => s1))),
        const SizedBox(width: 16),
        _buildButton(context,
            icon: i2,
            label: l2,
            onTap: () =>
                Navigator.push(context, MaterialPageRoute(builder: (_) => s2))),
      ],
    );
  }

  Widget _buildButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: AppTheme.primaryColor),
                const SizedBox(height: 8),
                Text(label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}