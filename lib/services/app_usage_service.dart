import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppUsageService with WidgetsBindingObserver {
  DateTime? _startTime;

  // Initialize tracking
  void init() {
    WidgetsBinding.instance.addObserver(this);
    _recordStartTime();
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // User opened the app
      _recordStartTime();
    } else if (state == AppLifecycleState.paused) {
      // User closed/minimized the app
      _saveSessionDepth();
    }
  }

  void _recordStartTime() {
    _startTime = DateTime.now();
  }

  Future<void> _saveSessionDepth() async {
    if (_startTime == null) return;

    final prefs = await SharedPreferences.getInstance();
    final duration = DateTime.now().difference(_startTime!);

    // Get existing total seconds and add new session
    int totalSeconds = prefs.getInt('total_app_time_seconds') ?? 0;
    await prefs.setInt(
        'total_app_time_seconds', totalSeconds + duration.inSeconds);

    _startTime = null;
  }

  // Static helper to get the formatted time for the UI
  static Future<String> getTotalTime() async {
    final prefs = await SharedPreferences.getInstance();
    int totalSeconds = prefs.getInt('total_app_time_seconds') ?? 0;

    if (totalSeconds < 60) return "$totalSeconds sec";
    int minutes = totalSeconds ~/ 60;
    if (minutes < 60) return "$minutes min";

    int hours = minutes ~/ 60;
    int remainingMinutes = minutes % 60;
    return "${hours}h ${remainingMinutes}m";
  }
}
