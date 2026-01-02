import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; 
import 'package:intl/intl.dart'; 
import '../models/journal_entry.dart';
import '../services/journal_storage.dart';
import 'journal_detail.dart'; // Ensure filename is correct
import 'journal_screen.dart'; 
import '../utils/theme.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class JournalEntriesPage extends StatefulWidget {
  const JournalEntriesPage({Key? key}) : super(key: key);

  @override
  State<JournalEntriesPage> createState() => _JournalEntriesPageState();
}

class _JournalEntriesPageState extends State<JournalEntriesPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay; 
  late Future<List<JournalEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _selectedDay = null; 
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entriesFuture = JournalStorage.getEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;
    
    // ✅ Format Date with Locale
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
      
      // FLOATING BUTTON
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.matchaGreen,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: Text(l10n.newEntry, // ✅ Translated
            style: const TextStyle(color: Colors.white)),
        onPressed: () {
          _navigateToNewEntry(_selectedDay ?? DateTime.now());
        },
      ),

      body: Column(
        children: [
          // HEADER
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            child: Text(
              l10n.todayIs(todayStr), // ✅ Translated
              style: TextStyle(
                fontSize: 16, 
                color: AppTheme.espresso.withOpacity(0.6), 
                fontWeight: FontWeight.w600
              ),
            ),
          ),

          // CALENDAR
          TableCalendar(
            locale: l10n.localeName, // ✅ Ensure Calendar uses correct language
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            currentDay: DateTime.now(), 
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            availableCalendarFormats: { CalendarFormat.month: l10n.monthLabel }, // ✅ Translated 'Month'
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
            },
          ),
          
          const SizedBox(height: 10),
          const Divider(),

          // ENTRIES LIST
          Expanded(
            child: FutureBuilder<List<JournalEntry>>(
              future: _entriesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final allEntries = snapshot.data!;
                List<JournalEntry> displayEntries;
                
                if (_selectedDay == null) {
                  displayEntries = List.from(allEntries);
                  displayEntries.sort((a, b) => b.timestamp.compareTo(a.timestamp));
                } else {
                  displayEntries = allEntries.where((entry) => 
                    isSameDay(entry.timestamp, _selectedDay)
                  ).toList();
                }

                if (displayEntries.isEmpty) {
                  return Center(
                    child: GestureDetector(
                      onTap: () => _navigateToNewEntry(_selectedDay ?? DateTime.now()),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.create, size: 40, color: AppTheme.espresso.withOpacity(0.3)),
                          const SizedBox(height: 10),
                          Text(
                            _selectedDay == null 
                                ? l10n.noEntriesYet // ✅ Translated
                                : l10n.noEntriesForDay, // ✅ Translated
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppTheme.espresso.withOpacity(0.5)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: displayEntries.length,
                  itemBuilder: (context, index) {
                    final entry = displayEntries[index];
                    // ✅ Format Entry Date with Locale
                    final entryDate = DateFormat('MMM d, h:mm a', l10n.localeName).format(entry.timestamp);

                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(
                          entry.title ?? l10n.untitled, // ✅ Translated
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppTheme.espresso),
                        ),
                        subtitle: Text(
                          "$entryDate\n${entry.content}", 
                          maxLines: 2, 
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: AppTheme.espresso.withOpacity(0.7)),
                        ),
                        isThreeLine: true,
                        trailing: entry.getStickers().isNotEmpty 
                           ? const Icon(Icons.emoji_emotions, color: AppTheme.matchaGreen)
                           : null,
                        onTap: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => JournalDetailScreen(entry: entry)),
                          ).then((_) => _loadEntries());
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
  
  void _navigateToNewEntry(DateTime date) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => JournalScreen(
          selectedDate: date, 
          emotion: "Neutral", 
        ),
      ),
    ).then((_) => _loadEntries());
  }
}