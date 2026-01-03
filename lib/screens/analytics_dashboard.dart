import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:renbo/services/analytics_service.dart';
import 'package:renbo/utils/theme.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({super.key});

  @override
  State<AnalyticsDashboard> createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  String selectedPeriod = "Weekly";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    final primaryGreen = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("Wellness Insights",
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textColor),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: AnalyticsService.getFullAnalytics(selectedPeriod),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(color: primaryGreen));
          }

          final List<double> chartData = snapshot.data!["chart"];
          final Map<String, int> breakdown = snapshot.data!["breakdown"];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPeriodToggle(theme, primaryGreen, textColor),
                const SizedBox(height: 25),
                Text("App Usage Trends",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                const SizedBox(height: 15),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _buildLineChart(
                    chartData,
                    theme: theme,
                    primaryGreen: primaryGreen,
                    textColor: textColor,
                    key: ValueKey(selectedPeriod),
                  ),
                ),
                const SizedBox(height: 25),
                _buildDynamicInsights(breakdown, theme, primaryGreen),
                const SizedBox(height: 35),
                Text("Feature Breakdown",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: textColor)),
                const SizedBox(height: 15),
                ...breakdown.entries
                    .map((e) => _buildFeatureCard(
                        e.key, e.value, theme, primaryGreen, textColor))
                    .toList(),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- UPDATED GRAPH LOGIC ---

  Widget _buildLineChart(List<double> points,
      {required Key key,
      required ThemeData theme,
      required Color primaryGreen,
      required Color? textColor}) {
    double maxX = points.length > 1 ? (points.length - 1).toDouble() : 0;

    // Find the max Y value to determine intervals
    double maxY =
        points.isNotEmpty ? points.reduce((a, b) => a > b ? a : b) : 10;
    if (maxY < 5) maxY = 5; // Ensure we have some height

    return Container(
      key: key,
      height: 220,
      padding: const EdgeInsets.only(top: 20, right: 25, left: 10, bottom: 10),
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24)),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: points
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              isCurved: true,
              preventCurveOverShooting: true, // Fixes the "dip"
              color: primaryGreen,
              barWidth: 4,
              belowBarData:
                  BarAreaData(show: true, color: primaryGreen.withOpacity(0.1)),
              dotData: FlDotData(show: points.length < 15),
            ),
          ],
          minX: 0,
          maxX: maxX,
          minY: 0,
          maxY: maxY * 1.2, // Give some padding at the top
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                // Automatically space out minute numbers based on max value
                interval: maxY > 20 ? (maxY / 4).roundToDouble() : 5,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      value.toInt().toString(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: textColor?.withOpacity(0.5),
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                  interval: _calculateXInterval(points.length),
                  getTitlesWidget: (v, m) =>
                      _getBottomTitles(v, maxX, textColor)),
            ),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) =>
                FlLine(color: textColor?.withOpacity(0.1), strokeWidth: 1),
          ),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  // Calculates how often to show a label on the X axis so it's not crowded
  double _calculateXInterval(int length) {
    if (length <= 7) return 1;
    if (length <= 14) return 2;
    return (length / 5).floorToDouble();
  }

  Widget _getBottomTitles(double value, double maxX, Color? textColor) {
    final style = TextStyle(color: textColor?.withOpacity(0.5), fontSize: 10);
    int index = value.toInt();

    // Logic to show "Time Ago" labels
    if (selectedPeriod == "Daily") {
      return Text("${index}h", style: style);
    } else if (selectedPeriod == "Weekly") {
      return Text("${(maxX - index).toInt()}d", style: style);
    } else if (selectedPeriod == "Monthly") {
      int weeksAgo = ((maxX - index) / 7).floor();
      return Text("${weeksAgo}w", style: style);
    } else {
      return Text("${(maxX - index).toInt()}m", style: style);
    }
  }

  // --- REST OF CODE (ORIGINAL) ---

  String _getXAxisLabel() {
    if (selectedPeriod == "Daily") return "Hours";
    if (selectedPeriod == "Weekly") return "Days Ago";
    if (selectedPeriod == "Monthly") return "Weeks Ago";
    return "Months Ago";
  }

  Widget _buildDynamicInsights(
      Map<String, int> breakdown, ThemeData theme, Color primaryGreen) {
    final usedFeatures = breakdown.entries.where((e) => e.value > 0).toList();
    if (usedFeatures.isEmpty) return const SizedBox.shrink();
    final topEntry = usedFeatures.reduce((a, b) => a.value > b.value ? a : b);
    String insightTitle = "Focusing on ${topEntry.key}";
    String comment = "You're making consistent progress. Keep it up!";
    switch (topEntry.key) {
      case 'Meditation':
        comment =
            "Your focus on mindfulness is helping calm your nervous system.";
        break;
      case 'Journaling':
        comment =
            "Writing down thoughts builds clarity. Your future self will thank you.";
        break;
      case 'Chat':
        comment =
            "Expressing feelings is the first step to healing. You're doing great.";
        break;
      case 'Zen Space':
        comment =
            "Seeking sensory regulation is vital for your emotional balance.";
        break;
      case 'Mood Pulse':
        comment =
            "Regular check-ins build self-awareness. You're finding your rhythm.";
        break;
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? primaryGreen.withOpacity(0.2)
            : AppTheme.espresso,
        borderRadius: BorderRadius.circular(20),
        border: theme.brightness == Brightness.dark
            ? Border.all(color: primaryGreen.withOpacity(0.5))
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(Icons.auto_awesome, color: primaryGreen, size: 24),
            const SizedBox(width: 10),
            Text(insightTitle,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ]),
          const SizedBox(height: 10),
          Text(comment,
              style: const TextStyle(
                  color: Colors.white70, fontSize: 14, height: 1.4)),
        ],
      ),
    );
  }

  Widget _buildPeriodToggle(
      ThemeData theme, Color primaryGreen, Color? textColor) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(30)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: ["Daily", "Weekly", "Monthly", "Overall"].map((p) {
          bool isSelected = selectedPeriod == p;
          return GestureDetector(
            onTap: () => setState(() => selectedPeriod = p),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                  color: isSelected ? primaryGreen : Colors.transparent,
                  borderRadius: BorderRadius.circular(25)),
              child: Text(p,
                  style: TextStyle(
                      color: isSelected
                          ? (theme.brightness == Brightness.dark
                              ? Colors.black87
                              : Colors.white)
                          : textColor?.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeatureCard(String name, int seconds, ThemeData theme,
      Color primaryGreen, Color? textColor) {
    double minutes = seconds / 60;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          CircleAvatar(
              backgroundColor: theme.scaffoldBackgroundColor,
              child: Icon(Icons.insights, color: primaryGreen, size: 20)),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: textColor)),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                    value: (minutes / 60).clamp(0.05, 1.0),
                    backgroundColor: theme.scaffoldBackgroundColor,
                    color: primaryGreen),
              ],
            ),
          ),
          const SizedBox(width: 15),
          Text("${minutes.toStringAsFixed(1)}m",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: textColor?.withOpacity(0.7))),
        ],
      ),
    );
  }
}
