import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:renbo/api/gemini_service.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/widgets/chat_bubble.dart';
import 'package:renbo/services/journal_storage.dart';
import 'package:renbo/screens/saved_threads_screen.dart';
import 'hotlines_screen.dart';
// ✅ Import Translations
import 'package:renbo/l10n/gen/app_localizations.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();

  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  bool _speechEnabled = false;

  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _speechToText.stop();
    _flutterTts.stop();
    super.dispose();
  }

  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      debugPrint("Speech init failed: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<bool> _showEndSessionDialog(AppLocalizations l10n) async {
    if (_messages.isEmpty) return true;

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface, // Adaptive Background
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          l10n.endSession, // ✅ Translated
          style: TextStyle(color: theme.textTheme.titleLarge?.color),
        ),
        content: Text(
          l10n.saveThreadQuestion, // ✅ Translated
          style: TextStyle(color: theme.textTheme.bodyMedium?.color),
        ),
        actions: [
          TextButton(
            onPressed: () {
              JournalStorage.deleteTemporaryChat();
              Navigator.pop(context, true);
            },
            child: Text(l10n.discard,
                style: const TextStyle(color: Colors.red)), // ✅ Translated
          ),
          ElevatedButton(
            onPressed: () async {
              final dateStr =
                  "${DateTime.now().day}/${DateTime.now().month} ${DateTime.now().hour}:${DateTime.now().minute}";

              await JournalStorage.saveChatThread(
                messages: _messages,
                summary: l10n.sessionDefaultTitle(dateStr), // ✅ Translated
              );
              if (mounted) Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary),
            child: Text(
              l10n.saveThread, // ✅ Translated
              style: TextStyle(
                  color: isDark ? AppTheme.darkBackground : Colors.white),
            ),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _sendMessage(AppLocalizations l10n) async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': text});
      _isLoading = true;
    });
    _controller.clear();
    _scrollToBottom();

    try {
      final classifiedResponse = await _geminiService.generateAndClassify(text);
      if (mounted) {
        setState(() {
          _messages.add({'sender': 'bot', 'text': classifiedResponse.response});
          _isLoading = false;
        });
        _scrollToBottom();
        if (classifiedResponse.isHarmful) _showHotlineSuggestion(l10n);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
              {'sender': 'bot', 'text': l10n.connectionError}); // ✅ Translated
          _isLoading = false;
        });
      }
    }
  }

  void _showHotlineSuggestion(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.colorScheme.surface,
        title: Text(l10n.youAreNotAlone, // ✅ Translated
            style: TextStyle(color: theme.textTheme.titleLarge?.color)),
        content: Text(l10n.hotlineQuestion, // ✅ Translated
            style: TextStyle(color: theme.textTheme.bodyMedium?.color)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.notNow)), // ✅ Translated
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => HotlinesScreen()));
            },
            child: Text(l10n.viewHotlines, // ✅ Translated
                style: TextStyle(
                    color: isDark ? AppTheme.darkBackground : Colors.white)),
          ),
        ],
      ),
    );
  }

  void _toggleListening(AppLocalizations l10n) async {
    if (!_speechEnabled) return;
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speechToText.listen(onResult: (result) {
        setState(() => _controller.text = result.recognizedWords);
        if (result.finalResult) {
          setState(() => _isListening = false);
          _sendMessage(l10n);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Helper for translations & Theme
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showEndSessionDialog(l10n);
        if (shouldExit && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor, // Adaptive background
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(l10n.chatTitle, // ✅ Translated
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
          iconTheme: IconThemeData(color: textColor),
          actions: [
            IconButton(
              icon: const Icon(Icons.history_edu_rounded),
              tooltip: l10n.savedThreads, // ✅ Translated
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SavedThreadsScreen()),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  final isSender = message['sender'] == 'user';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: isSender
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: ChatBubble(
                              text: message['text']!, isSender: isSender),
                        ),
                        if (!isSender)
                          IconButton(
                            icon: Icon(Icons.volume_up,
                                size: 18,
                                color: theme.colorScheme.secondary
                                    .withOpacity(0.6)),
                            onPressed: () =>
                                _flutterTts.speak(message['text']!),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
            if (_isLoading)
              const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircularProgressIndicator()),
            _buildMessageComposer(l10n), // Pass l10n
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer(AppLocalizations l10n) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface, // Adaptive surface
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                decoration: InputDecoration(
                  hintText: _isListening
                      ? l10n.listening
                      : l10n.messageHint, // ✅ Translated
                  hintStyle: TextStyle(
                      color: theme.textTheme.bodyMedium?.color
                          ?.withOpacity(0.5)),
                  filled: true,
                  fillColor: isDark
                      ? AppTheme.darkBackground
                      : AppTheme.lightGray, // Adaptive input fill
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : theme.colorScheme.primary),
              onPressed: () => _toggleListening(l10n),
            ),
            IconButton(
              icon: Icon(Icons.send, color: theme.colorScheme.primary),
              onPressed: () => _sendMessage(l10n),
            ),
          ],
        ),
      ),
    );
  }
}