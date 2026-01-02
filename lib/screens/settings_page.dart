import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:renbo/providers/locale_provider.dart'; // Ensure this path is correct
import 'package:renbo/utils/theme.dart';
import 'package:renbo/l10n/gen/app_localizations.dart'; // Import Translations

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);
    final l10n = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.darkGray,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // User Info Section
          if (user != null) ...[
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppTheme.matchaGreen,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: const Text("Name", style: TextStyle(fontSize: 12, color: Colors.grey)),
              subtitle: Text(
                user.displayName ?? "User",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.email, color: AppTheme.matchaGreen),
              title: const Text("Email", style: TextStyle(fontSize: 12, color: Colors.grey)),
              subtitle: Text(
                user.email ?? "No Email",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const Divider(),
          ],

          // 🌍 LANGUAGE SELECTOR
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              l10n.selectLanguage, // "Select Language"
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 10),
          
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<Locale>(
                  value: provider.locale,
                  icon: const Icon(Icons.language, color: AppTheme.primaryColor),
                  isExpanded: true,
                  onChanged: (Locale? newLocale) {
                    if (newLocale != null) {
                      provider.setLocale(newLocale);
                    }
                  },
                  items: L10n.all.map((locale) {
                    final flag = _getFlag(locale.languageCode);
                    final name = L10n.getLanguageName(locale.languageCode);
                    
                    return DropdownMenuItem(
                      value: locale,
                      child: Row(
                        children: [
                          Text(flag, style: const TextStyle(fontSize: 24)),
                          const SizedBox(width: 12),
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16, 
                              fontWeight: FontWeight.w600,
                              color: AppTheme.darkGray
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
          
          // Sign Out Button
          ListTile(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/auth_check');
              }
            },
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text("Sign Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  // 🏳️ Helper to get the correct flag emoji
  String _getFlag(String code) {
    switch (code) {
      case 'es': return '🇪🇸'; // Spanish
      case 'en': return '🇺🇸'; // English (US)
      case 'hi': 
      case 'ta': 
      case 'te': 
      case 'ml': 
      case 'kn': 
        return '🇮🇳'; // All Indian languages get India flag
      default: return '🏳️';
    }
  }
}