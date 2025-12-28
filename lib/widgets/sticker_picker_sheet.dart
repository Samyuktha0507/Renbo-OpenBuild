import 'package:flutter/material.dart';
import '../utils/theme.dart'; 

class StickerPickerSheet extends StatefulWidget {
  final Function(String) onStickerSelected;

  const StickerPickerSheet({super.key, required this.onStickerSelected});

  @override
  State<StickerPickerSheet> createState() => _StickerPickerSheetState();
}

class _StickerPickerSheetState extends State<StickerPickerSheet> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ---------------------------------------------------------------------------
  // 🐼 TAB 1: RENBO (Your Pandas)
  // ---------------------------------------------------------------------------
  final List<String> renboStickers = const [
    'assets/stickers/panda.png',
    'assets/stickers/panda (1).png',
    'assets/stickers/panda (2).png',
    'assets/stickers/panda (3).png',
    'assets/stickers/panda (4).png',
    'assets/stickers/panda (5).png',
    'assets/stickers/panda (6).png',
    'assets/stickers/panda (7).png',
    'assets/stickers/panda (8).png',
    'assets/stickers/happy-panda.png',
    'assets/stickers/heart-panda.png',
  ];

  // ---------------------------------------------------------------------------
  // ☕ TAB 2: VIBES (Coffee, Reading, Work)
  // ---------------------------------------------------------------------------
  final List<String> vibeStickers = const [
    'assets/stickers/barista.png',
    'assets/stickers/barista (1).png',
    'assets/stickers/breakfast.png',
    'assets/stickers/breakfast (1).png',
    'assets/stickers/drink.png',
    'assets/stickers/drink1.png',
    'assets/stickers/read.png',
    'assets/stickers/cozy.png',
    'assets/stickers/office-worker.png',
    'assets/stickers/office-worker (1).png',
  ];

  // ---------------------------------------------------------------------------
  // 🐱 TAB 3: MOODS (Cats & Emotions)
  // ---------------------------------------------------------------------------
  final List<String> moodStickers = const [
    'assets/stickers/happy-cat.png',
    'assets/stickers/sad-cat.png',
    'assets/stickers/heart-cat.png',
    'assets/stickers/sad.png',
    'assets/stickers/astonished.png',
    'assets/stickers/calm.png',
    'assets/stickers/sleepy.png',
    'assets/stickers/stare.png',
    'assets/stickers/dancing.png',
    'assets/stickers/celeb.png',
    'assets/stickers/hi.png',
    'assets/stickers/teddy-bear.png',
  ];

  // ---------------------------------------------------------------------------
  // 😊 TAB 4: EMOJIS (Standard)
  // ---------------------------------------------------------------------------
  final List<String> emojis = const [
    '😊', '😔', '😫', '😴', '🥰', 
    '🌿', '☕', '🌧️', '🧸', '🎵',
    '✨', '❤️', '🩹', '🧘', '🌟',
    '🔋', '🪫', '🛁', '🎧', '👟',
    '🕯️', '📖', '🍵', '🥐', '🧘‍♀️',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      decoration: const BoxDecoration(
        color: AppTheme.oatMilkBg,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          // Handle Bar
          Container(
            width: 40, height: 5,
            decoration: BoxDecoration(
              color: AppTheme.coffeeButton.withOpacity(0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 15),

          // 🏷️ THE TABS
          TabBar(
            controller: _tabController,
            labelColor: AppTheme.coffeeButton,       
            unselectedLabelColor: AppTheme.espressoText.withOpacity(0.5), 
            indicatorColor: AppTheme.matchaGreen,    
            indicatorWeight: 3,
            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: const [
              Tab(text: "Renbo"), // Pandas
              Tab(text: "Vibes"), // Coffee/Work
              Tab(text: "Moods"), // Cats/Emotions
              Tab(text: "Emojis"),
            ],
          ),

          // 🖼️ THE GRIDS
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildGrid(renboStickers, isEmoji: false),
                _buildGrid(vibeStickers, isEmoji: false),
                _buildGrid(moodStickers, isEmoji: false),
                _buildGrid(emojis, isEmoji: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper to build the grids
  Widget _buildGrid(List<String> items, {required bool isEmoji}) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isEmoji ? 5 : 4,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            widget.onStickerSelected(items[index]);
            Navigator.pop(context);
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            alignment: Alignment.center,
            child: isEmoji
                ? Text(items[index], style: const TextStyle(fontSize: 32))
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      items[index],
                      errorBuilder: (context, error, stackTrace) => 
                        const Icon(Icons.broken_image, color: Colors.grey, size: 20),
                    ),
                  ),
          ),
        );
      },
    );
  }
}