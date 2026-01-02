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
  
  // We will build the mood map dynamically inside the build method
  // so it updates when the language changes.

  @override
  void initState() {
    super.initState();
    _selectedDay = null; 
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;
    
    // ✅ Format the date according to the current language
    // We access the locale code (e.g., 'en' or 'es') from the localization object
    final todayStr = DateFormat('EEEE, d MMM', l10n.localeName).format(DateTime.now());

    return Scaffold(
      backgroundColor: AppTheme.oatMilk,
      appBar: AppBar(
        title: Text(l10n.journalCalendar, // ✅ Translated
            style: const TextStyle(color: AppTheme.espresso, fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.oatMilk,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.espresso),
      ),
      
      // FLOATING BUTTON: "New Entry"
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.matchaGreen,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(l10n.newEntry, // ✅ Translated
            style: const TextStyle(color: Colors.white)),
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
              l10n.todayIs(todayStr), // ✅ Translated with parameter
              style: TextStyle(
                fontSize: 16, 
                color: AppTheme.espresso.withOpacity(0.6), 
                fontWeight: FontWeight.w600
              ),
            ),
          ),

          // 2. CALENDAR
          TableCalendar(
            locale: l10n.localeName, // ✅ Sets the calendar language (Mon/Tue vs Lun/Mar)
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            currentDay: DateTime.now(),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            availableCalendarFormats: const { CalendarFormat.month: 'Month' }, 
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, 
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.espresso),
            ),
            calendarStyle: CalendarStyle(
              selectedDecoration: const BoxDecoration(color: AppTheme.matchaGreen, shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: AppTheme.cocoa.withOpacity(0.3), shape: BoxShape.circle),
              todayTextStyle: const TextStyle(color: AppTheme.espresso, fontWeight: FontWeight.bold),
              defaultTextStyle: const TextStyle(color: AppTheme.espresso),
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
          const Divider(color: AppTheme.cocoa),
          const SizedBox(height: 30),

          // 3. THE BUTTON (Navigates to the List View)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.espresso,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                minimumSize: const Size(double.infinity, 55),
              ),
              icon: const Icon(Icons.history_edu, color: Colors.white),
              label: Text(l10n.viewAllEntries, // ✅ Translated
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
  
  // MOOD SELECTOR
  void _showMoodSelector(BuildContext context, DateTime selectedDate, AppLocalizations l10n) {
    // ✅ Define Mood Map here so it uses the current language
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
          backgroundColor: AppTheme.latteFoam,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(
            l10n.howAreYouFeeling, // ✅ Translated
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppTheme.espresso, fontWeight: FontWeight.bold)
          ),
          content: Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            alignment: WrapAlignment.center,
            children: moodEmojis.entries.map((entry) {
              return InkWell(
                onTap: () {
                  Navigator.of(dialogContext).pop();
                  // We pass the key (e.g., "Happy" or "Feliz") to the next screen
                  _navigateToNewEntry(selectedDate, entry.key);
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))]
                      ),
                      child: Text(entry.value, style: const TextStyle(fontSize: 28)),
                    ),
                    const SizedBox(height: 4),
                    Text(entry.key, style: const TextStyle(fontSize: 12, color: AppTheme.espresso)),
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