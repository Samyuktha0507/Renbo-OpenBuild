import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/time_capsule.dart';
import '../providers/capsule_provider.dart';
import '../widgets/capsule_card.dart';
import 'create_capsule_screen.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class CapsuleVaultScreen extends StatelessWidget {
  const CapsuleVaultScreen({super.key});

  /// Helper to calculate the most relevant time unit for the countdown
  /// ✅ Now accepts l10n to translate the output
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
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    // Listen to the provider for real-time data updates
    final capsuleProvider = Provider.of<CapsuleProvider>(context);
    final allCapsules = capsuleProvider.capsules;

    // Filter capsules based on whether the delivery date has passed
    final now = DateTime.now();
    final unlocked =
        allCapsules.where((c) => now.isAfter(c.deliveryDate)).toList();
    final locked =
        allCapsules.where((c) => now.isBefore(c.deliveryDate)).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            l10n.vaultTitle, // ✅ Translated
            style: const TextStyle(
                fontFamily: 'Poppins', fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                  text: l10n.tabUnlocked,
                  icon: const Icon(Icons.lock_open)), // ✅ Translated
              Tab(
                  text: l10n.tabLocked,
                  icon: const Icon(Icons.lock_outline)), // ✅ Translated
            ],
            indicatorColor: const Color(0xFF8E97FD),
            labelColor: const Color(0xFF8E97FD),
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(context, unlocked, l10n), // Pass l10n
            _buildList(context, locked, l10n),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF8E97FD),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const CreateCapsuleScreen()),
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildList(
      BuildContext context, List<TimeCapsule> list, AppLocalizations l10n) {
    if (list.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            l10n.vaultEmpty, // ✅ Translated
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final capsule = list[index];

        // Check readiness exactly when the item is rendered/tapped
        final bool isReadyNow = DateTime.now().isAfter(capsule.deliveryDate);

        return CapsuleCard(
          capsule: capsule,
          onTap: () {
            if (isReadyNow) {
              // Open content immediately if the clock has passed the delivery time
              _showContent(context, capsule, l10n);
            } else {
              // Show time remaining if it's still in the future
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  // ✅ Translated with dynamic parameter
                  content: Text(l10n.patienceMessage(
                      _getTimeRemainingText(capsule, l10n))),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
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
    // ✅ Format date based on current language locale
    final dateStr = DateFormat('MMMM dd, yyyy', l10n.localeName)
        .format(capsule.createdAt);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
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
              l10n.messageFromPast, // ✅ Translated
              style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins'),
            ),
            const SizedBox(height: 15),
            Text(
              capsule.content,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontStyle: FontStyle.italic,
                height: 1.5,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),
            Divider(color: Colors.grey[300]),
            const SizedBox(height: 10),
            Text(
              l10n.sealedOn(dateStr), // ✅ Translated
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8E97FD),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(l10n.close, // ✅ Translated
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}