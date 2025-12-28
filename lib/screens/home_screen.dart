import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:renbo/services/journal_storage.dart';
import 'package:renbo/api/gemini_service.dart';
import 'package:renbo/utils/theme.dart';

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
  String _thoughtOfTheDay = "Loading a new thought...";
  final GeminiService _geminiService = GeminiService();

  // Person A: Migration State
  bool _isMigrating = false;

  // Person B/C: Aftercare State (Friend's Features)
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

        // 🔥 Person A: Trigger Cloud Sync
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
          const SnackBar(
            content: Text("Cloud Sync Complete"),
            duration: Duration(seconds: 2),
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
        setState(() => _thoughtOfTheDay =
            "The best way to predict the future is to create it.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              Text('Hello, $_userName!',
                  style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.darkGray)),
              const SizedBox(height: 16),
              MoodCard(
                title: 'Thought of the day',
                content: _thoughtOfTheDay,
                image: 'assets/lottie/axolotl.json',
              ),
              const SizedBox(height: 24),

              // Friend's Feature: Self-Care Aftercare
              Text('Self-Care Check-in',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.darkGray.withOpacity(0.8))),
              const SizedBox(height: 12),
              _buildAftercareSection(),

              const SizedBox(height: 24),
              _buildMainButtons(context),
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

  Widget _buildAftercareSection() {
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
                  label: 'Hydrate',
                  color: Colors.blue.shade100,
                  iconColor: Colors.blue.shade700,
                  subtitle:
                      'Water is fuel for resilience. Even a small sip can help clear the fog.'),
              _buildAftercareItem(
                  icon: Icons.restaurant_rounded,
                  label: 'Nourish',
                  color: Colors.orange.shade100,
                  iconColor: Colors.orange.shade700,
                  subtitle:
                      'Your body needs energy to process big feelings. A gentle snack is self-love.'),
              _buildAftercareItem(
                  icon: Icons.bedtime_rounded,
                  label: 'Rest',
                  color: Colors.purple.shade100,
                  iconColor: Colors.purple.shade700,
                  subtitle:
                      'It is okay to hit the pause button. Recovery requires quiet moments.'),
              _buildAftercareItem(
                  icon: Icons.air_rounded,
                  label: 'Breathe',
                  color: Colors.green.shade100,
                  iconColor: Colors.green.shade700,
                  subtitle:
                      'Take one deep breath, just for you. Let the air ground you.'),
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

  Widget _buildMainButtons(BuildContext context) {
    return Column(
      children: [
        _buttonRow(context, Icons.edit_note, 'Journal', const CalendarScreen(),
            Icons.chat_bubble_outline, 'Chat with Ren', const ChatScreen()),
        const SizedBox(height: 16),
        _buttonRow(
            context,
            Icons.headphones_outlined,
            'Meditation',
            const MeditationScreen(),
            Icons.videogame_asset_outlined,
            'Game',
            const RelaxGame()),
        const SizedBox(height: 16),
        _buttonRow(
            context,
            Icons.bubble_chart,
            'Gratitude',
            const GratitudeBubblesScreen(),
            Icons.auto_awesome_motion,
            'Vault',
            const CapsuleVaultScreen()),
        const SizedBox(height: 16),
        _buttonRow(
            context,
            Icons.fingerprint,
            'Zen Space',
            const NonVerbalSessionScreen(),
            Icons.vibration,
            'Mood Pulse',
            const MoodPulseScreen()),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildButton(context,
                icon: Icons.phone_in_talk,
                label: 'Hotlines',
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