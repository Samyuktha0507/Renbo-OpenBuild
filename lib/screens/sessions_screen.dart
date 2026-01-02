import 'package:flutter/material.dart';
import 'package:renbo/utils/theme.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.sessionsTitle, // ✅ Translated
          style: const TextStyle(
            color: AppTheme.darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUpcomingSession(l10n),
              const SizedBox(height: 20),
              Text(
                l10n.allSessions, // ✅ Translated
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildSessionList(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSession(AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.upcomingSession, // ✅ Translated
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildSessionCard(
              name: 'Selena V',
              specialty: l10n.clinicalPsychology, // ✅ Translated
              time: '7:00 PM - 8:00 PM',
              isUpcoming: true,
              l10n: l10n,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionList(AppLocalizations l10n) {
    return Column(
      children: [
        _buildSessionCard(
          name: 'Selena V',
          specialty: l10n.clinicalPsychology, // ✅ Translated
          time: 'Flat March 28',
          l10n: l10n,
        ),
        _buildSessionCard(
          name: 'Jessica R',
          specialty: l10n.counseling, // ✅ Translated
          time: 'Flat March 27',
          l10n: l10n,
        ),
      ],
    );
  }

  Widget _buildSessionCard({
    required String name,
    required String specialty,
    required String time,
    required AppLocalizations l10n, // Pass translation helper
    bool isUpcoming = false,
  }) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 25,
              backgroundColor: AppTheme.lightGray,
              child: Icon(Icons.person, color: AppTheme.mediumGray),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    specialty,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.mediumGray,
                    ),
                  ),
                  Text(
                    time,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.mediumGray,
                    ),
                  ),
                ],
              ),
            ),
            if (isUpcoming)
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                      side: const BorderSide(color: AppTheme.primaryColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(l10n.reschedule), // ✅ Translated
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(l10n.joinNow), // ✅ Translated
                  ),
                ],
              )
            else
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryColor,
                  side: const BorderSide(color: AppTheme.primaryColor),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(l10n.rebook), // ✅ Translated
              ),
          ],
        ),
      ),
    );
  }
}