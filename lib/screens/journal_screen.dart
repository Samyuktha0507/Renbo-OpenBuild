import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../services/journal_storage.dart';
import '../models/journal_entry.dart';
import '../widgets/sticker_picker_sheet.dart';
import 'calendar_screen.dart';
import '../utils/theme.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class JournalScreen extends StatefulWidget {
  final DateTime selectedDate;
  final String emotion;
  final JournalEntry? existingEntry;

  const JournalScreen({
    Key? key,
    required this.selectedDate,
    required this.emotion,
    this.existingEntry,
  }) : super(key: key);

  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  final AudioRecorder _audioRecorder = AudioRecorder();
  final AudioPlayer _audioPlayer = AudioPlayer();
  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  File? pickedImage;
  String? recordedAudioPath;
  bool isRecording = false;
  bool _isListening = false;

  List<JournalSticker> stickers = [];

  @override
  void initState() {
    super.initState();

    if (widget.existingEntry != null) {
      // PRE-FILL DATA IF EDITING
      _titleController =
          TextEditingController(text: widget.existingEntry!.title);
      _contentController =
          TextEditingController(text: widget.existingEntry!.content);
      stickers = widget.existingEntry!.getStickers();

      if (widget.existingEntry!.imagePath != null) {
        pickedImage = File(widget.existingEntry!.imagePath!);
      }
      recordedAudioPath = widget.existingEntry!.audioPath;
    } else {
      // FRESH START
      _titleController = TextEditingController();
      _contentController = TextEditingController();
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    _flutterTts.stop();
    super.dispose();
  }

  void _saveEntry(AppLocalizations l10n) async {
    final title = _titleController.text.trim();
    final text = _contentController.text.trim();

    // Check if entry is completely empty
    if (title.isEmpty &&
        text.isEmpty &&
        pickedImage == null &&
        recordedAudioPath == null &&
        stickers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.emptyEntryError)),
      );
      return;
    }

    if (widget.existingEntry != null) {
      // UPDATE EXISTING ENTRY
      final entry = widget.existingEntry!;
      entry.title = title.isEmpty ? l10n.untitledEntry : title;
      entry.content = text;
      entry.imagePath = pickedImage?.path;
      entry.audioPath = recordedAudioPath;
      entry.setStickers(stickers);

      await JournalStorage.updateEntry(entry);

      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.entryUpdated)));
      }
    } else {
      // CREATE NEW ENTRY
      final entry = JournalEntry(
        title: title.isEmpty ? l10n.untitledEntry : title,
        content: text,
        timestamp: widget.selectedDate,
        emotion: widget.emotion,
        imagePath: pickedImage?.path,
        audioPath: recordedAudioPath,
      );
      entry.setStickers(stickers);
      await JournalStorage.addEntry(entry);
    }

    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const CalendarScreen()),
        (route) => false,
      );
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => pickedImage = File(image.path));
  }

  void _pickSticker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => StickerPickerSheet(
        onStickerSelected: (path) {
          setState(() {
            stickers.add(JournalSticker(
              path: path,
              x: 50,
              y: 200,
            ));
          });
        },
      ),
    );
  }

  Future<void> _startStopRecording() async {
    if (isRecording) {
      final path = await _audioRecorder.stop();
      setState(() {
        isRecording = false;
        recordedAudioPath = path;
      });
    } else {
      if (await _audioRecorder.hasPermission()) {
        final dir = await getApplicationDocumentsDirectory();
        final path = '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          isRecording = true;
          recordedAudioPath = null;
        });
      }
    }
  }

  Future<void> _toggleListening() async {
    if (_isListening) {
      setState(() => _isListening = false);
      await _speechToText.stop();
    } else {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speechToText.listen(onResult: (result) {
          setState(() {
            _contentController.text = result.recognizedWords;
          });
        });
      }
    }
  }

  Future<void> _speakText() async {
    if (_contentController.text.isNotEmpty) {
      await _flutterTts.speak(_contentController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    // Dynamic Colors based on current theme
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final primaryTextColor = theme.textTheme.titleLarge?.color;
    final secondaryTextColor = theme.textTheme.bodyMedium?.color;
    final surfaceColor = theme.colorScheme.surface;
    final accentGreen = theme.colorScheme.primary;

    final displayDate = widget.existingEntry?.timestamp ?? widget.selectedDate;
    final dateStr =
        "${displayDate.day}/${displayDate.month}/${displayDate.year}";

    // Dynamic height calculation for the sticker canvas
    double maxStickerY = 0;
    for (var s in stickers) {
      if (s.y > maxStickerY) maxStickerY = s.y;
    }
    double requiredHeight = maxStickerY + 250;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        backgroundColor: scaffoldBg,
        title: Text(
            widget.existingEntry != null
                ? l10n.editJournalEntry
                : "$dateStr • ${widget.emotion}",
            style: TextStyle(color: primaryTextColor, fontSize: 16)),
        centerTitle: true,
        iconTheme: IconThemeData(color: primaryTextColor),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () => _saveEntry(l10n),
              icon: Icon(Icons.check, color: accentGreen))
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  // Invisible Spacer to allow dragging stickers anywhere
                  Container(
                    height: requiredHeight < MediaQuery.of(context).size.height
                        ? MediaQuery.of(context).size.height
                        : requiredHeight,
                    width: double.infinity,
                  ),

                  // Text and Image Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: primaryTextColor),
                          decoration: InputDecoration(
                            hintText: l10n.journalTitleHint,
                            hintStyle: TextStyle(
                                color: secondaryTextColor?.withOpacity(0.5)),
                            border: InputBorder.none,
                          ),
                        ),
                        Divider(color: theme.dividerColor),
                        TextField(
                          controller: _contentController,
                          maxLines: null,
                          style: TextStyle(
                              fontSize: 16,
                              color: primaryTextColor,
                              height: 1.5),
                          decoration: InputDecoration(
                            hintText: l10n.journalContentHint,
                            hintStyle: TextStyle(
                                color: secondaryTextColor?.withOpacity(0.5)),
                            border: InputBorder.none,
                          ),
                        ),
                        if (pickedImage != null) ...[
                          const SizedBox(height: 20),
                          ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image.file(pickedImage!)),
                        ],
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),

                  // Sticker Layer
                  ...stickers.asMap().entries.map((entry) {
                    int idx = entry.key;
                    JournalSticker sticker = entry.value;

                    return Positioned(
                      left: sticker.x,
                      top: sticker.y,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            sticker.x += details.delta.dx;
                            sticker.y += details.delta.dy;
                          });
                        },
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: _isEmoji(sticker.path)
                                  ? Text(sticker.path,
                                      style: const TextStyle(fontSize: 80))
                                  : Image.asset(sticker.path),
                            ),
                            Positioned(
                              right: 0,
                              top: 0,
                              child: GestureDetector(
                                onTap: () =>
                                    setState(() => stickers.removeAt(idx)),
                                child: const CircleAvatar(
                                    radius: 12,
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.close,
                                        size: 16, color: Colors.white)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ),

          // Bottom Tool Bar
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(30)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(
                        theme.brightness == Brightness.dark ? 0.3 : 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5))
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _toolButton(Icons.emoji_emotions_outlined, l10n.toolSticker,
                        accentGreen, _pickSticker),
                    _toolButton(Icons.image_outlined, l10n.toolPhoto,
                        accentGreen, _pickImage),
                    _toolButton(
                        isRecording ? Icons.stop_circle : Icons.mic_none,
                        isRecording ? l10n.stopRecording : l10n.toolVoice,
                        isRecording ? Colors.red : accentGreen,
                        _startStopRecording),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _toolButton(
                        _isListening ? Icons.mic_off : Icons.keyboard_voice,
                        l10n.toolType,
                        _isListening ? Colors.red : AppTheme.cocoa,
                        _toggleListening),
                    _toolButton(Icons.volume_up_outlined, l10n.toolRead,
                        AppTheme.cocoa, _speakText),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _toolButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: color.withOpacity(0.1), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyLarge?.color)),
        ],
      ),
    );
  }

  bool _isEmoji(String text) => !text.startsWith('assets/');
}
