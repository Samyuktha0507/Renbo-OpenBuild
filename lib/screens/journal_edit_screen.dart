import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import '../services/journal_storage.dart';
import '../models/journal_entry.dart';
import '../utils/theme.dart';
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

    // Validate if the entry is completely empty
    if (text.isEmpty && pickedImage == null && recordedAudioPath == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(l10n.emptyEntryError), // ✅ Translated
        ),
      );
      return;
    }

    final updatedEntry = JournalEntry(
      id: widget.entry.id, // Keep the same ID for updating
      content: text,
      timestamp: widget.entry.timestamp, // Maintain original date
      emotion: widget.entry.emotion,
      imagePath: pickedImage?.path,
      audioPath: recordedAudioPath,
    );

    await JournalStorage.updateEntry(updatedEntry);

    if (mounted) Navigator.of(context).pop();
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
            .showSnackBar(SnackBar(content: Text(l10n.recordingStopped)));
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
              .showSnackBar(SnackBar(content: Text(l10n.recordingStarted)));
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(l10n.permissionDenied)));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Dynamic Theme Colors
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final scaffoldBg = theme.scaffoldBackgroundColor;
    final surfaceColor = theme.colorScheme.surface;
    final textColor = theme.textTheme.bodyLarge?.color;
    final primaryGreen = theme.colorScheme.primary;

    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: scaffoldBg,
      appBar: AppBar(
        title: Text(l10n.editJournalEntry, // ✅ Translated
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: scaffoldBg,
        elevation: 0,
        iconTheme: IconThemeData(color: textColor),
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
                    style: TextStyle(color: textColor),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: surfaceColor,
                      hintText: l10n.editEntryHint, // ✅ Translated
                      hintStyle: TextStyle(color: textColor?.withOpacity(0.5)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  // Small thumbnail if image exists (overlay style)
                  if (pickedImage != null ||
                      (widget.entry.imagePath?.isNotEmpty ?? false))
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SizedBox(
                          width: 100,
                          height: 100,
                          child: pickedImage != null
                              ? Image.file(pickedImage!, fit: BoxFit.cover)
                              : (widget.entry.imagePath!.startsWith('http')
                                  ? Image.network(widget.entry.imagePath!,
                                      fit: BoxFit.cover)
                                  : Image.file(File(widget.entry.imagePath!),
                                      fit: BoxFit.cover)),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  onPressed: () => _startStopRecording(l10n),
                  icon: isRecording ? Icons.stop : Icons.mic,
                  label: isRecording
                      ? l10n.stopRecording
                      : l10n.recordAudio, // ✅ Translated
                  color: isRecording ? Colors.red : primaryGreen,
                  textColor: isDark ? AppTheme.darkBackground : Colors.white,
                ),
                _buildActionButton(
                  onPressed: _pickImage,
                  icon: Icons.image,
                  label: l10n.changeImage, // ✅ Translated
                  color: primaryGreen,
                  textColor: isDark ? AppTheme.darkBackground : Colors.white,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryGreen,
                  foregroundColor:
                      isDark ? AppTheme.darkBackground : Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18)),
                ),
                onPressed: () => _saveEntry(l10n),
                child: Text(l10n.saveChanges, // ✅ Translated
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required VoidCallback onPressed,
    required IconData icon,
    required String label,
    required Color color,
    required Color textColor,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: textColor, size: 20),
      label: Text(label, style: TextStyle(color: textColor, fontSize: 12)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
