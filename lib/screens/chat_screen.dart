import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:renbo/api/gemini_service.dart';
import 'package:renbo/utils/theme.dart';
import 'package:renbo/widgets/chat_bubble.dart';
import 'package:renbo/screens/saved_threads_screen.dart';
import 'package:renbo/services/analytics_service.dart';

class ChatScreen extends StatefulWidget {
  final String? threadId;
  final String? existingTitle;

  const ChatScreen({super.key, this.threadId, this.existingTitle});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final GeminiService _geminiService = GeminiService();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final SpeechToText _speechToText = SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  bool _speechEnabled = false;
  bool _isLoading = false;
  bool _isProcessingResult = false;
  bool _hasUnsavedChanges = false;

  String? _currentThreadId;
  String _selectedLanguageName = "English";
  String _selectedLocaleId = "en-US";

  final Map<String, String> _languageLocales = {
    'English': 'en-US',
    'Hindi': 'hi-IN',
    'Tamil': 'ta-IN',
    'Telugu': 'te-IN',
  };

  @override
  void initState() {
    super.initState();
    AnalyticsService.startFeatureSession();
    _currentThreadId = widget.threadId;
    _initSpeech();
    _setupTts();
  }

  @override
  void dispose() {
    AnalyticsService.endFeatureSession("Chat");
    _controller.dispose();
    _scrollController.dispose();
    _flutterTts.stop();
    _speechToText.stop();
    super.dispose();
  }

  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onError: (val) => debugPrint('STT Error: $val'),
      onStatus: (status) {
        if (status == 'notListening' || status == 'done') {
          if (mounted) setState(() => _isListening = false);
        }
      },
    );
    if (mounted) setState(() {});
  }

  Future<void> _setupTts() async {
    await _flutterTts.setSharedInstance(true);
    await _flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.playback,
      [IosTextToSpeechAudioCategoryOptions.defaultToSpeaker],
    );
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Save Conversation?"),
        content: const Text(
            "Would you like to keep this chat thread in your history?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: const Text("Discard", style: TextStyle(color: Colors.red)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'save'),
            child: const Text("Save"),
          ),
        ],
      ),
    );

    if (result == 'save') {
      await _promptAndSaveThreadName();
      return true;
    } else if (result == 'discard') {
      if (widget.threadId == null && _currentThreadId != null) {
        await _deleteCurrentThread();
      }
      return true;
    }
    return false;
  }

  Future<void> _promptAndSaveThreadName() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null || _currentThreadId == null) return;

    final nameController = TextEditingController();
    String? chosenName = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Name your thread"),
        content: TextField(
          controller: nameController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: "Enter name (optional)",
            helperText: "Leave blank for default (Thread-X)",
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, ""),
              child: const Text("Skip")),
          TextButton(
            onPressed: () => Navigator.pop(context, nameController.text.trim()),
            child: const Text("OK"),
          ),
        ],
      ),
    );

    String finalTitle = chosenName ?? "";
    if (finalTitle.isEmpty) {
      final snapshot = await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_threads')
          .get();
      finalTitle = "Thread-${snapshot.docs.length}";
    }

    await _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_threads')
        .doc(_currentThreadId)
        .update({'title': finalTitle});
  }

  Future<void> _deleteCurrentThread() async {
    final uid = _auth.currentUser?.uid;
    if (uid != null && _currentThreadId != null) {
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_threads')
          .doc(_currentThreadId)
          .delete();
    }
  }

  Future<String> _ensureThreadExists() async {
    if (_currentThreadId != null) return _currentThreadId!;
    final uid = _auth.currentUser!.uid;

    final threadDoc = await _firestore
        .collection('users')
        .doc(uid)
        .collection('saved_threads')
        .add({
      'title': 'New Chat...',
      'timestamp': FieldValue.serverTimestamp(),
    });
    setState(() => _currentThreadId = threadDoc.id);
    return threadDoc.id;
  }

  void _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _isListening = false;
    });
    _controller.clear();

    try {
      final threadId = await _ensureThreadExists();
      final uid = _auth.currentUser!.uid;

      // 1. Save User Message
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_threads')
          .doc(threadId)
          .collection('messages')
          .add({
        'text': text,
        'sender': 'user',
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 2. Get AI Response
      // Note: If your GeminiService only takes 1 argument, remove _selectedLanguageName
      final response =
          await _geminiService.generateAndClassify(text, _selectedLanguageName);

      // 3. Save Bot Message
      await _firestore
          .collection('users')
          .doc(uid)
          .collection('saved_threads')
          .doc(threadId)
          .collection('messages')
          .add({
        'text': response.response,
        'sender': 'bot',
        'timestamp': FieldValue.serverTimestamp(),
      });

      setState(() {
        _isLoading = false;
        _hasUnsavedChanges = true;
        _isProcessingResult = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isProcessingResult = false;
      });
      debugPrint("Chat Error: $e");
    }
  }

  void _toggleListening() async {
    if (!_speechEnabled) return;
    if (_isListening) {
      await _speechToText.stop();
      setState(() => _isListening = false);
    } else {
      setState(() => _isListening = true);
      await _speechToText.listen(
        localeId: _selectedLocaleId.replaceAll('-', '_'),
        onResult: (result) {
          setState(() => _controller.text = result.recognizedWords);
          if (result.finalResult && !_isProcessingResult) {
            _isProcessingResult = true;
            _sendMessage();
          }
        },
      );
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage(_selectedLocaleId);
    await _flutterTts.speak(text);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _showLanguagePicker() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: _languageLocales.keys.map((lang) {
          return ListTile(
            leading: const Icon(Icons.language),
            title: Text(lang),
            onTap: () {
              setState(() {
                _selectedLanguageName = lang;
                _selectedLocaleId = _languageLocales[lang]!;
              });
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _onWillPop();
        if (shouldPop && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.existingTitle ?? 'Renbot Chat'),
          actions: [
            IconButton(
              icon: const Icon(Icons.history_rounded,
                  color: AppTheme.primaryColor),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SavedThreadsScreen()),
                );
              },
            ),
            TextButton.icon(
              onPressed: _showLanguagePicker,
              icon: const Icon(Icons.translate, size: 18),
              label: Text(_selectedLanguageName),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _currentThreadId == null
                  ? const Center(child: Text("Say hello to start a session!"))
                  : StreamBuilder<QuerySnapshot>(
                      stream: _firestore
                          .collection('users')
                          .doc(_auth.currentUser?.uid)
                          .collection('saved_threads')
                          .doc(_currentThreadId)
                          .collection('messages')
                          .orderBy('timestamp', descending: false)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError)
                          return const Center(
                              child: Text("Error loading messages"));
                        if (!snapshot.hasData)
                          return const Center(
                              child: CircularProgressIndicator());

                        final docs = snapshot.data!.docs;
                        WidgetsBinding.instance
                            .addPostFrameCallback((_) => _scrollToBottom());

                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final data =
                                docs[index].data() as Map<String, dynamic>;
                            bool isBot = data['sender'] == 'bot';
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 16),
                              child: Row(
                                mainAxisAlignment: isBot
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.end,
                                children: [
                                  if (isBot)
                                    IconButton(
                                      icon:
                                          const Icon(Icons.volume_up, size: 18),
                                      onPressed: () =>
                                          _speak(data['text'] ?? ""),
                                    ),
                                  Flexible(
                                    child: ChatBubble(
                                      text: data['text'] ?? "",
                                      isSender: !isBot,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            if (_isLoading) const LinearProgressIndicator(),
            _buildComposer(),
          ],
        ),
      ),
    );
  }

  Widget _buildComposer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black12)),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: _isListening ? "Listening..." : "Message...",
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
            ),
            IconButton(
              icon: Icon(
                _isListening ? Icons.mic : Icons.mic_none,
                color: _isListening ? Colors.red : AppTheme.primaryColor,
              ),
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
