// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Renbo';

  @override
  String get settings => 'Settings';

  @override
  String get selectLanguage => 'Select Language';

  @override
  String helloUser(String userName) {
    return 'Hello, $userName!';
  }

  @override
  String get thoughtOfDay => 'Thought of the day';

  @override
  String get selfCareCheckIn => 'Self-Care Check-in';

  @override
  String get hydrate => 'Hydrate';

  @override
  String get hydrateDesc =>
      'Water is fuel for resilience. Even a small sip can help clear the fog.';

  @override
  String get nourish => 'Nourish';

  @override
  String get nourishDesc =>
      'Your body needs energy to process big feelings. A gentle snack is self-love.';

  @override
  String get rest => 'Rest';

  @override
  String get restDesc =>
      'It is okay to hit the pause button. Recovery requires quiet moments.';

  @override
  String get breathe => 'Breathe';

  @override
  String get breatheDesc =>
      'Take one deep breath, just for you. Let the air ground you.';

  @override
  String get journal => 'Journal';

  @override
  String get chatRen => 'Chat with Ren';

  @override
  String get meditation => 'Meditation';

  @override
  String get game => 'Game';

  @override
  String get gratitude => 'Gratitude';

  @override
  String get vault => 'Vault';

  @override
  String get zenSpace => 'Zen Space';

  @override
  String get moodPulse => 'Mood Pulse';

  @override
  String get hotlines => 'Hotlines';

  @override
  String get cloudSyncComplete => 'Cloud Sync Complete';

  @override
  String get loadingThought => 'Loading a new thought...';

  @override
  String get defaultThought =>
      'The best way to predict the future is to create it.';

  @override
  String get breathingGuide => 'Breathing Guide';

  @override
  String get breatheIn => 'Breathe in';

  @override
  String get hold => 'Hold';

  @override
  String get breatheOut => 'Breathe out';

  @override
  String get startBreathing => 'Start Breathing';

  @override
  String get pauseBreathing => 'Pause';

  @override
  String get journalCalendar => 'Journal Calendar';

  @override
  String get newEntry => 'New Entry';

  @override
  String todayIs(String date) {
    return 'Today is $date';
  }

  @override
  String get viewAllEntries => 'View All Journal Entries';

  @override
  String get howAreYouFeeling => 'How are you feeling?';

  @override
  String get moodHappy => 'Happy';

  @override
  String get moodSad => 'Sad';

  @override
  String get moodAngry => 'Angry';

  @override
  String get moodConfused => 'Confused';

  @override
  String get moodExcited => 'Excited';

  @override
  String get moodCalm => 'Calm';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get vaultTitle => 'Emotional Vault';

  @override
  String get tabUnlocked => 'Unlocked';

  @override
  String get tabLocked => 'Locked';

  @override
  String get vaultEmpty => 'Your vault is currently empty.';

  @override
  String get readyToOpen => 'Ready to open!';

  @override
  String unlocksInDays(int count) {
    return 'Unlocks in ${count}d';
  }

  @override
  String unlocksInHours(int count) {
    return 'Unlocks in ${count}h';
  }

  @override
  String unlocksInMinutes(int count) {
    return 'Unlocks in ${count}m';
  }

  @override
  String unlocksInSeconds(int count) {
    return 'Unlocks in ${count}s';
  }

  @override
  String patienceMessage(String time) {
    return 'Patience! $time';
  }

  @override
  String get messageFromPast => 'A Message from the Past';

  @override
  String sealedOn(String date) {
    return 'Sealed on $date';
  }

  @override
  String get close => 'Close';

  @override
  String get chatTitle => 'Renbot Chat';

  @override
  String get endSession => 'End Session?';

  @override
  String get saveThreadQuestion => 'Would you like to save this thread?';

  @override
  String get discard => 'Discard';

  @override
  String get saveThread => 'Save Thread';

  @override
  String sessionDefaultTitle(String date) {
    return 'Session: $date';
  }

  @override
  String get connectionError => 'I am having trouble connecting. 😞';

  @override
  String get youAreNotAlone => 'You’re Not Alone';

  @override
  String get hotlineQuestion => 'Would you like to see help hotlines?';

  @override
  String get notNow => 'Not Now';

  @override
  String get viewHotlines => 'View Hotlines';

  @override
  String get savedThreads => 'Saved Threads';

  @override
  String get listening => 'Listening...';

  @override
  String get messageHint => 'Message...';

  @override
  String get newTimeCapsule => 'New Time Capsule';

  @override
  String get dearFutureMe => 'Dear future me...';

  @override
  String get unlocksAt => 'Unlocks at:';

  @override
  String get sealCapsule => 'Seal Capsule';

  @override
  String get capsuleEmptyError => 'Please write a message to your future self.';

  @override
  String get capsuleTimeError => 'Please select a time in the future.';

  @override
  String get capsuleSealed => 'Capsule sealed and sent to the future! 🚀';

  @override
  String get emotionHappy => '😊 Happy';

  @override
  String get emotionSad => '😢 Sad';

  @override
  String get emotionAngry => '😡 Angry';

  @override
  String get emotionTired => '😴 Tired';

  @override
  String get msgHappy => 'That\'s wonderful!';

  @override
  String get msgSad => 'I’m sorry you’re feeling this way.';

  @override
  String get msgAngry => 'It’s okay to feel upset.';

  @override
  String get msgTired => 'Rest is important, take it easy.';

  @override
  String get journalPrompt => 'Would you like to journal these emotions?';

  @override
  String get yesJournal => 'Yes, Journal';

  @override
  String get no => 'No';

  @override
  String get hotlinesTitle => 'Mental Wellness Hotlines';

  @override
  String callTooltip(String phone) {
    return 'Call $phone';
  }

  @override
  String contactPrefix(String person) {
    return 'Contact: $person';
  }

  @override
  String get hotlineKiran => 'KIRAN Mental Health Helpline';

  @override
  String get descKiran =>
      '24/7 support for stress, anxiety, depression, suicidal thoughts.';

  @override
  String get personKiran => 'Trained Mental Health Counselors';

  @override
  String get hotlineVandrevala => 'Vandrevala Foundation Helpline';

  @override
  String get descVandrevala =>
      'Support for emotional distress, depression, suicidal thoughts.';

  @override
  String get personVandrevala => 'Counselors at Vandrevala Foundation';

  @override
  String get hotlineSnehi => 'Snehi (Delhi-based NGO)';

  @override
  String get descSnehi =>
      'Emotional support for suicide prevention & crisis intervention.';

  @override
  String get personSnehi => 'Snehi Volunteer Counselors';

  @override
  String get untitled => 'Untitled';

  @override
  String get editJournalEntry => 'Edit Journal Entry';

  @override
  String get editEntryHint => 'Edit your entry...';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get changeImage => 'Change Image';

  @override
  String get recordAudio => 'Record Audio';

  @override
  String get stopRecording => 'Stop';

  @override
  String get recordingStopped => 'Recording stopped';

  @override
  String get recordingStarted => 'Recording started';

  @override
  String get permissionDenied => 'Permission denied';

  @override
  String get emptyEntryError =>
      'Please write, record, or add an image before saving.';

  @override
  String get noEntriesYet => 'No entries yet.\nStart your journey today!';

  @override
  String get noEntriesForDay => 'No entries for this day.\nTap here to write!';

  @override
  String get monthLabel => 'Month';

  @override
  String get journalTitleHint => 'Title...';

  @override
  String get journalContentHint => 'How was your day?';

  @override
  String get untitledEntry => 'Untitled Entry';

  @override
  String get entryUpdated => 'Entry Updated!';

  @override
  String get toolSticker => 'Sticker';

  @override
  String get toolPhoto => 'Photo';

  @override
  String get toolVoice => 'Voice';

  @override
  String get toolType => 'Type';

  @override
  String get toolRead => 'Read';

  @override
  String get whiteNoise => 'White Noise';

  @override
  String get chooseTrack => 'Choose a track:';

  @override
  String get reset => 'Reset';

  @override
  String get start => 'Start';

  @override
  String get moodPulseTitle => 'Mood Pulse';

  @override
  String get defaultFeedback =>
      'Move the sliders to show how you\'re feeling right now.';

  @override
  String get defaultAdvice => 'We can take it one step at a time.';

  @override
  String get feedbackOverwhelmed =>
      'Everything feels loud and blurry right now. It\'s high-intensity chaos.';

  @override
  String get adviceGrounding =>
      'Advice: Your only job right now is to breathe. Try the 5-4-3-2-1 grounding technique: name 5 things you see, 4 things you can touch.';

  @override
  String get feedbackSharp =>
      'You\'re feeling a sharp, clear sense of distress or frustration.';

  @override
  String get adviceExitEnergy =>
      'Advice: This energy needs an exit. Try a \'cold water shock\' on your face or a quick, vigorous movement to reset your nervous system.';

  @override
  String get feedbackHeavy =>
      'You\'re carrying a heavy, foggy weight. It feels hard to even identify the \'why\'.';

  @override
  String get adviceComfort =>
      'Advice: Don\'t fight the fog. Just focus on small comforts—a warm drink, a soft blanket, or dimming the lights.';

  @override
  String get feedbackSadness =>
      'There is a quiet, clear sadness or disappointment present.';

  @override
  String get adviceValidate =>
      'Advice: It\'s okay to sit with this. Try writing down just three words that describe this weight. Validating it helps it pass.';

  @override
  String get feedbackHaze =>
      'You\'re in a bit of a mental haze. Things feel a bit disconnected.';

  @override
  String get adviceDigitalFast =>
      'Advice: Your brain might be overstimulated. Try a 10-minute \'digital fast\'—put the phone away and look at something distant out a window.';

  @override
  String get feedbackFlow =>
      'You\'re in a beautiful state of flow and clarity.';

  @override
  String get adviceCreativity =>
      'Advice: This is a great time for creativity or connection. Carry this light with you into your next task.';

  @override
  String get feedbackDreamy =>
      'You\'re feeling a gentle, dreamy kind of happiness.';

  @override
  String get adviceDaydream =>
      'Advice: Let yourself daydream. You don\'t need to be productive right now. Just enjoy the warmth.';

  @override
  String get feedbackBalanced =>
      'You\'re finding your balance in a steady, middle space.';

  @override
  String get adviceCheckBody =>
      'Advice: Keep checking in with your body. Notice if your shoulders are tense and let them drop.';

  @override
  String get labelFoggy => 'Foggy';

  @override
  String get labelClear => 'Clear';

  @override
  String get labelNegative => 'Negative';

  @override
  String get labelPositive => 'Positive';

  @override
  String get labelSoftEnergy => 'Soft Energy';

  @override
  String get labelHighIntensity => 'High Intensity';

  @override
  String get btnFeelHeard => 'I feel heard';

  @override
  String get zenSpaceTitle => 'Zen Space';

  @override
  String get zenInstructions => 'Tap to ripple, Hold to glow';

  @override
  String get zenQuiet => 'Quiet';

  @override
  String get zenSteady => 'Steady';

  @override
  String get zenVibrant => 'Vibrant';

  @override
  String get savedConversationsTitle => 'Saved Conversations';

  @override
  String get noSavedThreads => 'No saved threads yet.';

  @override
  String get defaultChatSession => 'Chat Session';

  @override
  String get deleteThreadTitle => 'Delete Thread?';

  @override
  String get deleteThreadContent =>
      'This will permanently remove this conversation.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String dateAtTime(String date, String time) {
    return '$date at $time';
  }

  @override
  String get sessionsTitle => 'Sessions';

  @override
  String get upcomingSession => 'Upcoming Session';

  @override
  String get allSessions => 'All Sessions';

  @override
  String get clinicalPsychology => 'Clinical Psychology';

  @override
  String get counseling => 'Counseling';

  @override
  String get reschedule => 'Reschedule';

  @override
  String get joinNow => 'Join Now';

  @override
  String get rebook => 'Re-book';

  @override
  String get tapToMove => 'Tap the ball to move it.';

  @override
  String get relaxAndEnjoy => 'Just relax and enjoy.';

  @override
  String get whiteNoiseTitle => 'White Noise Synthesizer';

  @override
  String get mixFrequency => 'Mix your desired frequency:';

  @override
  String get goBack => 'Go Back';

  @override
  String get noiseWhite => 'WHITE Noise';

  @override
  String get noisePink => 'PINK Noise';

  @override
  String get noiseBrown => 'BROWN Noise';

  @override
  String get gratitudeTitle => 'Gratitude Bubbles';

  @override
  String get addGratitude => 'Add a Gratitude';

  @override
  String get gratitudeHint => 'What are you grateful for today?';

  @override
  String get add => 'Add';

  @override
  String get noGratitudes => 'No gratitudes yet. Add one to see it float!';
}
