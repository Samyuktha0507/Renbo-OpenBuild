import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:renbo/models/gratitude.dart';
import 'package:renbo/services/gratitude_storage.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/widgets/gratitude_bubbles_widget.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class GratitudeBubblesScreen extends StatefulWidget {
  const GratitudeBubblesScreen({super.key});

  @override
  State<GratitudeBubblesScreen> createState() => _GratitudeBubblesScreenState();
}

class _GratitudeBubblesScreenState extends State<GratitudeBubblesScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  late final AnimationController _animationController;
  final Random _random = Random();
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // 🔥 Firestore version: Push to DB, trigger local confetti
  void _addGratitude() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      await GratitudeStorage.addGratitude(text);
      _controller.clear();

      // Trigger confetti animation
      setState(() {
        _showConfetti = true;
      });

      // Hide confetti after 2 seconds
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _showConfetti = false;
          });
        }
      });
    }
  }

  void _showAddGratitudeDialog(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        // 🌓 Themed Dialog Background
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.addGratitude, // ✅ Translated
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
        content: TextField(
          controller: _controller,
          autofocus: true,
          style: TextStyle(color: theme.textTheme.bodyLarge?.color),
          decoration: InputDecoration(
            hintText: l10n.gratitudeHint, // ✅ Translated
            hintStyle: TextStyle(
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5)),
            filled: true,
            // 🌓 Dynamic Input Fill
            fillColor: isDark ? AppTheme.darkBackground : AppTheme.oatMilk,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (_) {
            _addGratitude();
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              l10n.cancel, // ✅ Translated
              style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _addGratitude();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: isDark ? AppTheme.darkBackground : Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
            ),
            child: Text(
              l10n.add, // ✅ Translated
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Dynamic Theme Colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color;

    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Adaptive background
      appBar: AppBar(
        title: Text(
          l10n.gratitudeTitle, // ✅ Translated
          style:
              TextStyle(fontWeight: FontWeight.bold, color: textColor),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddGratitudeDialog(l10n),
        // Using Primary Color for the FAB to keep it high-contrast but themed
        backgroundColor: theme.colorScheme.primary,
        child: Icon(Icons.add,
            color: isDark ? AppTheme.darkBackground : Colors.white),
      ),
      body: Stack(
        children: [
          // 🔥 REAL-TIME STREAM: Listens to Firestore changes
          StreamBuilder<List<Gratitude>>(
            stream: GratitudeStorage.getGratitudeStream(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noGratitudes, // ✅ Translated
                    style: TextStyle(
                        fontSize: 16, color: textColor?.withOpacity(0.5)),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              final gratitudes = snapshot.data!;
              final screenWidth = MediaQuery.of(context).size.width;
              final screenHeight = MediaQuery.of(context).size.height;
              const double size = 60.0;

              return Stack(
                children: gratitudes.map((gratitude) {
                  // Generate stable random positions based on the document ID
                  // (using seed so bubbles don't jump around on every refresh)
                  final seed = gratitude.id.hashCode;
                  final random = Random(seed);

                  final double xOffset =
                      random.nextDouble() * (screenWidth - size);
                  final double yOffset =
                      random.nextDouble() * (screenHeight * 0.7 - size);

                  // 🛠️ FIX: Removed 'Positioned' here because GratitudeBubble handles offset
                  return GratitudeBubble(
                    gratitude: gratitude,
                    bubbleSize: size,
                    animation: _animationController,
                    xOffset: xOffset,
                    yOffset: yOffset,
                    onUpdated: () {}, // Stream handles updates now
                  );
                }).toList(),
              );
            },
          ),

          // Confetti overlay
          if (_showConfetti)
            Center(
              child: Lottie.asset(
                'assets/lottie/confetti.json',
                repeat: false,
              ),
            ),
        ],
      ),
    );
  }
}