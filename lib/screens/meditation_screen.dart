import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:renbo/screens/breathing_guide_page.dart';
import 'package:renbo/screens/white_noise_synthesizer.dart'; // ✅ Ensure this file exists at this path
import 'package:renbo/utils/theme.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class MeditationScreen extends StatefulWidget {
  const MeditationScreen({super.key});

  @override
  State<MeditationScreen> createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen>
    with SingleTickerProviderStateMixin {
  final player = AudioPlayer();
  Timer? _meditationTimer;

  Duration _meditationTime = Duration.zero;
  bool _meditationTimerIsRunning = false;

  final List<Map<String, String>> _tracks = [
    {
      'title': 'Rain Sounds',
      'artist': 'Nature',
      'path': 'audio/rain.mp3',
    },
    {
      'title': 'Forest Ambience',
      'artist': 'Nature',
      'path': 'audio/forest.mp3',
    },
    {
      'title': 'Ocean Waves',
      'artist': 'Nature',
      'path': 'audio/ocean.mp3',
    },
    {
      'title': 'Tibetan Bowls',
      'artist': 'Meditation',
      'path': 'audio/bowls.mp3',
    },
  ];

  int? _selectedTrackIndex;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    player.onDurationChanged.listen((d) {
      if (mounted) setState(() => duration = d);
    });
    player.onPositionChanged.listen((p) {
      if (mounted) setState(() => position = p);
    });
    player.onPlayerComplete.listen((event) {
      if (mounted) {
        setState(() {
          isPlaying = false;
          position = Duration.zero;
        });
      }
    });
  }

  void _startMeditationTimer() {
    _meditationTimerIsRunning = true;
    _meditationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _meditationTime += const Duration(seconds: 1);
        });
      }
    });
  }

  void _pauseMeditationTimer() {
    if (_meditationTimerIsRunning) {
      _meditationTimerIsRunning = false;
      _meditationTimer?.cancel();
      if (mounted) setState(() {});
    }
  }

  void _resetMeditationTimer() {
    _meditationTimer?.cancel();
    setState(() {
      _meditationTime = Duration.zero;
      _meditationTimerIsRunning = false;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    player.dispose();
    _meditationTimer?.cancel();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (isPlaying) {
      await player.pause();
    } else {
      if (_selectedTrackIndex != null) {
        await player.resume();
      }
    }
    setState(() {
      isPlaying = !isPlaying;
    });
  }

  void _selectTrack(int index) async {
    if (_selectedTrackIndex == index && isPlaying) {
      _togglePlayPause();
      return;
    }

    _selectedTrackIndex = index;
    isPlaying = true;

    final selectedTrackPath = _tracks[index]['path']!;
    await player.setSource(AssetSource(selectedTrackPath));
    await player.setReleaseMode(ReleaseMode.loop); 
    await player.resume();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.titleLarge?.color;
    final primaryGreen = theme.colorScheme.primary;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        title: Text(
          l10n.meditation,
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionChip(context, l10n.breathingGuide, Icons.self_improvement, () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BreathingGuidePage()));
                }),
                _buildActionChip(context, l10n.whiteNoise, Icons.graphic_eq, () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) =>  WhiteNoiseSynthesizerScreen()));
                }),
              ],
            ),
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  Text(
                    _formatDuration(_meditationTime),
                    style: TextStyle(fontSize: 48, fontWeight: FontWeight.w300, letterSpacing: 2, color: textColor),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _meditationTimerIsRunning ? _pauseMeditationTimer : _startMeditationTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor: isDark ? AppTheme.darkBackground : Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(_meditationTimerIsRunning ? Icons.pause : Icons.play_arrow),
                            const SizedBox(width: 8),
                            // ✅ Fixed: using pauseBreathing key from ARB
                            Text(_meditationTimerIsRunning ? l10n.pauseBreathing : l10n.start),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: _resetMeditationTimer,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark ? Colors.white10 : AppTheme.espresso.withValues(alpha: 0.1),
                          foregroundColor: textColor,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.refresh, size: 20),
                            const SizedBox(width: 8),
                            Text(l10n.reset),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(
              l10n.chooseTrack,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _tracks.length,
                itemBuilder: (context, index) => _buildTrackCard(index),
              ),
            ),
            if (_selectedTrackIndex != null) _buildMiniPlayer(theme, primaryGreen),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, String label, IconData iconData, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(iconData, size: 18, color: primary),
      label: Text(label),
      backgroundColor: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
      shape: StadiumBorder(side: BorderSide(color: primary.withValues(alpha: 0.2))),
    );
  }

  Widget _buildMiniPlayer(ThemeData theme, Color primaryGreen) {
    return Column(
      children: [
        Slider(
          min: 0,
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(),
          onChanged: (value) async => await player.seek(Duration(seconds: value.toInt())),
          activeColor: primaryGreen,
          inactiveColor: primaryGreen.withValues(alpha: 0.2),
        ),
        IconButton(
          onPressed: _togglePlayPause,
          iconSize: 64,
          color: primaryGreen,
          icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
        ),
      ],
    );
  }

  Widget _buildTrackCard(int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final track = _tracks[index];
    final isSelected = _selectedTrackIndex == index;
    final textColor = theme.textTheme.bodyLarge?.color;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected ? theme.colorScheme.primary.withValues(alpha: isDark ? 0.15 : 0.1) : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: isSelected ? theme.colorScheme.primary : Colors.transparent),
      ),
      child: InkWell(
        onTap: () => _selectTrack(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? theme.colorScheme.primary : theme.scaffoldBackgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isSelected ? Icons.graphic_eq : Icons.music_note_outlined,
                  color: isSelected ? (isDark ? AppTheme.darkBackground : Colors.white) : textColor?.withValues(alpha: 0.5),
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(track['title']!, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                    Text(track['artist']!, style: TextStyle(fontSize: 12, color: textColor?.withValues(alpha: 0.6))),
                  ],
                ),
              ),
              if (isSelected && isPlaying) Icon(Icons.volume_up, color: theme.colorScheme.primary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}