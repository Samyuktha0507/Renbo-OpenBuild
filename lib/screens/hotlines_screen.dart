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
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      debugPrint('Could not launch phone dialer for $phoneNumber');
      throw 'Could not launch $phoneNumber';
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    // ✅ Define Data INSIDE build to use translations
    final List<Hotline> hotlines = [
      Hotline(
        name: l10n.hotlineKiran, // ✅ Translated
        description: l10n.descKiran, // ✅ Translated
        contactPerson: l10n.personKiran, // ✅ Translated
        phone: "18005990019",
      ),
      Hotline(
        name: l10n.hotlineVandrevala, // ✅ Translated
        description: l10n.descVandrevala, // ✅ Translated
        contactPerson: l10n.personVandrevala, // ✅ Translated
        phone: "18602662345",
      ),
      Hotline(
        name: l10n.hotlineSnehi, // ✅ Translated
        description: l10n.descSnehi, // ✅ Translated
        contactPerson: l10n.personSnehi, // ✅ Translated
        phone: "9582208181",
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.hotlinesTitle, // ✅ Translated
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: hotlines.length,
        itemBuilder: (context, index) {
          final hotline = hotlines[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 4,
            shadowColor: Colors.deepPurple.withOpacity(0.2),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
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
                    Text(hotline.description),
                    const SizedBox(height: 4),
                    Text(
                      l10n.contactPrefix(hotline.contactPerson), // ✅ Translated
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 28),
                tooltip: l10n.callTooltip(hotline.phone), // ✅ Translated
                onPressed: () => _makePhoneCall(hotline.phone),
              ),
            ),
          );
        },
      ),
    );
  }
}