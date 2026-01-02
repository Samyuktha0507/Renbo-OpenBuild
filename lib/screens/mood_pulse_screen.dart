import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:renbo/utils/theme.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class MoodPulseScreen extends StatefulWidget {
  const MoodPulseScreen({super.key});

  @override
  State<MoodPulseScreen> createState() => _MoodPulseScreenState();
}

class _MoodPulseScreenState extends State<MoodPulseScreen> {
  double _intensity = 0.5; // Arousal: Soft to Intense
  double _valence = 0.5; // Sentiment: Negative to Positive
  double _clarity = 0.5; // Cognitive: Foggy to Clear

  // These will be updated dynamically
  String _aiFeedback = ""; 
  String _comfortAdvice = "";

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize text on first load using current locale
    final l10n = AppLocalizations.of(context)!;
    if (_aiFeedback.isEmpty) {
        _aiFeedback = l10n.defaultFeedback;
        _comfortAdvice = l10n.defaultAdvice;
    }
  }

  // ✅ Dynamic feedback logic using Translations
  void _updateFeedback(AppLocalizations l10n) {
    setState(() {
      // 1. DISTRESSED / OVERWHELMED (Negative + High Intensity)
      if (_valence < 0.4 && _intensity > 0.6) {
        if (_clarity < 0.4) {
          _aiFeedback = l10n.feedbackOverwhelmed;
          _comfortAdvice = l10n.adviceGrounding;
        } else {
          _aiFeedback = l10n.feedbackSharp;
          _comfortAdvice = l10n.adviceExitEnergy;
        }
      }
      // 2. HEAVY / NUMB (Negative + Low Intensity)
      else if (_valence < 0.4 && _intensity <= 0.6) {
        if (_clarity < 0.4) {
          _aiFeedback = l10n.feedbackHeavy;
          _comfortAdvice = l10n.adviceComfort;
        } else {
          _aiFeedback = l10n.feedbackSadness;
          _comfortAdvice = l10n.adviceValidate;
        }
      }
      // 3. SCATTERED / TIRED (Neutral + Foggy)
      else if (_valence >= 0.4 && _valence <= 0.6 && _clarity < 0.4) {
        _aiFeedback = l10n.feedbackHaze;
        _comfortAdvice = l10n.adviceDigitalFast;
      }
      // 4. PEACEFUL / FOCUSED (Positive + Clear)
      else if (_valence > 0.6 && _clarity > 0.6) {
        _aiFeedback = l10n.feedbackFlow;
        _comfortAdvice = l10n.adviceCreativity;
      }
      // 5. CALM / DREAMY (Positive + Foggy)
      else if (_valence > 0.6 && _clarity <= 0.6) {
        _aiFeedback = l10n.feedbackDreamy;
        _comfortAdvice = l10n.adviceDaydream;
      }
      // DEFAULT
      else {
        _aiFeedback = l10n.feedbackBalanced;
        _comfortAdvice = l10n.adviceCheckBody;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(l10n.moodPulseTitle, // ✅ Translated
            style: const TextStyle(fontFamily: 'Poppins')),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Dynamic Visual Indicator (The Pulse)
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.5, end: _intensity),
                duration: const Duration(milliseconds: 300),
                builder: (context, value, child) {
                  return Container(
                    height: 120 + (value * 80),
                    width: 120 + (value * 80),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          _getMoodColor(_valence),
                          _getMoodColor(_valence).withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: _getMoodColor(_valence).withOpacity(0.4),
                          // Blur is now tied to Clarity
                          blurRadius: 20 + ((1 - _clarity) * 40),
                          spreadRadius: 5 + (value * 10),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _valence < 0.4
                            ? Icons.cloud_queue
                            : (_valence > 0.6
                                ? Icons.wb_sunny
                                : Icons.favorite),
                        size: 30 + (value * 30),
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),

              // AI Analysis Block
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Container(
                  key: ValueKey(_aiFeedback),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey[200]!),
                  ),
                  child: Column(
                    children: [
                      Text(
                        _aiFeedback,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _comfortAdvice,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.4,
                          color: Colors.blueGrey[700],
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // 1. CLARITY SLIDER
              _buildSliderLabel(l10n.labelFoggy, l10n.labelClear), // ✅ Translated
              _buildSlider(
                value: _clarity,
                onChanged: (val) {
                   _clarity = val;
                   _updateFeedback(l10n); // Pass l10n to update text
                },
                gradient: const [Colors.blueGrey, Colors.cyanAccent],
              ),
              const SizedBox(height: 25),

              // 2. VALENCE SLIDER
              _buildSliderLabel(l10n.labelNegative, l10n.labelPositive), // ✅ Translated
              _buildSlider(
                value: _valence,
                onChanged: (val) {
                   _valence = val;
                   _updateFeedback(l10n);
                },
                gradient: const [
                  Colors.blueGrey,
                  Colors.blueAccent,
                  Colors.greenAccent,
                  Colors.yellowAccent
                ],
              ),
              const SizedBox(height: 25),

              // 3. INTENSITY SLIDER
              _buildSliderLabel(l10n.labelSoftEnergy, l10n.labelHighIntensity), // ✅ Translated
              _buildSlider(
                value: _intensity,
                onChanged: (val) {
                   _intensity = val;
                   _updateFeedback(l10n);
                },
                gradient: [
                  _getMoodColor(_valence).withOpacity(0.5),
                  _getMoodColor(_valence)
                ],
              ),

              const SizedBox(height: 40),

              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  side: const BorderSide(color: Color(0xFF8E97FD)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: Text(l10n.btnFeelHeard, // ✅ Translated
                    style: const TextStyle(color: Color(0xFF8E97FD))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliderLabel(String left, String right) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(left,
            style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
        Text(right,
            style: const TextStyle(
                color: Colors.blueGrey,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _buildSlider({
    required double value,
    required Function(double) onChanged, // Simplified type definition
    required List<Color> gradient,
  }) {
    return Container(
      height: 12,
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: gradient),
      ),
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 0,
          thumbColor: Colors.white,
          overlayColor: Colors.white.withOpacity(0.2),
          thumbShape:
              const RoundSliderThumbShape(enabledThumbRadius: 12, elevation: 3),
        ),
        child: Slider(
          value: value,
          onChanged: (val) {
            HapticFeedback.selectionClick();
            onChanged(val);
          },
        ),
      ),
    );
  }

  Color _getMoodColor(double value) {
    if (value < 0.3) return Colors.blueGrey;
    if (value < 0.5) return Colors.blueAccent;
    if (value < 0.7) return Colors.greenAccent;
    return Colors.orangeAccent;
  }
}