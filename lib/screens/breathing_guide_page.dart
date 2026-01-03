import 'package:flutter/material.dart';
import 'dart:async';
import 'package:renbo/utils/theme.dart';
// ✅ Import Tracking & Translations
import 'package:renbo/services/analytics_service.dart';
import 'package:renbo/l10n/gen/app_localizations.dart';

class BreathingGuidePage extends StatefulWidget {
  const BreathingGuidePage({super.key});

  @override
  _BreathingGuidePageState createState() => _BreathingGuidePageState();
}

class _BreathingGuidePageState extends State<BreathingGuidePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  Timer? _breathingTimer;
  int _countdown = 4;

  // 0 = Breathe In, 1 = Hold, 2 = Breathe Out
  int _phase = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    // ✅ START ANALYTICS SESSION
    AnalyticsService.startFeatureSession();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  @override
  void dispose() {
    // ✅ END ANALYTICS SESSION
    AnalyticsService.endFeatureSession("Meditation");
    _animationController.dispose();
    _breathingTimer?.cancel();
    super.dispose();
  }

  void _startBreathing() {
    setState(() {
      _isAnimating = true;
      _phase = 0; // Reset to Breathe In
      _countdown = 4;
    });

    _animationController.forward(from: 0.0);

    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _countdown--;
        if (_countdown < 0) {
          if (_phase == 0) {
            // Was Breathe In -> Now Hold
            _phase = 1;
            _countdown = 2;
            _animationController.stop(); // Pause expansion for holding breath
          } else if (_phase == 1) {
            // Was Hold -> Now Breathe Out
            _phase = 2;
            _countdown = 6;
            _animationController.duration = const Duration(seconds: 6);
            _animationController.reverse(from: 1.0); // Start contraction
          } else if (_phase == 2) {
            // Was Breathe Out -> Now Breathe In
            _phase = 0;
            _countdown = 4;
            _animationController.duration = const Duration(seconds: 4);
            _animationController.forward(from: 0.0); // Start expansion
          }
        }
      });
    });
  }

  void _pauseBreathing() {
    _breathingTimer?.cancel();
    _animationController.stop();
    setState(() {
      _isAnimating = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Dynamic Theme Colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.titleLarge?.color;
    final primaryGreen = theme.colorScheme.primary;

    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    // Convert the phase number (0,1,2) into the translated text
    String instructionText;
    switch (_phase) {
      case 0:
        instructionText = l10n.breatheIn;
        break;
      case 1:
        instructionText = l10n.hold;
        break;
      case 2:
        instructionText = l10n.breatheOut;
        break;
      default:
        instructionText = l10n.breatheIn;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor, // Adaptive background
      appBar: AppBar(
        title: Text(
          l10n.breathingGuide,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              instructionText, // Localized Phase Text
              style: TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(height: 100),

            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                double scale = 1.0;
                if (_phase == 0) {
                  scale = 1.0 + _animationController.value;
                } else if (_phase == 2) {
                  scale = 2.0 - _animationController.value;
                } else {
                  scale = 2.0; // Stay expanded during "Hold"
                }

                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: primaryGreen.withOpacity(isDark ? 0.3 : 0.5),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: primaryGreen.withOpacity(0.2),
                          blurRadius: 30,
                          spreadRadius: 10,
                        )
                      ],
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _countdown > 0 ? '$_countdown' : '',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color:
                            isDark ? theme.colorScheme.onSurface : Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 100),

            // Themed Action Button
            SizedBox(
              width: 250,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? theme.colorScheme.surface : AppTheme.espresso,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                onPressed: _isAnimating ? _pauseBreathing : _startBreathing,
                child: Text(
                  _isAnimating ? l10n.pauseBreathing : l10n.startBreathing,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
