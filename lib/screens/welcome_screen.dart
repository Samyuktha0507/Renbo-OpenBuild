import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // After 3 seconds, navigate to the authentication check screen.
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/auth_check');
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    // Note: Since this is the very first screen, make sure LocaleProvider is initialized higher up
    // If AppLocalizations is null here, ensure MaterialApp has the delegates set correctly.
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/axolotl.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            Text(
              l10n.appTitle, // ✅ Translated
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF06292),
              ),
            ),
          ],
        ),
      ),
    );
  }
}