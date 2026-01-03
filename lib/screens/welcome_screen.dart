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
    // Ensures navigation happens after the build phase is complete
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startSequence();
    });
  }

  void _startSequence() async {
    // Wait for the splash animation to show
    await Future.delayed(const Duration(seconds: 3));
    
    if (mounted) {
      // Use pushNamedAndRemoveUntil to wipe the splash screen from history
      Navigator.pushNamedAndRemoveUntil(context, '/auth_check', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/lottie/axolotl.json',
              width: 200,
              height: 200,
              repeat: true,
              errorBuilder: (context, error, stackTrace) => 
                const Icon(Icons.favorite, size: 100, color: Color(0xFFF06292)),
            ),
            const SizedBox(height: 20),
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