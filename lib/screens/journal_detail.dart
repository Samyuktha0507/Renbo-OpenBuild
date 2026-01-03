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
    // Check if audio file exists before attempting to load
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

    // Calculate Canvas Height dynamically based on sticker positions to ensure scrollability
    double maxStickerY = 0;
    for (var s in _stickers) {
      if (s.y > maxStickerY) maxStickerY = s.y;
    }
    double requiredHeight = maxStickerY + 250;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(dateStr,
            style: TextStyle(color: textColor, fontWeight: FontWeight.w600)),
        backgroundColor: scaffoldBg,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
        actions: [
          // ✅ EDIT BUTTON: Navigates to JournalScreen in Edit Mode
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
            // Invisible spacer to expand the Stack height for stickers
            Container(
              height: requiredHeight < MediaQuery.of(context).size.height
                  ? MediaQuery.of(context).size.height
                  : requiredHeight,
              width: double.infinity,
            ),

            // Main Journal Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.entry.title ?? l10n.untitled, // ✅ Localized fallback
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Emotion Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                        color: primaryGreen,
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      widget.entry.emotion ?? "Neutral",
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 24),

                  Text(
                    widget.entry.content,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.6,
                      color: textColor?.withOpacity(0.9),
                    ),
                  ),

                  // Audio Player Section
                  if (_audioAvailable) ...[
                    const SizedBox(height: 30),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.play_circle_fill,
                              size: 50, color: primaryGreen),
                          onPressed: _audioPlayer.play,
                        ),
                        const SizedBox(width: 10),
                        Text(l10n.toolVoice, // Reusing localized 'Voice' label
                            style:
                                TextStyle(color: textColor?.withOpacity(0.6))),
                      ],
                    ),
                  ],

                  // Image Section
                  if (widget.entry.imagePath != null &&
                      widget.entry.imagePath!.isNotEmpty) ...[
                    const SizedBox(height: 30),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.file(
                        File(widget.entry.imagePath!),
                        errorBuilder: (context, error, stackTrace) =>
                            const SizedBox.shrink(),
                      ),
                    ),
                  ],
                  const SizedBox(height: 120), // Bottom padding for stickers
                ],
              ),
            ),

            // Sticker Overlay Layer
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

  // Helper to distinguish between emoji strings and asset paths
  bool _isEmoji(String text) => !text.startsWith('assets/');
}
