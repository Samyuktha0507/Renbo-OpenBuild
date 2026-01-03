import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:renbo/utils/theme.dart';

class MoodCard extends StatelessWidget {
  final String title;
  final String content;
  final String image;

  const MoodCard({
    super.key,
    required this.title,
    required this.content,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    // ✅ Check current theme brightness for Dark Mode support
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🎨 Logic for ultra-clear text
    // If dark mode: pure white. If light mode: your standard espresso/gray.
    final Color titleColor = isDark ? Colors.white : AppTheme.espresso;
    final Color contentColor =
        isDark ? Colors.white.withOpacity(0.9) : AppTheme.darkGray;

    return Card(
      // Ensure the card background is transparent so the parent container's style shows through
      color: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14, // Label size
                      fontWeight: FontWeight.bold,
                      color: titleColor, // Dynamic High visibility color
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.3,
                      color: contentColor, // Dynamic High visibility color
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            // Display Lottie animation if image path is provided
            if (image.isNotEmpty) ...[
              const SizedBox(width: 16),
              SizedBox(
                height: 80,
                width: 80,
                child: Lottie.asset(image),
              ),
            ],
          ],
        ),
      ),
    );
  }
}