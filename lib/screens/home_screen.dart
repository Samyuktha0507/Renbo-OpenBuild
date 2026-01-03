import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart'; // ✅ Added for ThemeProvider
import 'package:renbo/providers/theme_provider.dart'; // ✅ Added
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
  String? _thoughtOfTheDay;
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
            content: Text(
                AppLocalizations.of(context)!.cloudSyncComplete), // ✅ Translated
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
        setState(() => _thoughtOfTheDay = null);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Helper to get translations and Theme
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Renbo',
          style: TextStyle(
            color: theme.appBarTheme.titleTextStyle?.color ?? AppTheme.darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // 🌗 Theme Toggle
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              return IconButton(
                icon: Icon(themeProvider.isDarkMode
                    ? Icons.light_mode_rounded
                    : Icons.dark_mode_rounded),
                onPressed: () {
                  themeProvider.toggleTheme(!themeProvider.isDarkMode);
                },
              );
            },
          ),
          // ⚙️ Settings Button
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
              // ✅ Greeting (Translated + Dynamic Color)
              Text(
                l10n.helloUser(_userName),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 16),

              // ✨ Bright Thought Card (Themed + Translated)
              _buildBrightThoughtCard(isDark, l10n),

              const SizedBox(height: 24),

              Text(
                l10n.selfCareCheckIn, // ✅ Translated
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: textColor?.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 12),
              
              // 🌿 Aftercare Section (Passes Theme & L10n)
              _buildAftercareSection(l10n, isDark),

              const SizedBox(height: 24),
              
              // 🔘 Main Buttons (Passes Theme & L10n)
              _buildMainButtons(context, l10n, theme),
              
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

  // ✨ Helper for Bright Thought Card (From Snippet 1)
  Widget _buildBrightThoughtCard(bool isDark, AppLocalizations l10n) {
    // 🎨 Using primary Matcha color for the "glow" effect
    final Color baseColor = AppTheme.matchaGreen;
    final Color cardBg =
        isDark ? baseColor.withOpacity(0.15) : baseColor.withOpacity(0.1);
    final Color cardBorder =
        isDark ? baseColor.withOpacity(0.5) : baseColor.withOpacity(0.4);

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardBorder, width: 1.5),
      ),
      child: MoodCard(
        title: l10n.thoughtOfDay, // ✅ Translated
        content: _thoughtOfTheDay ?? l10n.defaultThought,
        image: 'assets/lottie/axolotl.json',
      ),
    );
  }

  // 🌿 Aftercare Section
  Widget _buildAftercareSection(AppLocalizations l10n, bool isDark) {
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
                isDark: isDark,
                icon: Icons.local_drink_rounded,
                label: l10n.hydrate, // ✅ Translated
                baseColor: Colors.blue,
                subtitle: l10n.hydrateDesc,
              ),
              _buildAftercareItem(
                isDark: isDark,
                icon: Icons.restaurant_rounded,
                label: l10n.nourish, // ✅ Translated
                baseColor: Colors.orange,
                subtitle: l10n.nourishDesc,
              ),
              _buildAftercareItem(
                isDark: isDark,
                icon: Icons.bedtime_rounded,
                label: l10n.rest, // ✅ Translated
                baseColor: Colors.purple,
                subtitle: l10n.restDesc,
              ),
              _buildAftercareItem(
                isDark: isDark,
                icon: Icons.air_rounded,
                label: l10n.breathe, // ✅ Translated
                baseColor: Colors.green,
                subtitle: l10n.breatheDesc,
              ),
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
    // 🎨 Theme-aware dots
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? theme.colorScheme.primary
            : (isDark ? Colors.grey.withOpacity(0.3) : AppTheme.darkGray.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildAftercareItem({
    required bool isDark,
    required IconData icon,
    required String label,
    required Color baseColor,
    required String subtitle,
  }) {
    // 🎨 Calculate dynamic colors
    final Color iconColor = isDark
        ? Color.lerp(baseColor, Colors.white, 0.4)!
        : Color.lerp(baseColor, Colors.black, 0.4)!;
        
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: baseColor.withOpacity(isDark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: baseColor.withOpacity(isDark ? 0.4 : 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: iconColor, size: 28),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: iconColor,
              ),
            )
          ]),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: textColor?.withOpacity(0.85),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔘 Main Buttons (Theme & L10n Aware)
  Widget _buildMainButtons(BuildContext context, AppLocalizations l10n, ThemeData theme) {
    return Column(
      children: [
        _buttonRow(context, theme, Icons.edit_note, l10n.journal,
            const CalendarScreen(), Icons.chat_bubble_outline, l10n.chatRen, const ChatScreen()),
        const SizedBox(height: 16),
        _buttonRow(
            context,
            theme,
            Icons.headphones_outlined,
            l10n.meditation,
            const MeditationScreen(),
            Icons.videogame_asset_outlined,
            l10n.game,
            const RelaxGame()),
        const SizedBox(height: 16),
        _buttonRow(
            context,
            theme,
            Icons.bubble_chart,
            l10n.gratitude,
            const GratitudeBubblesScreen(),
            Icons.auto_awesome_motion,
            l10n.vault,
            const CapsuleVaultScreen()),
        const SizedBox(height: 16),
        _buttonRow(
            context,
            theme,
            Icons.fingerprint,
            l10n.zenSpace,
            const NonVerbalSessionScreen(),
            Icons.vibration,
            l10n.moodPulse,
            const MoodPulseScreen()),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildButton(
              context,
              theme,
              icon: Icons.phone_in_talk,
              label: l10n.hotlines,
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => HotlinesScreen())),
            )
          ],
        ),
      ],
    );
  }

  Widget _buttonRow(BuildContext context, ThemeData theme, IconData i1, String l1, Widget s1,
      IconData i2, String l2, Widget s2) {
    return Row(
      children: [
        _buildButton(context, theme,
            icon: i1,
            label: l1,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => s1))),
        const SizedBox(width: 16),
        _buildButton(context, theme,
            icon: i2,
            label: l2,
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => s2))),
      ],
    );
  }

  Widget _buildButton(BuildContext context, ThemeData theme,
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Expanded(
      child: Card(
        color: theme.cardColor, // ✅ Adaptive Card Color
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: Column(
              children: [
                Icon(icon, size: 40, color: theme.colorScheme.primary), // ✅ Adaptive Icon Color
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: theme.textTheme.bodyLarge?.color, // ✅ Adaptive Text Color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}