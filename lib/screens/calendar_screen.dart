import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../models/journal_entry.dart';
import '../services/journal_storage.dart';
import 'journal_screen.dart';
import 'journal_entries.dart';
import '../utils/theme.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = null;
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Grab Dynamic Theme Colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color;
    final primaryGreen = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface;

    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    // ✅ Format the date according to the current language
    final todayStr = DateFormat('EEEE, d MMM', l10n.localeName).format(DateTime.now());

    return Scaffold(
      backgroundColor: scaffoldBg, // Adaptive background
      appBar: AppBar(
        title: Text(
          l10n.journalCalendar, // ✅ Translated
          style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        ),
        backgroundColor: scaffoldBg,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
      ),

      // FLOATING BUTTON: "New Entry"
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: primaryGreen,
        icon: Icon(Icons.edit, color: isDark ? AppTheme.darkBackground : Colors.white),
        label: Text(
          l10n.newEntry, // ✅ Translated
          style: TextStyle(color: isDark ? AppTheme.darkBackground : Colors.white),
        ),
        onPressed: () {
          _showMoodSelector(context, _selectedDay ?? DateTime.now(), l10n);
        },
      ),

      body: Column(
        children: [
          // 1. HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            child: Text(
              l10n.todayIs(todayStr), // ✅ Translated
              style: TextStyle(
                fontSize: 16,
                color: textColor?.withOpacity(0.6),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // 2. CALENDAR (Themed)
          TableCalendar(
            locale: l10n.localeName, // ✅ Localized Calendar
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            currentDay: DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            availableCalendarFormats: const {CalendarFormat.month: 'Month'},
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
              rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(color: primaryGreen, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: AppTheme.cocoa.withOpacity(0.3), shape: BoxShape.circle),
              todayTextStyle: TextStyle(color: textColor, fontWeight: FontWeight.bold),
              defaultTextStyle: TextStyle(color: textColor),
              weekendTextStyle: TextStyle(color: isDark ? AppTheme.darkMatcha : AppTheme.cocoa),
              outsideTextStyle: TextStyle(color: textColor?.withOpacity(0.3)),
            ),
            daysOfWeekStyle: DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: textColor?.withOpacity(0.7), fontWeight: FontWeight.bold),
              weekendStyle: TextStyle(color: primaryGreen.withOpacity(0.7), fontWeight: FontWeight.bold),
            ),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              // Prompt for new entry immediately on tap
              _showMoodSelector(context, selectedDay, l10n);
            },
          ),

          const SizedBox(height: 30),
          Divider(color: theme.dividerColor),
          const SizedBox(height: 30),

          // 3. THE VIEW ALL BUTTON
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? surfaceColor : AppTheme.espresso,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 55),
                elevation: isDark ? 2 : 0,
              ),
              icon: const Icon(Icons.history_edu, color: Colors.white),
              label: Text(
                l10n.viewAllEntries, // ✅ Translated
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const JournalEntriesPage()),
                );
              },
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  // 🌙 MOOD SELECTOR (Themed Dialog + Localization)
  void _showMoodSelector(BuildContext context, DateTime selectedDate, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.bodyLarge?.color;
    final surfaceColor = theme.colorScheme.surface;

    // ✅ Define Mood Map here (so keys are translated)
    final Map<String, String> moodEmojis = {
      l10n.moodHappy: '😄',
      l10n.moodSad: '😢',
      l10n.moodAngry: '😠',
      l10n.moodConfused: '🤔',
      l10n.moodExcited: '🥳',
      l10n.moodCalm: '😌',
      l10n.moodNeutral: '😐',
    };

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          backgroundColor: surfaceColor, // Adaptive surface
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            l10n.howAreYouFeeling, // ✅ Translated
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          content: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            alignment: WrapAlignment.center,
            children: moodEmojis.entries.map((entry) {
              return InkWell(
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  _navigateToNewEntry(selectedDate, entry.key);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? AppTheme.darkBackground : Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: isDark ? Colors.black26 : Colors.black12,
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Text(entry.value, style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      entry.key,
                      style: TextStyle(fontSize: 12, color: textColor?.withOpacity(0.8)),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _navigateToNewEntry(DateTime date, String emotion) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalScreen(selectedDate: date, emotion: emotion),
      ),
    );
  }
}