import 'dart:io';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../models/journal_entry.dart';
import '../utils/theme.dart';
import 'journal_screen.dart'; // ✅ Import this to navigate to Edit
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class JournalDetailScreen extends StatefulWidget {
  final JournalEntry entry;

  const JournalDetailScreen({required this.entry, Key? key}) : super(key: key);

  @override
  State<JournalDetailScreen> createState() => _JournalDetailScreenState();
}

class _JournalDetailScreenState extends State<JournalDetailScreen> {
  late final AudioPlayer _audioPlayer;
  bool _audioAvailable = false;
  late List<JournalSticker> _stickers;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    if (widget.entry.audioPath != null &&
        File(widget.entry.audioPath!).existsSync()) {
      _audioPlayer.setFilePath(widget.entry.audioPath!);
      _audioAvailable = true;
    }
    _stickers = widget.entry.getStickers();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Grab Dynamic Theme colors
    final theme = Theme.of(context);
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final textColor = theme.textTheme.bodyLarge?.color;
    final primaryGreen = theme.colorScheme.primary;

    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    final dateStr =
        "${widget.entry.timestamp.day}/${widget.entry.timestamp.month}/${widget.entry.timestamp.year}";

    // Calculate Canvas Height based on sticker positions
    double maxStickerY = 0;
    for (var s in _stickers) {
      if (s.y > maxStickerY) maxStickerY = s.y;
    }
    double requiredHeight = maxStickerY + 200;

    return Scaffold(
      backgroundColor: scaffoldBg, // Dynamic BG
      appBar: AppBar(
        title: Text(dateStr,
            style: TextStyle(color: textColor)), // Dynamic text color
        backgroundColor: scaffoldBg, // Dynamic App Bar BG
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          // ✅ EDIT BUTTON
          IconButton(
            icon: Icon(Icons.edit, color: primaryGreen),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalScreen(
                    selectedDate: widget.entry.timestamp,
                    emotion: widget.entry.emotion ?? "Neutral",
                    existingEntry: widget.entry, // ✅ PASS THE ENTRY TO EDIT
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Spacer for scroll height
            Container(
              height: requiredHeight < MediaQuery.of(context).size.height
                  ? MediaQuery.of(context).size.height
                  : requiredHeight,
              width: double.infinity,
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.entry.title ?? l10n.untitled, // ✅ Translated Fallback
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: textColor, // Dynamic text color
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Emotion Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      widget.entry.emotion ?? "Neutral",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    widget.entry.content,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                      color: textColor, // Dynamic text color
                    ),
                  ),
                  if (_audioAvailable) ...[
                    const SizedBox(height: 20),
                    IconButton(
                      icon: Icon(Icons.play_circle_fill,
                          size: 40, color: primaryGreen),
                      onPressed: _audioPlayer.play,
                    ),
                  ],
                  if (widget.entry.imagePath != null) ...[
                    const SizedBox(height: 20),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(File(widget.entry.imagePath!))),
                  ],
                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Stickers
            ..._stickers.map((sticker) {
              return Positioned(
                left: sticker.x,
                top: sticker.y,
                child: SizedBox(
                  height: 120,
                  width: 120,
                  child: _isEmoji(sticker.path)
                      ? Text(sticker.path, style: const TextStyle(fontSize: 80))
                      : Image.asset(sticker.path),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  bool _isEmoji(String text) => !text.startsWith('assets/');
}