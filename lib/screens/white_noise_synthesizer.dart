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
  final Map<String, double> _volumes = {
    'white': 0.0,
    'pink': 0.0,
    'brown': 0.0,
  };

  @override
  void initState() {
    super.initState();
    _initPlayers();
  }

  /// Initializes audio players for each frequency and sets them to loop.
  void _initPlayers() async {
    for (var freq in _noiseFrequencies) {
      final player = AudioPlayer();
      // Assumes files exist in: assets/audio/white_noise.mp3, etc.
      await player.setSource(AssetSource('audio/${freq}_noise.mp3'));
      await player.setReleaseMode(ReleaseMode.loop);
      _players[freq] = player;
    }
  }

  @override
  void dispose() {
    // Dispose all players to prevent memory leaks or background audio ghosting
    for (var player in _players.values) {
      player.dispose();
    }
    super.dispose();
  }

  /// Updates volume and handles play/pause logic based on slider value
  void _updateVolume(String freq, double vol) async {
    setState(() => _volumes[freq] = vol);

    final player = _players[freq];
    if (player != null) {
      await player.setVolume(vol);

      if (vol > 0 && player.state != PlayerState.playing) {
        await player.resume();
      } else if (vol == 0 && player.state == PlayerState.playing) {
        await player.pause();
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
        title: Text(l10n.whiteNoiseTitle,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Automatically uses correct back arrow color based on theme
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(l10n.mixFrequency,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                )),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _noiseFrequencies.length,
                itemBuilder: (context, index) {
                  final freq = _noiseFrequencies[index];
                  return _buildVolumeSlider(freq, l10n, theme);
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isDark ? theme.colorScheme.surface : AppTheme.espresso,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.goBack,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVolumeSlider(
      String freq, AppLocalizations l10n, ThemeData theme) {
    // Map frequency keys to localized labels
    String label = freq == 'white'
        ? l10n.noiseWhite
        : (freq == 'pink' ? l10n.noisePink : l10n.noiseBrown);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      color: theme.colorScheme.surface.withOpacity(0.5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                  letterSpacing: 1.2,
                )),
            Slider(
              value: _volumes[freq]!,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              label: _volumes[freq]!.toStringAsFixed(1),
              activeColor: theme.colorScheme.primary,
              inactiveColor: theme.colorScheme.primary.withOpacity(0.2),
              onChanged: (v) => _updateVolume(freq, v),
            ),
          ],
        ),
      ),
    );
  }
}
