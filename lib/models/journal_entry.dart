import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class JournalEntry {
  String id;
  String content;
  DateTime timestamp;
  String? emotion;
  String? imagePath;
  String? audioPath;
  String? title; // ✅ Added Title
  String? stickersJson; // ✅ Added Stickers support

  JournalEntry({
    String? id,
    required this.content,
    required this.timestamp,
    this.emotion,
    this.imagePath,
    this.audioPath,
    this.title,
    this.stickersJson,
  }) : id = id ?? const Uuid().v4();

  // 🛠️ HELPER: Get the actual list of stickers
  List<JournalSticker> getStickers() {
    if (stickersJson == null) return [];
    try {
      final List<dynamic> decoded = jsonDecode(stickersJson!);
      return decoded.map((e) => JournalSticker.fromMap(e)).toList();
    } catch (e) {
      return [];
    }
  }

  // 🛠️ HELPER: Save the list back to string
  void setStickers(List<JournalSticker> list) {
    stickersJson = jsonEncode(list.map((e) => e.toMap()).toList());
  }

  // 🔥 FIRESTORE: Convert Object -> Map (For Saving)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'timestamp': Timestamp.fromDate(timestamp),
      'emotion': emotion,
      'imagePath': imagePath,
      'audioPath': audioPath,
      'title': title,
      'stickersJson': stickersJson,
    };
  }

  // 🔥 FIRESTORE: Convert Map -> Object (For Loading)
  factory JournalEntry.fromMap(Map<String, dynamic> map, String docId) {
    return JournalEntry(
      id: docId,
      content: map['content'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
      emotion: map['emotion'],
      imagePath: map['imagePath'],
      audioPath: map['audioPath'],
      title: map['title'],
      stickersJson: map['stickersJson'],
    );
  }
}

// ✅ STICKER CLASS (Required for the List<JournalSticker> to work)
class JournalSticker {
  String path;
  double x;
  double y;
  double scale;

  JournalSticker({required this.path, required this.x, required this.y, this.scale = 1.0});

  Map<String, dynamic> toMap() => {'path': path, 'x': x, 'y': y, 'scale': scale};

  factory JournalSticker.fromMap(Map<String, dynamic> map) {
    return JournalSticker(
      path: map['path'],
      x: (map['x'] ?? 0).toDouble(),
      y: (map['y'] ?? 0).toDouble(),
      scale: (map['scale'] ?? 1.0).toDouble(),
    );
  }
}