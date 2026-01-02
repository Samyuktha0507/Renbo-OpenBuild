import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../services/journal_storage.dart';
import '../models/journal_entry.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class JournalEditScreen extends StatefulWidget {
  final JournalEntry entry;

  const JournalEditScreen({Key? key, required this.entry}) : super(key: key);

  @override
  State<JournalEditScreen> createState() => _JournalEditScreenState();
}

class _JournalEditScreenState extends State<JournalEditScreen> {
  late TextEditingController _controller;
  File? pickedImage;
  String? recordedAudioPath;
  bool isRecording = false;
  final AudioRecorder _audioRecorder = AudioRecorder();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.entry.content);
    pickedImage =
        widget.entry.imagePath != null ? File(widget.entry.imagePath!) : null;
    recordedAudioPath = widget.entry.audioPath;
  }

  @override
  void dispose() {
    _controller.dispose();
    _audioRecorder.dispose();
    super.dispose();
  }

  void _saveEntry(AppLocalizations l10n) async {
    final text = _controller.text.trim();
    if (text.isEmpty && pickedImage == null && recordedAudioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.emptyEntryError), // ✅ Translated
        ),
      );
      return;
    }

    final updatedEntry = JournalEntry(
      id: widget.entry.id,
      content: text,
      timestamp: widget.entry.timestamp,
      emotion: widget.entry.emotion,
      imagePath: pickedImage?.path,
      audioPath: recordedAudioPath,
    );

    await JournalStorage.updateEntry(updatedEntry);

    Navigator.of(context).pop();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => pickedImage = File(image.path));
  }

  Future<void> _startStopRecording(AppLocalizations l10n) async {
    if (await _audioRecorder.isRecording()) {
      final path = await _audioRecorder.stop();
      setState(() {
        isRecording = false;
        recordedAudioPath = path;
      });
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.recordingStopped))); // ✅ Translated
      }
    } else {
      if (await _audioRecorder.hasPermission()) {
        final tempDir = await getTemporaryDirectory();
        final path =
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);

        setState(() => isRecording = true);
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.recordingStarted))); // ✅ Translated
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.permissionDenied))); // ✅ Translated
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFFF5F2),
      appBar: AppBar(
        title: Text(l10n.editJournalEntry, // ✅ Translated
            style: const TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color(0xFF568F87),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  TextField(
                    controller: _controller,
                    maxLines: null,
                    expands: true,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: l10n.editEntryHint, // ✅ Translated
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  if (pickedImage != null)
                    Positioned.fill(
                        child: Image.file(pickedImage!, fit: BoxFit.cover))
                  else if (widget.entry.imagePath != null &&
                      widget.entry.imagePath!.isNotEmpty)
                    Positioned.fill(
                        child: widget.entry.imagePath!.startsWith('http')
                            ? Image.network(widget.entry.imagePath!,
                                fit: BoxFit.cover)
                            : Image.file(File(widget.entry.imagePath!),
                                fit: BoxFit.cover)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _startStopRecording(l10n),
                  icon: Icon(isRecording ? Icons.stop : Icons.mic,
                      color: Colors.white),
                  label: Text(isRecording ? l10n.stopRecording : l10n.recordAudio, // ✅ Translated
                      style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isRecording ? Colors.red : const Color(0xFF568F87),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _pickImage,
                  icon: const Icon(Icons.image, color: Colors.white),
                  label: Text(l10n.changeImage, // ✅ Translated
                      style: const TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF568F87)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF568F87),
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18)),
              ),
              onPressed: () => _saveEntry(l10n),
              child: Text(l10n.saveChanges), // ✅ Translated
            ),
          ],
        ),
      ),
    );
  }
}