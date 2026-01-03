import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:renbo/screens/breathing_guide_page.dart';
import 'package:renbo/screens/white_noise_synthesizer.dart';
import 'package:renbo/utils/theme.dart';
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

  // Track list integrated from both versions
  final List<Map<String, String>> _tracks = [
    {'title': 'Rain Sounds', 'artist': 'Nature', 'path': 'audio/rain.mp3'},
    {
      'title': 'Forest Ambience',
      'artist': 'Nature',
      'path': 'audio/forest.mp3'
    },
    {
      'title': 'Zen Meditation',
      'artist': 'Inner Peace',
      'path': 'audio/zen.mp3'
    },
    {
      'title': 'Tibetan Bowls',
      'artist': 'Meditation',
      'path': 'audio/bowls.mp3'
    },
  ];

  int? _selectedTrackIndex;
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    // Audio Player Listeners
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

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    player.dispose();
    _meditationTimer?.cancel();
    super.dispose();
  }

  void _selectTrack(int index) async {
    if (_selectedTrackIndex == index) {
      _togglePlayPause();
      return;
    }

    await player.stop();
    _selectedTrackIndex = index;
    isPlaying = true;

    final selectedTrackPath = _tracks[index]['path']!;
    await player.setSource(AssetSource(selectedTrackPath));
    await player.setReleaseMode(ReleaseMode.loop);
    await player.resume();
    if (mounted) setState(() {});
  }

  void _togglePlayPause() async {
    if (_selectedTrackIndex == null) return;
    if (isPlaying) {
      await player.pause();
    } else {
      await player.resume();
    }
    setState(() => isPlaying = !isPlaying);
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
            // Navigation Action Chips
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionChip(
                    context, l10n.breathingGuide, Icons.self_improvement, () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const BreathingGuidePage()));
                }),
                _buildActionChip(context, l10n.whiteNoise, Icons.graphic_eq,
                    () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const WhiteNoiseSynthesizerScreen()));
                }),
              ],
            ),
            const SizedBox(height: 30),

            // Timer Display Container
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                children: [
                  Text(
                    _formatDuration(_meditationTime),
                    style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 2,
                        color: textColor),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: _meditationTimerIsRunning
                            ? _pauseMeditationTimer
                            : _startMeditationTimer,
                        icon: Icon(_meditationTimerIsRunning
                            ? Icons.pause
                            : Icons.play_arrow),
                        label: Text(_meditationTimerIsRunning
                            ? l10n.pauseBreathing
                            : l10n.start),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryGreen,
                          foregroundColor:
                              isDark ? AppTheme.darkBackground : Colors.white,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: _resetMeditationTimer,
                        icon: const Icon(Icons.refresh, size: 20),
                        label: Text(l10n.reset),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isDark
                              ? Colors.white10
                              : Colors.black.withOpacity(0.05),
                          foregroundColor: textColor,
                          elevation: 0,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
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
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: _tracks.length,
                itemBuilder: (context, index) => _buildTrackCard(index),
              ),
            ),
            // Mini player controls at the bottom
            if (_selectedTrackIndex != null)
              _buildMiniPlayer(primaryGreen, textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildActionChip(BuildContext context, String label, IconData iconData,
      VoidCallback onTap) {
    final primary = Theme.of(context).colorScheme.primary;
    return ActionChip(
      onPressed: onTap,
      avatar: Icon(iconData, size: 18, color: primary),
      label: Text(label),
      shape: const StadiumBorder(),
    );
  }

  Widget _buildMiniPlayer(Color primary, Color? textColor) {
    return Container(
      padding: const EdgeInsets.only(bottom: 20, top: 10),
      child: Column(
        children: [
          Slider(
            min: 0,
            max: duration.inSeconds.toDouble(),
            value: position.inSeconds.toDouble(),
            activeColor: primary,
            onChanged: (value) async =>
                await player.seek(Duration(seconds: value.toInt())),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _togglePlayPause,
                iconSize: 64,
                color: primary,
                icon: Icon(isPlaying
                    ? Icons.pause_circle_filled
                    : Icons.play_circle_fill),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrackCard(int index) {
    final theme = Theme.of(context);
    final isSelected = _selectedTrackIndex == index;
    final textColor = theme.textTheme.bodyLarge?.color;

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      color: isSelected
          ? theme.colorScheme.primary.withOpacity(0.1)
          : theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
            color: isSelected ? theme.colorScheme.primary : Colors.transparent),
      ),
      child: ListTile(
        onTap: () => _selectTrack(index),
        leading: Icon(
          isSelected ? Icons.graphic_eq : Icons.music_note_outlined,
          color: isSelected
              ? theme.colorScheme.primary
              : textColor?.withOpacity(0.5),
        ),
        title: Text(_tracks[index]['title']!,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(_tracks[index]['artist']!),
        trailing: isSelected && isPlaying
            ? Icon(Icons.volume_up, color: theme.colorScheme.primary)
            : null,
      ),
    );
  }
}
