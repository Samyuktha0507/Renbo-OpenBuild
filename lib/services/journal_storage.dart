import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/journal_entry.dart';

class JournalStorage {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  // 1. Fixes 'Member not found: init'
  static Future<void> init() async {
    // Hive initialization is handled in main.dart,
    // but we keep this empty method so main.dart doesn't throw an error.
  }

  // 2. Add Entry
  // ✅ UPDATED: Uses .set() with entry.id to match the new Model's UUID
  // instead of letting Firestore generate a random ID.
  static Future<void> addEntry(JournalEntry entry) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    
    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(entry.id) // Use the ID from the model
        .set(entry.toMap()); // Use toMap() from new model
  }

  // 3. Get Entries (Future) - Used for Calendar
  // ✅ UPDATED: Uses fromMap
  static Future<List<JournalEntry>> getEntries() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return [];
    
    final snapshot = await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .get();
        
    return snapshot.docs
        .map((doc) => JournalEntry.fromMap(doc.data(), doc.id))
        .toList();
  }

  // 4. Get Entries (Stream) - Used for real-time List view
  // ✅ UPDATED: Uses fromMap
  static Stream<List<JournalEntry>> getEntriesStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    
    return _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => JournalEntry.fromMap(doc.data(), doc.id))
            .toList());
  }

  // 5. Update Entry - Used for Journal Edit Screen
  // ✅ UPDATED: Uses toMap
  static Future<void> updateEntry(JournalEntry entry) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || entry.id.isEmpty) return;
    
    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(entry.id)
        .update(entry.toMap());
  }

  // 6. Delete Entry
  // ✅ PRESERVED: Logic remains the same
  static Future<void> deleteEntry(String docId) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;
    
    await _db
        .collection('users')
        .doc(uid)
        .collection('journals')
        .doc(docId)
        .delete();
  }

  /// 🔥 NEW: Migration Bridge (Hive -> Firestore)
  /// ✅ PRESERVED: Kept logic, updated addEntry call
  static Future<void> migrateHiveToFirestore() async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return;

      // Note: This assumes JournalEntry still has a Hive Adapter generated.
      // If you removed @HiveType from the model, this might throw an error.
      // If so, you should comment this block out or create a temporary "OldJournalEntry" class.
      if (!Hive.isAdapterRegistered(0)) {
         debugPrint("Migration: Hive Adapter not registered. Skipping.");
         return;
      }

      var box = await Hive.openBox<JournalEntry>('journalBox');

      if (box.isEmpty) {
        debugPrint("Migration: Local Hive box is empty.");
        return;
      }

      debugPrint("Migration: Syncing ${box.length} local entries to cloud...");

      for (var entry in box.values) {
        // We use the updated addEntry which handles the new Firestore structure
        await addEntry(entry);
      }

      await box.clear();
      debugPrint("Migration: Success. Local data cleared.");
    } catch (e) {
      debugPrint("Migration Error: $e");
    }
  }

  /// 🔥 THREAD MANAGEMENT: Save a chat conversation
  /// ✅ PRESERVED: Logic remains exactly the same
  static Future<void> saveChatThread({
    required List<Map<String, String>> messages,
    required String summary,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    await _db.collection('users').doc(uid).collection('saved_threads').add({
      'title': summary,
      'messages': messages,
      'timestamp': FieldValue.serverTimestamp(),
      'isFavorite': false,
    });
    debugPrint("Chat thread saved to Firestore.");
  }

  /// 🔥 THREAD MANAGEMENT: Delete temporary chat history
  /// ✅ PRESERVED: Logic remains exactly the same
  static Future<void> deleteTemporaryChat() async {
    // This currently clears logic state;
    // if you implement a 'recent_chats' collection later, you'd delete docs here.
    debugPrint("Chat session discarded.");
  }
}