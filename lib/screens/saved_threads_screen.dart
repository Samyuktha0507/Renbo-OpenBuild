import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/widgets/chat_bubble.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class SavedThreadsScreen extends StatelessWidget {
  const SavedThreadsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.savedConversationsTitle, // ✅ Translated
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .collection('saved_threads')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history_edu_rounded,
                      size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(l10n.noSavedThreads, // ✅ Translated
                      style: const TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final doc = snapshot.data!.docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final title = data['title'] ?? l10n.defaultChatSession; // ✅ Translated
              final timestamp = (data['timestamp'] as Timestamp?)?.toDate();

              String dateText = "";
              if (timestamp != null) {
                final dateStr = "${timestamp.day}/${timestamp.month}";
                final timeStr = "${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
                // ✅ Uses translation format "Date at Time"
                dateText = l10n.dateAtTime(dateStr, timeStr); 
              }

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: AppTheme.primaryColor,
                    child: Icon(Icons.chat_bubble_outline,
                        color: Colors.white, size: 20),
                  ),
                  title: Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Text(dateText),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ThreadDetailView(
                          title: title,
                          messages: List<Map<String, dynamic>>.from(data['messages']),
                          docId: doc.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ThreadDetailView extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> messages;
  final String docId;

  const ThreadDetailView(
      {super.key,
      required this.title,
      required this.messages,
      required this.docId});

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () => _confirmDelete(context, l10n), // Pass l10n
          )
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: messages.length,
        itemBuilder: (context, index) {
          final msg = messages[index];
          final isSender = msg['sender'] == 'user';
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              mainAxisAlignment:
                  isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: [
                Flexible(
                  child: ChatBubble(text: msg['text']!, isSender: isSender),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _confirmDelete(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteThreadTitle), // ✅ Translated
        content: Text(l10n.deleteThreadContent), // ✅ Translated
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancel)), // ✅ Translated
          TextButton(
            onPressed: () async {
              final uid = FirebaseAuth.instance.currentUser?.uid;
              await FirebaseFirestore.instance
                  .collection('users')
                  .doc(uid)
                  .collection('saved_threads')
                  .doc(docId)
                  .delete();
              Navigator.pop(context); 
              Navigator.pop(context); 
            },
            child: Text(l10n.delete, style: const TextStyle(color: Colors.red)), // ✅ Translated
          ),
        ],
      ),
    );
  }
}