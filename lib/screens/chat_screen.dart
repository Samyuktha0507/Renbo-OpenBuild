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

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.endSession), // ✅ Translated
        content: Text(l10n.saveThreadQuestion), // ✅ Translated
        actions: [
          TextButton(
            onPressed: () {
              JournalStorage.deleteTemporaryChat();
              Navigator.pop(context, true);
            },
            child: Text(l10n.discard, style: const TextStyle(color: Colors.red)), // ✅ Translated
          ),
          ElevatedButton(
            onPressed: () async {
              // Create dynamic date string
              final dateStr = "${DateTime.now().day}/${DateTime.now().month} ${DateTime.now().hour}:${DateTime.now().minute}";
              
              await JournalStorage.saveChatThread(
                messages: _messages,
                // ✅ Translated Summary
                summary: l10n.sessionDefaultTitle(dateStr), 
              );
              if (mounted) Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor),
            child: Text(l10n.saveThread, // ✅ Translated
                style: const TextStyle(color: Colors.white)),
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
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.youAreNotAlone), // ✅ Translated
        content: Text(l10n.hotlineQuestion), // ✅ Translated
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.notNow)), // ✅ Translated
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HotlinesScreen()));
            },
            child: Text(l10n.viewHotlines, // ✅ Translated
                style: const TextStyle(color: Colors.white)),
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
    // ✅ Helper for translations
    final l10n = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showEndSessionDialog(l10n);
        if (shouldExit && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(l10n.chatTitle, // ✅ Translated
              style: const TextStyle(fontWeight: FontWeight.bold)),
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
                            icon: const Icon(Icons.volume_up,
                                size: 18, color: Colors.grey),
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
            _buildMessageComposer(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: _isListening ? l10n.listening : l10n.messageHint, // ✅ Translated
                  filled: true,
                  fillColor: AppTheme.lightGray,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none),
                ),
              ),
            ),
            IconButton(
              icon: Icon(_isListening ? Icons.mic : Icons.mic_none,
                  color: _isListening ? Colors.red : AppTheme.primaryColor),
              onPressed: () => _toggleListening(l10n),
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppTheme.primaryColor),
              onPressed: () => _sendMessage(l10n),
            ),
          ],
        ),
      ),
    );
  }
}