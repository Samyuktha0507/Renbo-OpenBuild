// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get appTitle => 'ரென்போ';

  @override
  String get settings => 'அமைப்புகள்';

  @override
  String get selectLanguage => 'மொழியைத் தேர்ந்தெடுக்கவும்';

  @override
  String helloUser(String userName) {
    return 'வணக்கம், $userName!';
  }

  @override
  String get thoughtOfDay => 'இன்றைய சிந்தனை';

  @override
  String get selfCareCheckIn => 'சுய பாதுகாப்பு';

  @override
  String get hydrate => 'நீர் அருந்துதல்';

  @override
  String get hydrateDesc =>
      'தண்ணீர் உடலுக்கு முக்கியம். ஒரு சிறிய மிடறு கூட புத்துணர்ச்சி அளிக்கும்.';

  @override
  String get nourish => 'ஊட்டச்சத்து';

  @override
  String get nourishDesc =>
      'உணர்வுகளைக் கையாள உடலுக்கு ஆற்றல் தேவை. சத்தான சிற்றுண்டி அவசியம்.';

  @override
  String get rest => 'ஓய்வு';

  @override
  String get restDesc =>
      'சற்று ஓய்வெடுப்பது தவறு இல்லை. மன அமைதிக்கு ஓய்வு அவசியம்.';

  @override
  String get breathe => 'சுவாசம்';

  @override
  String get breatheDesc =>
      'ஆழமாக ஒரு மூச்சு விடுங்கள். அது உங்களை அமைதிப்படுத்தும்.';

  @override
  String get journal => 'நாட்குறிப்பு';

  @override
  String get chatRen => 'ரென் உடன் பேசுங்கள்';

  @override
  String get meditation => 'தியானம்';

  @override
  String get game => 'விளையாட்டு';

  @override
  String get gratitude => 'நன்றி உணர்வு';

  @override
  String get vault => 'பாதுகாப்பு பெட்டகம்';

  @override
  String get zenSpace => 'ஜென் ஸ்பேஸ்';

  @override
  String get moodPulse => 'மனநிலை துடிப்பு';

  @override
  String get hotlines => 'உதவி எண்கள்';

  @override
  String get cloudSyncComplete => 'கிளவுட் ஒத்திசைவு முடிந்தது';

  @override
  String get loadingThought => 'புதிய சிந்தனை வருகிறது...';

  @override
  String get defaultThought =>
      'எதிர்காலத்தை கணிக்க சிறந்த வழி அதை உருவாக்குவதே.';

  @override
  String get breathingGuide => 'மூச்சுப் பயிற்சி';

  @override
  String get breatheIn => 'மூச்சை இழுக்கவும்';

  @override
  String get hold => 'பிடித்து வைக்கவும்';

  @override
  String get breatheOut => 'மூச்சை விடவும்';

  @override
  String get startBreathing => 'தொடங்கவும்';

  @override
  String get pauseBreathing => 'நிறுத்தவும்';

  @override
  String get journalCalendar => 'நாட்குறிப்பு நாட்காட்டி';

  @override
  String get newEntry => 'புதிய பதிவு';

  @override
  String todayIs(String date) {
    return 'இன்று $date';
  }

  @override
  String get viewAllEntries => 'அனைத்து பதிவுகளையும் காண்க';

  @override
  String get howAreYouFeeling => 'நீங்கள் எப்படி உணர்கிறீர்கள்?';

  @override
  String get moodHappy => 'மகிழ்ச்சி';

  @override
  String get moodSad => 'சோகம்';

  @override
  String get moodAngry => 'கோபம்';

  @override
  String get moodConfused => 'குழப்பம்';

  @override
  String get moodExcited => 'உற்சாகம்';

  @override
  String get moodCalm => 'அமைதி';

  @override
  String get moodNeutral => 'நடுநிலை';

  @override
  String get vaultTitle => 'உணர்ச்சி பெட்டகம்';

  @override
  String get tabUnlocked => 'திறக்கப்பட்டது';

  @override
  String get tabLocked => 'பூட்டப்பட்டது';

  @override
  String get vaultEmpty => 'உங்கள் பெட்டகம் காலியாக உள்ளது.';

  @override
  String get readyToOpen => 'திறக்க தயாராக உள்ளது!';

  @override
  String unlocksInDays(int count) {
    return '$count நாட்களில் திறக்கும்';
  }

  @override
  String unlocksInHours(int count) {
    return '$count மணிநேரத்தில் திறக்கும்';
  }

  @override
  String unlocksInMinutes(int count) {
    return '$count நிமிடங்களில் திறக்கும்';
  }

  @override
  String unlocksInSeconds(int count) {
    return '$count வினாடிகளில் திறக்கும்';
  }

  @override
  String patienceMessage(String time) {
    return 'பொறுமை! $time';
  }

  @override
  String get messageFromPast => 'கடந்த காலத்திலிருந்து ஒரு செய்தி';

  @override
  String sealedOn(String date) {
    return 'மூடப்பட்டது: $date';
  }

  @override
  String get close => 'மூடு';

  @override
  String get chatTitle => 'ரென்போட் அரட்டை';

  @override
  String get endSession => 'அமர்வை முடிக்கவா?';

  @override
  String get saveThreadQuestion => 'இந்த உரையாடலை சேமிக்க விரும்புகிறீர்களா?';

  @override
  String get discard => 'அழிக்கவும்';

  @override
  String get saveThread => 'சேமிக்கவும்';

  @override
  String sessionDefaultTitle(String date) {
    return 'அமர்வு: $date';
  }

  @override
  String get connectionError => 'இணைப்பதில் சிக்கல் உள்ளது. 😞';

  @override
  String get youAreNotAlone => 'நீங்கள் தனியாக இல்லை';

  @override
  String get hotlineQuestion => 'உதவி எண்களைப் பார்க்க விரும்புகிறீர்களா?';

  @override
  String get notNow => 'இப்போது இல்லை';

  @override
  String get viewHotlines => 'எண்களைப் பார்க்கவும்';

  @override
  String get savedThreads => 'சேமிக்கப்பட்ட உரையாடல்கள்';

  @override
  String get listening => 'கேட்கிறது...';

  @override
  String get messageHint => 'செய்தி...';

  @override
  String get newTimeCapsule => 'புதிய டைம் கேப்ஸ்யூல்';

  @override
  String get dearFutureMe => 'அன்புள்ள எதிர்கால நான்...';

  @override
  String get unlocksAt => 'திறக்கும் நேரம்:';

  @override
  String get sealCapsule => 'கேப்ஸ்யூலை பூட்டு';

  @override
  String get capsuleEmptyError =>
      'உங்கள் எதிர்கால சுயத்திற்கு ஒரு செய்தியை எழுதவும்.';

  @override
  String get capsuleTimeError => 'எதிர்கால நேரத்தைத் தேர்ந்தெடுக்கவும்.';

  @override
  String get capsuleSealed =>
      'கேப்ஸ்யூல் பூட்டப்பட்டு எதிர்காலத்திற்கு அனுப்பப்பட்டது! 🚀';

  @override
  String get emotionHappy => '😊 மகிழ்ச்சி';

  @override
  String get emotionSad => '😢 சோகம்';

  @override
  String get emotionAngry => '😡 கோபம்';

  @override
  String get emotionTired => '😴 சோர்வு';

  @override
  String get msgHappy => 'அது மிக அருமை!';

  @override
  String get msgSad => 'நீங்கள் அப்படி உணர்வதற்கு வருந்துகிறேன்.';

  @override
  String get msgAngry => 'கோபப்படுவது தவறில்லை.';

  @override
  String get msgTired => 'ஓய்வு முக்கியம், சற்று இளைப்பாறுங்கள்.';

  @override
  String get journalPrompt => 'இதைப் பற்றி எழுத விரும்புகிறீர்களா?';

  @override
  String get yesJournal => 'ஆம், எழுதவும்';

  @override
  String get no => 'இல்லை';

  @override
  String get hotlinesTitle => 'மனநல உதவி எண்கள்';

  @override
  String callTooltip(String phone) {
    return '$phone-ஐ அழைக்கவும்';
  }

  @override
  String contactPrefix(String person) {
    return 'தொடர்பு: $person';
  }

  @override
  String get hotlineKiran => 'கிரண் மனநல உதவி எண்';

  @override
  String get descKiran => 'மன அழுத்தம், பதட்டம், மனச்சோர்வுக்கு 24/7 ஆதரவு.';

  @override
  String get personKiran => 'பயிற்சி பெற்ற ஆலோசகர்கள்';

  @override
  String get hotlineVandrevala => 'வாந்த்ரேவாலா அறக்கட்டளை';

  @override
  String get descVandrevala => 'மன உளைச்சல் மற்றும் மனச்சோர்வுக்கு ஆதரவு.';

  @override
  String get personVandrevala => 'அறக்கட்டளை ஆலோசகர்கள்';

  @override
  String get hotlineSnehi => 'ஸ்நேஹி (தொண்டு நிறுவனம்)';

  @override
  String get descSnehi => 'தற்கொலை தடுப்புக்கான உணர்ச்சி ஆதரவு.';

  @override
  String get personSnehi => 'ஸ்நேஹி தன்னார்வலர்கள்';

  @override
  String get untitled => 'தலைப்பு இல்லை';

  @override
  String get editJournalEntry => 'பதிவைத் திருத்தவும்';

  @override
  String get editEntryHint => 'உங்கள் பதிவைத் திருத்தவும்...';

  @override
  String get saveChanges => 'சேமிக்கவும்';

  @override
  String get changeImage => 'படத்தை மாற்றவும்';

  @override
  String get recordAudio => 'ஆடியோ பதிவு';

  @override
  String get stopRecording => 'நிறுத்து';

  @override
  String get recordingStopped => 'பதிவு நிறுத்தப்பட்டது';

  @override
  String get recordingStarted => 'பதிவு தொடங்கியது';

  @override
  String get permissionDenied => 'அனுமதி மறுக்கப்பட்டது';

  @override
  String get emptyEntryError =>
      'சேமிப்பதற்கு முன் எழுதவும், பதிவு செய்யவும் அல்லது படம் சேர்க்கவும்.';

  @override
  String get noEntriesYet =>
      'பதிவுகள் எதுவும் இல்லை.\nஉங்கள் பயணத்தை இன்றே தொடங்குங்கள்!';

  @override
  String get noEntriesForDay =>
      'இந்த நாளுக்கான பதிவுகள் இல்லை.\nஎழுத இங்கே தட்டவும்!';

  @override
  String get monthLabel => 'மாதம்';

  @override
  String get journalTitleHint => 'தலைப்பு...';

  @override
  String get journalContentHint => 'இன்று உங்கள் நாள் எப்படி இருந்தது?';

  @override
  String get untitledEntry => 'தலைப்பு இல்லாத பதிவு';

  @override
  String get entryUpdated => 'பதிவு புதுப்பிக்கப்பட்டது!';

  @override
  String get toolSticker => 'ஸ்டிக்கர்';

  @override
  String get toolPhoto => 'புகைப்படம்';

  @override
  String get toolVoice => 'குரல்';

  @override
  String get toolType => 'தட்டச்சு';

  @override
  String get toolRead => 'வாசி';

  @override
  String get whiteNoise => 'வெள்ளை இரைச்சல்';

  @override
  String get chooseTrack => 'இசையைத் தேர்ந்தெடுக்கவும்:';

  @override
  String get reset => 'மீட்டமை';

  @override
  String get start => 'தொடங்கு';

  @override
  String get moodPulseTitle => 'மனநிலை துடிப்பு';

  @override
  String get defaultFeedback =>
      'நீங்கள் எப்படி உணர்கிறீர்கள் என்பதைக் காட்ட ஸ்லைடர்களை நகர்த்தவும்.';

  @override
  String get defaultAdvice => 'நாம் ஒவ்வொரு படியாக முன்னேறலாம்.';

  @override
  String get feedbackOverwhelmed =>
      'எல்லாம் இரைச்சலாகவும் மங்கலாகவும் உணர்கிறது.';

  @override
  String get adviceGrounding =>
      'அறிவுரை: மூச்சு விடுங்கள். நீங்கள் பார்க்கும் 5 பொருட்களைப் பெயரிடுங்கள்.';

  @override
  String get feedbackSharp => 'கடுமையான விரக்தியை உணர்கிறீர்கள்.';

  @override
  String get adviceExitEnergy => 'அறிவுரை: முகத்தை குளிர்ந்த நீரில் கழுவவும்.';

  @override
  String get feedbackHeavy => 'கனமான உணர்வு உள்ளது. காரணம் தெரிவது கடினம்.';

  @override
  String get adviceComfort =>
      'அறிவுரை: சூடான பானம் அருந்தவும் அல்லது விளக்கை அணைக்கவும்.';

  @override
  String get feedbackSadness => 'அமைதியான சோகம் உள்ளது.';

  @override
  String get adviceValidate => 'அறிவுரை: இதை பற்றி எழுதுங்கள்.';

  @override
  String get feedbackHaze => 'மனம் குழப்பமாக உள்ளது.';

  @override
  String get adviceDigitalFast => 'அறிவுரை: 10 நிமிடம் போனை ஓரமாக வையுங்கள்.';

  @override
  String get feedbackFlow => 'நீங்கள் தெளிவான மனநிலையில் உள்ளீர்கள்.';

  @override
  String get adviceCreativity => 'அறிவுரை: இது ஆக்கப்பூர்வமான நேரம்.';

  @override
  String get feedbackDreamy => 'மென்மையான மகிழ்ச்சியை உணர்கிறீர்கள்.';

  @override
  String get adviceDaydream => 'அறிவுரை: பகல் கனவு காணுங்கள்.';

  @override
  String get feedbackBalanced => 'நீங்கள் சமநிலையில் உள்ளீர்கள்.';

  @override
  String get adviceCheckBody => 'அறிவுரை: உடலை தளர்த்துங்கள்.';

  @override
  String get labelFoggy => 'மங்கல்';

  @override
  String get labelClear => 'தெளிவு';

  @override
  String get labelNegative => 'எதிர்மறை';

  @override
  String get labelPositive => 'நேர்மறை';

  @override
  String get labelSoftEnergy => 'மென்மையான ஆற்றல்';

  @override
  String get labelHighIntensity => 'அதிக தீவிரம்';

  @override
  String get btnFeelHeard => 'என் உணர்வு புரிந்துகொள்ளப்பட்டது';

  @override
  String get zenSpaceTitle => 'ஜென் ஸ்பேஸ்';

  @override
  String get zenInstructions => 'தட்டவும் அல்லது அழுத்திப் பிடிக்கவும்';

  @override
  String get zenQuiet => 'அமைதி';

  @override
  String get zenSteady => 'சீராக';

  @override
  String get zenVibrant => 'துடிப்பான';

  @override
  String get savedConversationsTitle => 'சேமிக்கப்பட்ட உரையாடல்கள்';

  @override
  String get noSavedThreads => 'சேமிக்கப்பட்ட உரையாடல்கள் இல்லை.';

  @override
  String get defaultChatSession => 'அரட்டை அமர்வு';

  @override
  String get deleteThreadTitle => 'நீக்கவா?';

  @override
  String get deleteThreadContent => 'இது உரையாடலை நிரந்தரமாக அழிக்கும்.';

  @override
  String get cancel => 'ரத்து';

  @override
  String get delete => 'நீக்கு';

  @override
  String dateAtTime(String date, String time) {
    return '$date, நேரம் $time';
  }

  @override
  String get sessionsTitle => 'அமர்வுகள்';

  @override
  String get upcomingSession => 'வரவிருக்கும் அமர்வு';

  @override
  String get allSessions => 'அனைத்து அமர்வுகள்';

  @override
  String get clinicalPsychology => 'மருத்துவ உளவியல்';

  @override
  String get counseling => 'ஆலோசனை';

  @override
  String get reschedule => 'மாற்றியமை';

  @override
  String get joinNow => 'இணையவும்';

  @override
  String get rebook => 'மீண்டும் பதிவு செய்';

  @override
  String get tapToMove => 'பந்தை நகர்த்த தட்டவும்.';

  @override
  String get relaxAndEnjoy => 'ஓய்வெடுத்து மகிழுங்கள்.';

  @override
  String get whiteNoiseTitle => 'வெள்ளை இரைச்சல் கருவி';

  @override
  String get mixFrequency => 'விரும்பிய ஒலியை கலக்கவும்:';

  @override
  String get goBack => 'திரும்பிச் செல்';

  @override
  String get noiseWhite => 'வெள்ளை இரைச்சல்';

  @override
  String get noisePink => 'பிங்க் இரைச்சல்';

  @override
  String get noiseBrown => 'பிரவுன் இரைச்சல்';

  @override
  String get gratitudeTitle => 'நன்றி குமிழிகள்';

  @override
  String get addGratitude => 'நன்றியைச் சேர்க்கவும்';

  @override
  String get gratitudeHint => 'இன்று எதற்காக நன்றியுடன் இருக்கிறீர்கள்?';

  @override
  String get add => 'சேர்';

  @override
  String get noGratitudes =>
      'நன்றிகள் ஏதும் இல்லை. மிதப்பதைப் பார்க்க ஒன்றைச் சேர்க்கவும்!';
}
