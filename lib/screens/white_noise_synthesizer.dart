import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/l10n/gen/app_localizations.dart';

class WhiteNoiseSynthesizerScreen extends StatefulWidget {
  const WhiteNoiseSynthesizerScreen({super.key});

  @override
  _WhiteNoiseSynthesizerScreenState createState() =>
      _WhiteNoiseSynthesizerScreenState();
}

class _WhiteNoiseSynthesizerScreenState
    extends State<WhiteNoiseSynthesizerScreen> {
  final List<String> _noiseFrequencies = ['white', 'pink', 'brown'];
  final Map<String, AudioPlayer> _players = {};
  final Map<String, double> _volumes = {'white': 0.0, 'pink': 0.0, 'brown': 0.0};

  @override
  void initState() {
    super.initState();
    _initPlayers();
  }

  void _initPlayers() async {
    for (var freq in _noiseFrequencies) {
      final p = AudioPlayer();
      await p.setSource(AssetSource('audio/${freq}_noise.mp3'));
      await p.setReleaseMode(ReleaseMode.loop);
      _players[freq] = p;
    }
  }

  @override
  void dispose() {
    _players.forEach((_, p) => p.dispose());
    super.dispose();
  }

  void _updateVolume(String freq, double vol) async {
    setState(() => _volumes[freq] = vol);
    final p = _players[freq];
    if (p != null) {
      await p.setVolume(vol);
      if (vol > 0 && p.state != PlayerState.playing) {
        await p.resume();
      } else if (vol == 0 && p.state == PlayerState.playing) {
        await p.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(l10n.whiteNoiseTitle, style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(l10n.mixFrequency, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _noiseFrequencies.length,
                itemBuilder: (context, index) {
                  final freq = _noiseFrequencies[index];
                  return _buildSlider(freq, l10n, theme);
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isDark ? theme.colorScheme.surface : AppTheme.espresso,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.goBack, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlider(String freq, AppLocalizations l10n, ThemeData theme) {
    String label = freq == 'white' ? l10n.noiseWhite : (freq == 'pink' ? l10n.noisePink : l10n.noiseBrown);
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: theme.colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            Slider(
              value: _volumes[freq]!,
              divisions: 10,
              label: _volumes[freq]!.toStringAsFixed(1),
              activeColor: theme.colorScheme.primary,
              onChanged: (v) => _updateVolume(freq, v),
            ),
          ],
        ),
      ),
    );
  }
}