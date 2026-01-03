import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class Hotline {
  final String name;
  final String description;
  final String contactPerson;
  final String phone;

  Hotline({
    required this.name,
    required this.description,
    required this.contactPerson,
    required this.phone,
  });
}

class HotlinesScreen extends StatelessWidget {
  const HotlinesScreen({super.key});

  /// Initiates a phone call to the provided [phoneNumber].
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrlUri(callUri);
      } else {
        debugPrint('Could not launch phone dialer for $phoneNumber');
      }
    } catch (e) {
      debugPrint('Error launching dialer: $e');
    }
  }

  /// Helper to handle standard URL launching in newer flutter versions
  Future<void> launchUrlUri(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    // ✅ Define Data INSIDE build to access the l10n context for translations
    final List<Hotline> hotlines = [
      Hotline(
        name: l10n.hotlineKiran,
        description: l10n.descKiran,
        contactPerson: l10n.personKiran,
        phone: "18005990019",
      ),
      Hotline(
        name: l10n.hotlineVandrevala,
        description: l10n.descVandrevala,
        contactPerson: l10n.personVandrevala,
        phone: "18602662345",
      ),
      Hotline(
        name: l10n.hotlineSnehi,
        description: l10n.descSnehi,
        contactPerson: l10n.personSnehi,
        phone: "9582208181",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.hotlinesTitle,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        itemCount: hotlines.length,
        itemBuilder: (context, index) {
          final hotline = hotlines[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            shadowColor: Colors.deepPurple.withOpacity(0.1),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              title: Text(
                hotline.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                  fontSize: 16,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hotline.description,
                      style: const TextStyle(fontSize: 14, height: 1.3),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      l10n.contactPrefix(hotline.contactPerson),
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.call, color: Colors.green, size: 26),
                  tooltip: l10n.callTooltip(hotline.phone),
                  onPressed: () => _makePhoneCall(hotline.phone),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
