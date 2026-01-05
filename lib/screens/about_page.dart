import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:renbo/utils/theme.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("About Renbo"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Logo & Tagline ---
            Center(
              child: Column(
                children: [
                  Icon(Icons.spa, size: 64, color: colorScheme.primary),
                  const SizedBox(height: 12),
                  Text(
                    "Your Digital Sanctuary",
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // --- Our Story ---
            Text(
              "Our Story",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 8),
            Text(
              // FIX: Use single quotes for the outer string to allow double quotes inside
              'Renbo was born from a simple idea: that mental wellness should not feel like a chore. In a world that is always "on," we wanted to build a quiet corner for your mind.\n\nThe name Renbo was created from the words "Serendipity" (meaning a happy occurrence) and "Bo" (a friendly term of endearment). It is a reminder that in the journey of one\'s mental health, every step forward is proof of resilience and grace.',
              style: textTheme.bodyLarge?.copyWith(
                height: 1.5,
                color: colorScheme.onSurface.withOpacity(0.8),
              ),
            ),

            const SizedBox(height: 32),

            // --- Developer Message Card ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                // Adaptive background using primary tint
                color: colorScheme.primaryContainer.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primary.withOpacity(0.1)),
              ),
              child: Column(
                children: [
                  Text(
                    "A Note from the Team",
                    style: textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold, 
                      color: colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "We built Renbo because we needed it too. We wanted to create a space that offers a quiet place for you to return to yourself. Thank you for trusting us.",
                    textAlign: TextAlign.center,
                    style: textTheme.bodyMedium?.copyWith(
                      height: 1.5, 
                      fontStyle: FontStyle.italic,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // --- Acknowledgements ---
            Text(
              "Acknowledgements",
              style: textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const Divider(thickness: 1.2),
            const SizedBox(height: 8),
            Text(
              "We use beautiful stickers to help you express your emotions. Special thanks to the creators at Flaticon:",
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildAttributionLink(context, "stickers by Surfsup.Vector", "https://www.flaticon.com/free-stickers/panda"),
            _buildAttributionLink(context, "stickers by paulalee (Coffee)", "https://www.flaticon.com/free-stickers/coffee"),
            _buildAttributionLink(context, "stickers by paulalee (Moods)", "https://www.flaticon.com/free-stickers/sad"),
            
            const SizedBox(height: 60),
            Center(
              child: Text(
                "Version 1.0.0",
                style: textTheme.labelSmall?.copyWith(color: colorScheme.outline),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttributionLink(BuildContext context, String text, String url) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        children: [
          Icon(Icons.star, size: 14, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: text,
                style: const TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 15,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = () => _launchURL(url),
              ),
            ),
          ),
        ],
      ),
    );
  }
}