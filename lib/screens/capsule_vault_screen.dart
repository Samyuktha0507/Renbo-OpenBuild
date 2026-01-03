import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/time_capsule.dart';
import '../providers/capsule_provider.dart';
import '../widgets/capsule_card.dart';
import 'create_capsule_screen.dart';
import '../utils/theme.dart';
// ✅ Import Tracking & Translations
import 'package:renbo/services/analytics_service.dart';
import 'package:renbo/l10n/gen/app_localizations.dart';

class CapsuleVaultScreen extends StatefulWidget {
  const CapsuleVaultScreen({super.key});

  @override
  State<CapsuleVaultScreen> createState() => _CapsuleVaultScreenState();
}

class _CapsuleVaultScreenState extends State<CapsuleVaultScreen> {
  @override
  void initState() {
    super.initState();
    // ✅ START TRACKING SESSION
    AnalyticsService.startFeatureSession();
  }

  @override
  void dispose() {
    // ✅ END TRACKING SESSION
    AnalyticsService.endFeatureSession("Vault");
    super.dispose();
  }

  /// Helper to calculate the most relevant time unit for the countdown
  String _getTimeRemainingText(TimeCapsule capsule, AppLocalizations l10n) {
    final diff = capsule.deliveryDate.difference(DateTime.now());
    if (diff.isNegative || diff.inSeconds <= 0) return l10n.readyToOpen;

    if (diff.inDays > 0) return l10n.unlocksInDays(diff.inDays);
    if (diff.inHours > 0) return l10n.unlocksInHours(diff.inHours);
    if (diff.inMinutes > 0) return l10n.unlocksInMinutes(diff.inMinutes);
    return l10n.unlocksInSeconds(diff.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Dynamic Theme Colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final textColor = theme.textTheme.titleLarge?.color;
    final primaryAccent = theme.colorScheme.primary;

    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    final capsuleProvider = Provider.of<CapsuleProvider>(context);
    final allCapsules = capsuleProvider.capsules;

    final now = DateTime.now();
    final unlocked =
        allCapsules.where((c) => now.isAfter(c.deliveryDate)).toList();
    final locked =
        allCapsules.where((c) => now.isBefore(c.deliveryDate)).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: theme.scaffoldBackgroundColor,
          elevation: 0,
          iconTheme: IconThemeData(color: textColor),
          title: Text(
            l10n.vaultTitle,
            style: TextStyle(
              color: textColor,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(text: l10n.tabUnlocked, icon: const Icon(Icons.lock_open)),
              Tab(text: l10n.tabLocked, icon: const Icon(Icons.lock_outline)),
            ],
            indicatorColor: primaryAccent,
            labelColor: primaryAccent,
            unselectedLabelColor: textColor?.withOpacity(0.5),
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(context, unlocked, l10n),
            _buildList(context, locked, l10n),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryAccent,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateCapsuleScreen()),
          ),
          child: Icon(Icons.add,
              color: isDark ? AppTheme.darkBackground : Colors.white),
        ),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, List<TimeCapsule> list, AppLocalizations l10n) {
    final theme = Theme.of(context);

    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            l10n.vaultEmpty,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color?.withOpacity(0.5),
              fontFamily: 'Poppins',
            ),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final capsule = list[index];
        final bool isReadyNow = DateTime.now().isAfter(capsule.deliveryDate);

        return CapsuleCard(
          capsule: capsule,
          onTap: () {
            if (isReadyNow) {
              _showContent(context, capsule, l10n);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(l10n
                      .patienceMessage(_getTimeRemainingText(capsule, l10n))),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  backgroundColor: theme.colorScheme.surface,
                ),
              );
            }
          },
        );
      },
    );
  }

  void _showContent(
      BuildContext context, TimeCapsule capsule, AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dateStr =
        DateFormat('MMMM dd, yyyy', l10n.localeName).format(capsule.createdAt);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.orangeAccent.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.orangeAccent, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.messageFromPast,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: theme.textTheme.titleLarge?.color,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 15),
            Text(
              capsule.content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                height: 1.5,
                color: theme.textTheme.bodyLarge?.color,
              ),
            ),
            const SizedBox(height: 30),
            Divider(color: theme.dividerColor),
            const SizedBox(height: 10),
            Text(
              l10n.sealedOn(dateStr),
              style: TextStyle(
                color: theme.textTheme.bodySmall?.color?.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  l10n.close,
                  style: TextStyle(
                    color: isDark ? AppTheme.darkBackground : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
