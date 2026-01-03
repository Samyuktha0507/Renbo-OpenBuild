import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
    // Use addPostFrameCallback to ensure the widget tree is rendered
    // before we start the timer/sequence.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSequence();
    });
  }

  void _startSequence() async {
    // Wait for the splash animation (3 seconds)
    await Future.delayed(const Duration(seconds: 3));

    // The 'mounted' check is crucial: it prevents errors if the user
    // closes the app before the 3 seconds are up.
    if (mounted) {
      // pushNamedAndRemoveUntil removes the splash screen from the navigation stack
      // so the user cannot go "back" to it.
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/auth_check',
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Localization support
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Lottie Animation with fallback Icon
            Lottie.asset(
              'assets/lottie/axolotl.json',
              width: 200,
              height: 200,
              repeat: true,
              errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.favorite,
                  size: 100,
                  color: Color(0xFFF06292)),
            ),
            const SizedBox(height: 20),
            // Localized App Title
            Text(
              l10n?.appTitle ?? 'Renbo',
              style: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFFF06292),
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
