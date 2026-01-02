import 'package:flutter/material.dart';
import 'dart:async';
import 'package:renbo/utils/theme.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class BreathingGuidePage extends StatefulWidget {
  const BreathingGuidePage({super.key});

  @override
  _BreathingGuidePageState createState() => _BreathingGuidePageState();
}

class _BreathingGuidePageState extends State<BreathingGuidePage>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Timer _breathingTimer;
  int _countdown = 4;
  
  // 0 = Breathe In, 1 = Hold, 2 = Breathe Out
  int _phase = 0; 
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
  }

  void _startBreathing() {
    setState(() {
      _isAnimating = true;
      _phase = 0; // Reset to Breathe In
      _countdown = 4;
    });
    
    _animationController.forward(from: 0.0);

    _breathingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
        if (_countdown < 0) {
          if (_phase == 0) { // Was Breathe In -> Now Hold
            _phase = 1;
            _countdown = 2;
            _animationController.stop(); 
          } else if (_phase == 1) { // Was Hold -> Now Breathe Out
            _phase = 2;
            _countdown = 6;
            _animationController.duration = const Duration(seconds: 6);
            _animationController.reverse(from: 1.0); 
          } else if (_phase == 2) { // Was Breathe Out -> Now Breathe In
            _phase = 0;
            _countdown = 4;
            _animationController.duration = const Duration(seconds: 4);
            _animationController.forward(from: 0.0); 
          }
        }
      });
    });
  }

  void _pauseBreathing() {
    if (_isAnimating) {
      _breathingTimer.cancel();
      _animationController.stop();
      setState(() {
        _isAnimating = false;
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    if (_isAnimating) {
      _breathingTimer.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: Text(l10n.breathingGuide), // ✅ Translated
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.darkGray,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              instructionText, // ✅ Uses dynamic translation
              style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 100),
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                double scale = 1.0;
                if (_phase == 0) { // Breathe In
                  scale = 1.0 + _animationController.value;
                } else if (_phase == 2) { // Breathe Out
                  scale = 2.0 - _animationController.value;
                } else {
                  scale = 2.0; // Hold
                }
                
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      _countdown > 0 ? '$_countdown' : '',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: _isAnimating ? _pauseBreathing : _startBreathing,
              child: Text(
                _isAnimating ? l10n.pauseBreathing : l10n.startBreathing // ✅ Translated
              ),
            ),
          ],
        ),
      ),
    );
  }
}