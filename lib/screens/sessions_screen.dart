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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          l10n.sessionsTitle, // ✅ Translated
          style: const TextStyle(
            color: AppTheme.darkGray,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUpcomingSection(l10n),
              const SizedBox(height: 24),
              Text(
                l10n.allSessions, // ✅ Translated
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.darkGray,
                ),
              ),
              const SizedBox(height: 12),
              _buildSessionList(l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.upcomingSession, // ✅ Translated
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGray,
          ),
        ),
        const SizedBox(height: 12),
        _buildSessionCard(
          name: 'Selena V',
          specialty: l10n.clinicalPsychology, // ✅ Translated
          time: '7:00 PM - 8:00 PM',
          isUpcoming: true,
          l10n: l10n,
        ),
      ],
    );
  }

  Widget _buildSessionList(AppLocalizations l10n) {
    return Column(
      children: [
        _buildSessionCard(
          name: 'Selena V',
          specialty: l10n.clinicalPsychology, // ✅ Translated
          time: 'March 28',
          l10n: l10n,
        ),
        const SizedBox(height: 8),
        _buildSessionCard(
          name: 'Jessica R',
          specialty: l10n.counseling, // ✅ Translated
          time: 'March 27',
          l10n: l10n,
        ),
      ],
    );
  }

  Widget _buildSessionCard({
    required String name,
    required String specialty,
    required String time,
    required AppLocalizations l10n,
    bool isUpcoming = false,
  }) {
    return Card(
      elevation: 0,
      // Using a subtle off-white/surface color for better contrast
      color: isUpcoming ? Colors.white : Colors.white.withOpacity(0.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
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
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: AppTheme.darkGray,
                        ),
                      ),
                      Text(
                        specialty,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.mediumGray,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isUpcoming)
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
            if (isUpcoming) ...[
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        side: const BorderSide(color: AppTheme.primaryColor),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(l10n.reschedule), // ✅ Translated
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(l10n.joinNow), // ✅ Translated
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
