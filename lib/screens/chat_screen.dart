import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:renbo/api/gemini_service.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/widgets/chat_bubble.dart';
import 'package:renbo/services/journal_storage.dart';
import 'package:renbo/screens/saved_threads_screen.dart';
import 'hotlines_screen.dart';

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

  Future<bool> _showEndSessionDialog() async {
    if (_messages.isEmpty) return true;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("End Session?"),
        content: const Text("Would you like to save this thread?"),
        actions: [
          TextButton(
            onPressed: () {
              JournalStorage.deleteTemporaryChat();
              Navigator.pop(context, true);
            },
            child: const Text("Discard", style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () async {
              // Now saves to saved_threads collection, not journal
              await JournalStorage.saveChatThread(
                messages: _messages,
                summary:
                    "Session: ${DateTime.now().day}/${DateTime.now().month} ${DateTime.now().hour}:${DateTime.now().minute}",
              );
              if (mounted) Navigator.pop(context, true);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor),
            child: const Text("Save Thread",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  void _sendMessage() async {
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
        if (classifiedResponse.isHarmful) _showHotlineSuggestion();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages.add(
              {'sender': 'bot', 'text': 'I am having trouble connecting. 😞'});
          _isLoading = false;
        });
      }
    }
  }

  void _showHotlineSuggestion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("You’re Not Alone"),
        content: const Text("Would you like to see help hotlines?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Not Now")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryColor),
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => HotlinesScreen()));
            },
            child: const Text("View Hotlines",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _toggleListening() async {
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
          _sendMessage();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showEndSessionDialog();
        if (shouldExit && mounted) Navigator.of(context).pop();
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Renbot Chat',
              style: TextStyle(fontWeight: FontWeight.bold)),
          actions: [
            // 🔥 Person A: New Button to view saved threads
            IconButton(
              icon: const Icon(Icons.history_edu_rounded),
              tooltip: 'Saved Threads',
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
                        // Removed Robot Avatar from here
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
            _buildMessageComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageComposer() {
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
                  hintText: _isListening ? "Listening..." : "Message...",
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
              onPressed: _toggleListening,
            ),
            IconButton(
              icon: const Icon(Icons.send, color: AppTheme.primaryColor),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}