import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart'; 
import 'package:intl/intl.dart'; // Make sure this package is added!
import '../models/journal_entry.dart';
import '../services/journal_storage.dart';
import 'journal_detail.dart';
import 'journal_screen.dart'; 
import '../utils/theme.dart';

class JournalEntriesPage extends StatefulWidget {
  const JournalEntriesPage({Key? key}) : super(key: key);

  @override
  State<JournalEntriesPage> createState() => _JournalEntriesPageState();
}

class _JournalEntriesPageState extends State<JournalEntriesPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay; // ✅ 1. Starts as NULL (No selection)
  late Future<List<JournalEntry>> _entriesFuture;

  @override
  void initState() {
    super.initState();
    _selectedDay = null; // Ensure no day is highlighted initially
    _loadEntries();
  }

  void _loadEntries() {
    setState(() {
      _entriesFuture = JournalStorage.getEntries();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Format Today's Date: "Sunday, 28 Dec"
    final todayStr = DateFormat('EEEE, d MMM').format(DateTime.now());

    return Scaffold(
      backgroundColor: AppTheme.oatMilk,
      appBar: AppBar(
        title: const Text('Journal Calendar', style: TextStyle(color: AppTheme.espresso, fontWeight: FontWeight.bold)),
        backgroundColor: AppTheme.oatMilk,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppTheme.espresso),
      ),
      
      // FLOATING BUTTON (Always allows adding an entry)
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.matchaGreen,
        icon: const Icon(Icons.edit, color: Colors.white),
        label: const Text("New Entry", style: TextStyle(color: Colors.white)),
        onPressed: () {
          // ✅ 4. If no date picked, default to TODAY
          _navigateToNewEntry(_selectedDay ?? DateTime.now());
        },
      ),

      body: Column(
        children: [
          // ✅ 2. HEADER: Shows Today's Date prominently
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 10),
            alignment: Alignment.center,
            child: Text(
              "Today is $todayStr",
              style: TextStyle(
                fontSize: 16, 
                color: AppTheme.espresso.withOpacity(0.6), 
                fontWeight: FontWeight.w600
              ),
            ),
          ),

          // 📅 CALENDAR
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            currentDay: DateTime.now(), // Marks today with a subtle indicator
            
            // Only highlight if _selectedDay is NOT null
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            
            // Force Month View (No 2-week button)
            availableCalendarFormats: const { CalendarFormat.month: 'Month' }, 
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, 
              titleCentered: true,
              titleTextStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.espresso),
            ),
            
            calendarStyle: CalendarStyle(
              // The Green Selection Circle
              selectedDecoration: const BoxDecoration(color: AppTheme.matchaGreen, shape: BoxShape.circle),
              // Today's indicator (when not selected)
              todayDecoration: BoxDecoration(color: AppTheme.cocoa.withOpacity(0.3), shape: BoxShape.circle),
              todayTextStyle: const TextStyle(color: AppTheme.espresso, fontWeight: FontWeight.bold),
              defaultTextStyle: const TextStyle(color: AppTheme.espresso),
            ),

            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                // Toggle selection: If tapping the same day, unselect it? 
                // No, usually just select it.
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
          ),
          
          const SizedBox(height: 10),
          const Divider(),

          // 📝 ENTRIES LIST
          Expanded(
            child: FutureBuilder<List<JournalEntry>>(
              future: _entriesFuture,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                
                final allEntries = snapshot.data!;
                
                // ✅ 3. FILTER LOGIC:
                // If NO date is selected -> Show ALL entries (Reverse chronological)
                // If date IS selected -> Show only that day's entries
                List<JournalEntry> displayEntries;
                
                if (_selectedDay == null) {
                  // Show all, sorted by newest first
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
                                ? "No entries yet.\nStart your journey today!" 
                                : "No entries for this day.\nTap here to write!",
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
                    final entryDate = DateFormat('MMM d, h:mm a').format(entry.timestamp);

                    return Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(
                          entry.title ?? "Untitled", 
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