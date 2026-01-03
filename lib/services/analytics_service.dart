import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsService {
  static DateTime? _featureStartTime;
  static final List<String> allFeatures = [
    'Meditation',
    'Journaling',
    'Chat',
    'Game',
    'Gratitude',
    'Zen Space',
    'Mood Pulse',
    'Vault'
  ];

  static void startFeatureSession() {
    _featureStartTime = DateTime.now();
  }

  static Future<void> endFeatureSession(String featureName) async {
    if (_featureStartTime == null) return;
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    final int secondsSpent = now.difference(_featureStartTime!).inSeconds;

    // Time-series keys for graph axes
    String hourKey =
        "${featureName}_H_${now.year}_${now.month}_${now.day}_${now.hour}";
    String dayKey = "${featureName}_D_${now.year}_${now.month}_${now.day}";
    String monthKey = "${featureName}_M_${now.year}_${now.month}";
    String totalKey = "time_$featureName";

    await _increment(prefs, hourKey, secondsSpent);
    await _increment(prefs, dayKey, secondsSpent);
    await _increment(prefs, monthKey, secondsSpent);
    await _increment(prefs, totalKey, secondsSpent);

    _featureStartTime = null;
  }

  static Future<void> _increment(
      SharedPreferences prefs, String key, int val) async {
    await prefs.setInt(key, (prefs.getInt(key) ?? 0) + val);
  }

  static Future<Map<String, dynamic>> getFullAnalytics(String period) async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();
    List<double> chartPoints = [];
    Map<String, int> featureBreakdown = {};

    // X-axis mapping: Daily (Hours), Weekly (Days), Monthly (Weeks), Overall (Months)
    if (period == "Daily") {
      for (int i = 0; i < 24; i++) {
        double total = 0;
        for (var f in allFeatures)
          total +=
              (prefs.getInt("${f}_H_${now.year}_${now.month}_${now.day}_$i") ??
                      0) /
                  60.0;
        chartPoints.add(total);
      }
    } else if (period == "Weekly") {
      for (int i = 6; i >= 0; i--) {
        DateTime date = now.subtract(Duration(days: i));
        double total = 0;
        for (var f in allFeatures)
          total +=
              (prefs.getInt("${f}_D_${date.year}_${date.month}_${date.day}") ??
                      0) /
                  60.0;
        chartPoints.add(total);
      }
    } else if (period == "Monthly") {
      for (int i = 3; i >= 0; i--) {
        double weekTotal = 0;
        for (int d = 0; d < 7; d++) {
          DateTime date = now.subtract(Duration(days: (i * 7) + d));
          for (var f in allFeatures)
            weekTotal += (prefs.getInt(
                        "${f}_D_${date.year}_${date.month}_${date.day}") ??
                    0) /
                60.0;
        }
        chartPoints.add(weekTotal);
      }
    } else {
      for (int i = 5; i >= 0; i--) {
        DateTime date = DateTime(now.year, now.month - i, 1);
        double total = 0;
        for (var f in allFeatures)
          total +=
              (prefs.getInt("${f}_M_${date.year}_${date.month}") ?? 0) / 60.0;
        chartPoints.add(total);
      }
    }

    for (var f in allFeatures)
      featureBreakdown[f] = prefs.getInt("time_$f") ?? 0;
    return {"chart": chartPoints, "breakdown": featureBreakdown};
  }
}
