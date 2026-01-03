import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renbo/utils/theme.dart';
// ✅ Import Tracking Service
import 'package:renbo/services/analytics_service.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class NonVerbalSessionScreen extends StatefulWidget {
  const NonVerbalSessionScreen({super.key});

  @override
  State<NonVerbalSessionScreen> createState() => _NonVerbalSessionScreenState();
}

class _NonVerbalSessionScreenState extends State<NonVerbalSessionScreen>
    with SingleTickerProviderStateMixin {
  double _intensity = 0.5;
  final List<TouchPoint> _points = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    // ✅ START TRACKING SESSION
    AnalyticsService.startFeatureSession();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }

  @override
  void dispose() {
    // ✅ END TRACKING SESSION
    AnalyticsService.endFeatureSession("Zen Space");
    _controller.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    HapticFeedback.lightImpact();
    setState(() {
      _points.add(TouchPoint(
        position: details.localPosition,
        color: _getMoodColor(),
        size: 20.0 + (_intensity * 40.0),
        timestamp: DateTime.now(),
      ));
    });
  }

  void _handleLongPress(LongPressStartDetails details) {
    HapticFeedback.mediumImpact();
    setState(() {
      _points.add(TouchPoint(
        position: details.localPosition,
        color: _getMoodColor(),
        size: 80.0 * _intensity,
        isPulse: true,
        timestamp: DateTime.now(),
      ));
    });
  }

  Color _getMoodColor() {
    // Maps intensity to a spectrum from Calm Blue to Energetic Orange/Red
    return Color.lerp(
      const Color(0xFF8E97FD), // Calm Purple/Blue
      const Color(0xFFFF8C69), // Warm Orange
      _intensity,
    )!;
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Dynamic Theme Colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color;

    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    // Clean up old points to keep performance high (2 second lifespan)
    _points.removeWhere(
        (p) => DateTime.now().difference(p.timestamp).inMilliseconds > 2000);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Adaptive Background
      appBar: AppBar(
        title: Text(
          l10n.zenSpaceTitle, // ✅ Translated
          style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins'),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          // The Interactive Canvas
          GestureDetector(
            onTapDown: _handleTap,
            onLongPressStart: _handleLongPress,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return CustomPaint(
                  painter: SessionPainter(
                    points: _points,
                    animationValue: _controller.value,
                    isDark: isDark, // ✅ Pass Theme mode for enhanced glow
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),

          // Instruction Overlay
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  // ☕ Adaptive Surface Color
                  color: theme.colorScheme.surface.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: textColor!.withOpacity(0.1),
                    width: 1,
                  ),
                ),
                child: Text(
                  l10n.zenInstructions, // ✅ Translated
                  style: TextStyle(
                    color: textColor.withOpacity(0.6),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),

          // Intensity Slider
          Positioned(
            bottom: 50,
            left: 30,
            right: 30,
            child: Column(
              children: [
                Text(
                  // ✅ Dynamic Translation for Intensity Labels
                  _intensity < 0.3
                      ? l10n.zenQuiet
                      : (_intensity < 0.7 ? l10n.zenSteady : l10n.zenVibrant),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: _getMoodColor(),
                    letterSpacing: 1.2,
                  ),
                ),
                Slider(
                  value: _intensity,
                  activeColor: _getMoodColor(),
                  inactiveColor: _getMoodColor().withOpacity(0.2),
                  onChanged: (val) {
                    setState(() => _intensity = val);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TouchPoint {
  final Offset position;
  final Color color;
  final double size;
  final bool isPulse;
  final DateTime timestamp;

  TouchPoint({
    required this.position,
    required this.color,
    required this.size,
    this.isPulse = false,
    required this.timestamp,
  });
}

class SessionPainter extends CustomPainter {
  final List<TouchPoint> points;
  final double animationValue;
  final bool isDark;

  SessionPainter({
    required this.points,
    required this.animationValue,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final now = DateTime.now();

    for (var point in points) {
      final age = now.difference(point.timestamp).inMilliseconds;
      final opacity = (1.0 - (age / 2000)).clamp(0.0, 1.0);

      final paint = Paint()
        ..color = point.color.withOpacity(opacity)
        ..style = PaintingStyle.fill
        // ✨ Increased blur for a better "Glow" effect in dark mode
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, isDark ? 15 : 10);

      if (point.isPulse) {
        // Drawing a growing pulse (Long Press)
        final pulseSize = point.size * (1 + (animationValue * 0.2));
        canvas.drawCircle(point.position, pulseSize, paint);

        // Secondary outer glow specific to dark mode to make it "pop"
        if (isDark) {
          canvas.drawCircle(
            point.position,
            pulseSize * 1.2,
            paint..color = point.color.withOpacity(opacity * 0.3),
          );
        }
      } else {
        // Drawing an expanding ripple (Tap)
        final rippleSize = point.size + (age / 10);
        canvas.drawCircle(point.position, rippleSize, paint);
      }
    }
  }

  @override
  bool shouldRepaint(SessionPainter oldDelegate) => true;
}
