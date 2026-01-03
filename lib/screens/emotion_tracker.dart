import 'package:flutter/material.dart';
import 'journal_screen.dart';
import 'journal_entries.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class EmotionTrackerScreen extends StatelessWidget {
  const EmotionTrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F2), // soft background
      appBar: AppBar(
        backgroundColor: const Color(0xFF568F87),
        title: Text(
          l10n.howAreYouFeeling, // ✅ Translated
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                _buildEmotionButton(
                    context, l10n.emotionHappy, l10n.msgHappy, l10n),
                _buildEmotionButton(
                    context, l10n.emotionSad, l10n.msgSad, l10n),
                _buildEmotionButton(
                    context, l10n.emotionAngry, l10n.msgAngry, l10n),
                _buildEmotionButton(
                    context, l10n.emotionTired, l10n.msgTired, l10n),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmotionButton(BuildContext context, String label, String message,
      AppLocalizations l10n) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFF5BABB),
        foregroundColor: const Color(0xFF064232),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 3,
      ),
      onPressed: () {
        // 1. Show localized feedback message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: const Color(0xFF568F87),
            duration: const Duration(seconds: 2),
          ),
        );

        // 2. Show localized journaling dialog
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.journalPrompt), // ✅ Translated
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JournalEntriesPage(),
                    ),
                  );
                },
                child: Text(l10n.no), // ✅ Translated
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF568F87),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context); // close dialog
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JournalScreen(
                        selectedDate: DateTime.now(),
                        emotion: label, // pass translated emotion label
                      ),
                    ),
                  );
                },
                child: Text(l10n.yesJournal), // ✅ Translated
              ),
            ],
          ),
        );
      },
      child: Text(label, style: const TextStyle(fontSize: 16)),
    );
  }
}
