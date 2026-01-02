import 'package:flutter/material.dart';
import 'package:renbo/utils/theme.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:async';
import 'white_noise_synthesizer.dart';
import 'breathing_guide_page.dart';
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
  late Timer _meditationTimer;

  Duration _meditationTime = Duration.zero;
  bool _meditationTimerIsRunning = false;

  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  // Track data is now loaded inside build() to support translation
  List<Map<String, String>> _tracks = [];

  int? _selectedTrackIndex;

  @override
  void initState() {
    super.initState();
    player.onDurationChanged.listen((d) {
      setState(() => duration = d);
    });
    player.onPositionChanged.listen((p) {
      setState(() => position = p);
    });
    player.onPlayerComplete.listen((event) {
      setState(() {
        isPlaying = false;
        position = Duration.zero;
      });
    });
  }

  void _startMeditationTimer() {
    _meditationTimerIsRunning = true;
    _meditationTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _meditationTime += const Duration(seconds: 1);
      });
    });
  }

  void _pauseMeditationTimer() {
    if (_meditationTimerIsRunning) {
      _meditationTimerIsRunning = false;
      _meditationTimer.cancel();
    }
  }

  void _resetMeditationTimer() {
    if (_meditationTimerIsRunning) {
      _meditationTimer.cancel();
    }
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
    if (_meditationTimerIsRunning) _meditationTimer.cancel();
    super.dispose();
  }

  void _selectTrack(int index) async {
    if (_selectedTrackIndex == index) {
      _togglePlayPause();
      return;
    }

    await player.stop();
    setState(() {
      _selectedTrackIndex = index;
      isPlaying = true;
      position = Duration.zero;
      duration = Duration.zero;
    });

    final selectedTrackPath = _tracks[index]['path']!;
    await player.setSource(AssetSource(selectedTrackPath));
    await player.setReleaseMode(ReleaseMode.loop); 
    await player.resume();
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
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    // ✅ Define tracks here to use translations
    _tracks = [
      {
        'title': 'Zen Meditation',
        'artist': 'Inner Peace',
        'path': 'audio/zen.mp3',
      },
      {
        'title': 'Soul Music',
        'artist': 'Nature Sounds',
        'path': 'audio/soul.mp3',
      },
      {
        'title': 'Rain Melody',
        'artist': 'Relaxing Rain Rhythms',
        'path': 'audio/rain.mp3',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.meditation, // ✅ Translated
          style: const TextStyle(
            color: AppTheme.darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const BreathingGuidePage()),
                    );
                  },
                  icon: const Icon(Icons.self_improvement),
                  label: Text(l10n.breathingGuide), // ✅ Translated
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) =>
                              const WhiteNoiseSynthesizerScreen()),
                    );
                  },
                  icon: const Icon(Icons.graphic_eq),
                  label: Text(l10n.whiteNoise), // ✅ Translated
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton.extended(
                  heroTag: 'meditation-timer-control',
                  onPressed: _meditationTimerIsRunning
                      ? _pauseMeditationTimer
                      : _startMeditationTimer,
                  label: Text(_meditationTimerIsRunning ? l10n.pauseBreathing : l10n.start), // ✅ Translated
                  icon: Icon(_meditationTimerIsRunning
                      ? Icons.pause
                      : Icons.play_arrow),
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                ),
                const SizedBox(width: 16),
                FloatingActionButton.extended(
                  heroTag: 'meditation-timer-reset',
                  onPressed: _resetMeditationTimer,
                  label: Text(l10n.reset), // ✅ Translated
                  icon: const Icon(Icons.refresh),
                  backgroundColor: AppTheme.darkGray,
                  foregroundColor: Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: Text(
                _formatDuration(_meditationTime),
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.darkGray),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.chooseTrack, // ✅ Translated
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGray,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _tracks.length,
                itemBuilder: (context, index) {
                  return _buildTrackCard(index);
                },
              ),
            ),
            if (_selectedTrackIndex != null)
              Column(
                children: [
                  Slider(
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    value: position.inSeconds.toDouble(),
                    onChanged: (value) async {
                      final newPosition = Duration(seconds: value.toInt());
                      await player.seek(newPosition);
                    },
                    activeColor: AppTheme.primaryColor,
                    inactiveColor: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_formatDuration(position)),
                        Text(_formatDuration(duration)),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _togglePlayPause,
                    iconSize: 80,
                    color: AppTheme.primaryColor,
                    icon: Icon(
                      isPlaying
                          ? Icons.pause_circle_filled
                          : Icons.play_circle_fill,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackCard(int index) {
    final track = _tracks[index];
    final isSelected = _selectedTrackIndex == index;

    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isSelected
            ? const BorderSide(color: AppTheme.primaryColor, width: 2)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: () => _selectTrack(index),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                isSelected ? Icons.music_note : Icons.music_note_outlined,
                color: isSelected ? AppTheme.primaryColor : AppTheme.darkGray,
                size: 30,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      track['title']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: isSelected
                            ? AppTheme.primaryColor
                            : AppTheme.darkGray,
                      ),
                    ),
                    Text(
                      track['artist']!,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Icon(
                  isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: AppTheme.primaryColor,
                ),
            ],
          ),
        ),
      ),
    );
  }
}