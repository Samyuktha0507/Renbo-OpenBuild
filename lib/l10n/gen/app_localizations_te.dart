// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get appTitle => 'రెన్బో';

  @override
  String get settings => 'సెట్టింగ్‌లు';

  @override
  String get selectLanguage => 'భాషను ఎంచుకోండి';

  @override
  String helloUser(String userName) {
    return 'నమస్తే, $userName!';
  }

  @override
  String get thoughtOfDay => 'ఈroju ఆలోచన';

  @override
  String get selfCareCheckIn => 'స్వయం సంరక్షణ';

  @override
  String get hydrate => 'నీరు త్రాగండి';

  @override
  String get hydrateDesc =>
      'నీరు శరీరానికి ఇంధనం. చిన్న సిప్ కూడా మీకు శక్తినిస్తుంది.';

  @override
  String get nourish => 'పోషణ';

  @override
  String get nourishDesc =>
      'మీ భావోద్వేగాలను ఎదుర్కోవడానికి శరీరానికి శక్తి అవసరం.';

  @override
  String get rest => 'విశ్రాంతి';

  @override
  String get restDesc =>
      'ఆగడం తప్పు కాదు. కోలుకోవడానికి ప్రశాంతమైన క్షణాలు అవసరం.';

  @override
  String get breathe => 'శ్వాస';

  @override
  String get breatheDesc =>
      'ఒక లోతైన శ్వాస తీసుకోండి. అది మిమ్మల్ని స్థిరపరుస్తుంది.';

  @override
  String get journal => 'జర్నల్';

  @override
  String get chatRen => 'రెన్‌తో మాట్లాడండి';

  @override
  String get meditation => 'ధ్యానం';

  @override
  String get game => 'గేమ్';

  @override
  String get gratitude => 'కృతజ్ఞత';

  @override
  String get vault => 'వాల్ట్';

  @override
  String get zenSpace => 'జెన్ స్పేస్';

  @override
  String get moodPulse => 'మూడ్ పల్స్';

  @override
  String get hotlines => 'హెల్ప్‌లైన్‌లు';

  @override
  String get cloudSyncComplete => 'క్లౌడ్ సింక్ పూర్తయింది';

  @override
  String get loadingThought => 'కొత్త ఆలోచన లోడ్ అవుతోంది...';

  @override
  String get defaultThought =>
      'భవిష్యత్తును అంచనా వేయడానికి ఉత్తమ మార్గం దానిని సృష్టించడమే.';

  @override
  String get breathingGuide => 'శ్వాస మార్గదర్శి';

  @override
  String get breatheIn => 'గాలి పీల్చండి';

  @override
  String get hold => 'ఆపండి';

  @override
  String get breatheOut => 'గాలి వదలండి';

  @override
  String get startBreathing => 'ప్రారంభించు';

  @override
  String get pauseBreathing => 'నిలిపివేయి';

  @override
  String get journalCalendar => 'జర్నల్ క్యాలెండర్';

  @override
  String get newEntry => 'కొత్త ఎంట్రీ';

  @override
  String todayIs(String date) {
    return 'ఈ రోజు $date';
  }

  @override
  String get viewAllEntries => 'అన్ని ఎంట్రీలను చూడండి';

  @override
  String get howAreYouFeeling => 'మీరు ఎలా ఉన్నారు?';

  @override
  String get moodHappy => 'సంతోషం';

  @override
  String get moodSad => 'విచారం';

  @override
  String get moodAngry => 'కోపం';

  @override
  String get moodConfused => 'గందరగోళం';

  @override
  String get moodExcited => 'ఉత్సాహం';

  @override
  String get moodCalm => 'ప్రశాంతం';

  @override
  String get moodNeutral => 'తటస్థం';

  @override
  String get vaultTitle => 'ఎమోషనల్ వాల్ట్';

  @override
  String get tabUnlocked => 'అన్‌లాక్ చేయబడింది';

  @override
  String get tabLocked => 'లాక్ చేయబడింది';

  @override
  String get vaultEmpty => 'మీ వాల్ట్ ప్రస్తుతం ఖాళీగా ఉంది.';

  @override
  String get readyToOpen => 'తెరవడానికి సిద్ధంగా ఉంది!';

  @override
  String unlocksInDays(int count) {
    return '$count రోజుల్లో అన్‌లాక్ అవుతుంది';
  }

  @override
  String unlocksInHours(int count) {
    return '$count గంటల్లో అన్‌లాక్ అవుతుంది';
  }

  @override
  String unlocksInMinutes(int count) {
    return '$count నిమిషాల్లో అన్‌లాక్ అవుతుంది';
  }

  @override
  String unlocksInSeconds(int count) {
    return '$count సెకన్లలో అన్‌లాక్ అవుతుంది';
  }

  @override
  String patienceMessage(String time) {
    return 'ఓపిక! $time';
  }

  @override
  String get messageFromPast => 'గతం నుండి ఒక సందేశం';

  @override
  String sealedOn(String date) {
    return 'సీల్ చేయబడింది: $date';
  }

  @override
  String get close => 'మూసివేయి';

  @override
  String get chatTitle => 'రెన్‌బాట్ చాట్';

  @override
  String get endSession => 'సెషన్ ముగించాలా?';

  @override
  String get saveThreadQuestion => 'మీరు ఈ సంభాషణను సేవ్ చేయాలనుకుంటున్నారా?';

  @override
  String get discard => 'వదిలేయండి';

  @override
  String get saveThread => 'సేవ్ చేయండి';

  @override
  String sessionDefaultTitle(String date) {
    return 'సెషన్: $date';
  }

  @override
  String get connectionError => 'కనెక్ట్ చేయడంలో సమస్య ఉంది. 😞';

  @override
  String get youAreNotAlone => 'మీరు ఒంటరి కాదు';

  @override
  String get hotlineQuestion => 'మీరు సహాయ హెల్ప్‌లైన్‌లను చూడాలనుకుంటున్నారా?';

  @override
  String get notNow => 'ఇప్పుడు వద్దు';

  @override
  String get viewHotlines => 'హెల్ప్‌లైన్‌లు చూడండి';

  @override
  String get savedThreads => 'సేవ్ చేసిన సంభాషణలు';

  @override
  String get listening => 'వింటున్నాను...';

  @override
  String get messageHint => 'సందేశం...';

  @override
  String get newTimeCapsule => 'కొత్త టైమ్ క్యాప్సూల్';

  @override
  String get dearFutureMe => 'ప్రియమైన భవిష్యత్తు నేను...';

  @override
  String get unlocksAt => 'ఎప్పుడు తెరుచుకుంటుంది:';

  @override
  String get sealCapsule => 'క్యాప్సూల్‌ను సీల్ చేయండి';

  @override
  String get capsuleEmptyError => 'దయచేసి మీ భవిష్యత్తు కోసం ఒక సందేశం రాయండి.';

  @override
  String get capsuleTimeError => 'దయచేసి భవిష్యత్తు సమయాన్ని ఎంచుకోండి.';

  @override
  String get capsuleSealed => 'క్యాప్సూల్ సీల్ చేసి భవిష్యత్తుకు పంపబడింది! 🚀';

  @override
  String get emotionHappy => '😊 సంతోషం';

  @override
  String get emotionSad => '😢 విచారం';

  @override
  String get emotionAngry => '😡 కోపం';

  @override
  String get emotionTired => '😴 అలసట';

  @override
  String get msgHappy => 'చాలా బాగుంది!';

  @override
  String get msgSad => 'మీరు అలా ఉన్నందుకు బాధగా ఉంది.';

  @override
  String get msgAngry => 'కోపంగా ఉండటం సహజమే.';

  @override
  String get msgTired => 'విశ్రాంతి ముఖ్యం, ప్రశాంతంగా ఉండండి.';

  @override
  String get journalPrompt => 'దీని గురించి రాయాలనుకుంటున్నారా?';

  @override
  String get yesJournal => 'అవును, రాయాలి';

  @override
  String get no => 'వద్దు';

  @override
  String get hotlinesTitle => 'మానసిక ఆరోగ్య హెల్ప్‌లైన్‌లు';

  @override
  String callTooltip(String phone) {
    return '$phone కు కాల్ చేయండి';
  }

  @override
  String contactPrefix(String person) {
    return 'సంప్రదించండి: $person';
  }

  @override
  String get hotlineKiran => 'కిరణ్ మెంటల్ హెల్త్ హెల్ప్‌లైన్';

  @override
  String get descKiran => 'ఒత్తిడి, ఆందోళన, నిరాశ కోసం 24/7 మద్దతు.';

  @override
  String get personKiran => 'శిక్షణ పొందిన కౌన్సిలర్లు';

  @override
  String get hotlineVandrevala => 'వాండ్రేवाला ఫౌండేషన్';

  @override
  String get descVandrevala => 'భావోద్వేగ ఒత్తిడి మరియు నిరాశకు మద్దతు.';

  @override
  String get personVandrevala => 'ఫౌండేషన్ కౌన్సిలర్లు';

  @override
  String get hotlineSnehi => 'స్నేహి (NGO)';

  @override
  String get descSnehi => 'ఆత్మహత్య నివారణకు భావోద్వేగ మద్దతు.';

  @override
  String get personSnehi => 'స్నేహి వాలంటీర్లు';

  @override
  String get untitled => 'శీర్షిక లేదు';

  @override
  String get editJournalEntry => 'ఎంట్రీని సవరించండి';

  @override
  String get editEntryHint => 'మీ ఎంట్రీని సవరించండి...';

  @override
  String get saveChanges => 'మార్పులను సేవ్ చేయండి';

  @override
  String get changeImage => 'చిత్రం మార్చండి';

  @override
  String get recordAudio => 'ఆడియో రికార్డ్ చేయండి';

  @override
  String get stopRecording => 'ఆపండి';

  @override
  String get recordingStopped => 'రికార్డింగ్ ఆగిపోయింది';

  @override
  String get recordingStarted => 'రికార్డింగ్ ప్రారంభమైంది';

  @override
  String get permissionDenied => 'అనుమతి నిరాకరించబడింది';

  @override
  String get emptyEntryError =>
      'సేవ్ చేయడానికి ముందు దయచేసి రాయండి, రికార్డ్ చేయండి లేదా చిత్రాన్ని జోడించండి.';

  @override
  String get noEntriesYet =>
      'ఇంకా ఎంట్రీలు లేవు.\nఈ రోజే మీ ప్రయాణం ప్రారంభించండి!';

  @override
  String get noEntriesForDay =>
      'ఈ రోజు ఎంట్రీలు లేవు.\nరాయడానికి ఇక్కడ నొక్కండి!';

  @override
  String get monthLabel => 'నెల';

  @override
  String get journalTitleHint => 'శీర్షిక...';

  @override
  String get journalContentHint => 'మీ రోజు ఎలా గడిచింది?';

  @override
  String get untitledEntry => 'శీర్షిక లేని ఎంట్రీ';

  @override
  String get entryUpdated => 'ఎంట్రీ అప్‌డేట్ చేయబడింది!';

  @override
  String get toolSticker => 'స్టిక్కర్';

  @override
  String get toolPhoto => 'ఫోటో';

  @override
  String get toolVoice => 'వాయిస్';

  @override
  String get toolType => 'టైప్';

  @override
  String get toolRead => 'చదువు';

  @override
  String get whiteNoise => 'వైట్ నాయిస్';

  @override
  String get chooseTrack => 'ఒక ట్రాక్‌ని ఎంచుకోండి:';

  @override
  String get reset => 'రీసెట్';

  @override
  String get start => 'ప్రారంభించు';

  @override
  String get moodPulseTitle => 'మూడ్ పల్స్';

  @override
  String get defaultFeedback =>
      'మీరు ఎలా ఉన్నారో చూపించడానికి స్లైడర్‌లను జరపండి.';

  @override
  String get defaultAdvice => 'మనం ఒక్కో అడుగు ముందుకు వేయవచ్చు.';

  @override
  String get feedbackOverwhelmed =>
      'అంతా గందరగోళంగా ఉంది. ఇది అధిక తీవ్రతతో కూడిన అలజడి.';

  @override
  String get adviceGrounding =>
      'సలహా: ఇప్పుడు మీ పని కేవలం ఊపిరి పీల్చుకోవడం. 5-4-3-2-1 టెక్నిక్‌ని ప్రయత్నించండి.';

  @override
  String get feedbackSharp =>
      'మీరు తీవ్రమైన బాధ లేదా నిరాశను అనుభవిస్తున్నారు.';

  @override
  String get adviceExitEnergy =>
      'సలహా: ఈ శక్తి బయటకు పోవాలి. చల్లటి నీటితో ముఖం కడుక్కోండి.';

  @override
  String get feedbackHeavy =>
      'మీరు భారీ బరువును మోస్తున్నారు. కారణం తెలియడం లేదు.';

  @override
  String get adviceComfort =>
      'సలహా: ఈ అలజడితో పోరాడవద్దు. చిన్న చిన్న సౌకర్యాలపై దృష్టి పెట్టండి - వేడి పానీయం లేదా మృదువైన దుప్పటి.';

  @override
  String get feedbackSadness => 'ప్రశాంతమైన, స్పష్టమైన విచారం ఉంది.';

  @override
  String get adviceValidate =>
      'సలహా: దీనితో ఉండటం తప్పు కాదు. ఈ బరువును వర్ణించే మూడు పదాలను రాయండి.';

  @override
  String get feedbackHaze =>
      'మీరు మానసిక గందరగోళంలో ఉన్నారు. విషయాలు దూరంగా అనిపిస్తున్నాయి.';

  @override
  String get adviceDigitalFast =>
      'సలహా: మీ మెదడు అలసిపోయి ఉండవచ్చు. 10 నిమిషాల పాటు ఫోన్‌ను పక్కన పెట్టండి.';

  @override
  String get feedbackFlow => 'మీరు అందమైన ప్రవాహం మరియు స్పష్టతలో ఉన్నారు.';

  @override
  String get adviceCreativity =>
      'సలహా: సృజనాత్మకతకు ఇది గొప్ప సమయం. ఈ కాంతిని మీ తదుపరి పనికి తీసుకెళ్లండి.';

  @override
  String get feedbackDreamy =>
      'మీరు మృదువైన, కలల వంటి ఆనందాన్ని అనుభవిస్తున్నారు.';

  @override
  String get adviceDaydream =>
      'సలహా: పగటి కలలు కనండి. ఇప్పుడు మీరు పని చేయాల్సిన అవసరం లేదు.';

  @override
  String get feedbackBalanced =>
      'మీరు స్థిరమైన, మధ్యస్థ స్థితిలో సమతుల్యతను పొందుతున్నారు.';

  @override
  String get adviceCheckBody =>
      'సలహా: మీ శరీరాన్ని గమనించండి. మీ భుజాలు బిగుతుగా ఉంటే వాటిని వదులు చేయండి.';

  @override
  String get labelFoggy => 'మబ్బుగా';

  @override
  String get labelClear => 'స్పష్టంగా';

  @override
  String get labelNegative => 'ప్రతికూల';

  @override
  String get labelPositive => 'సానుకూల';

  @override
  String get labelSoftEnergy => 'మృదువైన శక్తి';

  @override
  String get labelHighIntensity => 'అధిక తీవ్రత';

  @override
  String get btnFeelHeard => 'నా మాట విన్నట్టు అనిపిస్తోంది';

  @override
  String get zenSpaceTitle => 'జెన్ స్పేస్';

  @override
  String get zenInstructions => 'తాకండి, పట్టుకోండి';

  @override
  String get zenQuiet => 'నిశ్శబ్దం';

  @override
  String get zenSteady => 'స్థిరం';

  @override
  String get zenVibrant => 'చైతన్యం';

  @override
  String get savedConversationsTitle => 'సేవ్ చేసిన సంభాషణలు';

  @override
  String get noSavedThreads => 'ఇంకా సేవ్ చేసిన సంభాషణలు లేవు.';

  @override
  String get defaultChatSession => 'చాట్ సెషన్';

  @override
  String get deleteThreadTitle => 'సంభాషణను తొలగించాలా?';

  @override
  String get deleteThreadContent => 'ఇది ఈ సంభాషణను శాశ్వతంగా తొలగిస్తుంది.';

  @override
  String get cancel => 'రద్దు చేయి';

  @override
  String get delete => 'తొలగించు';

  @override
  String dateAtTime(String date, String time) {
    return '$date, సమయం $time';
  }

  @override
  String get sessionsTitle => 'సెషన్లు';

  @override
  String get upcomingSession => 'రాబోయే సెషన్';

  @override
  String get allSessions => 'అన్ని సెషన్లు';

  @override
  String get clinicalPsychology => 'క్లినికల్ సైకాలజీ';

  @override
  String get counseling => 'కౌన్సిలింగ్';

  @override
  String get reschedule => 'రీషెడ్యూల్';

  @override
  String get joinNow => 'ఇప్పుడే చేరండి';

  @override
  String get rebook => 'మళ్లీ బుక్ చేయండి';

  @override
  String get tapToMove => 'బంతిని కదిలించడానికి నొక్కండి.';

  @override
  String get relaxAndEnjoy => 'విశ్రాంతి తీసుకోండి మరియు ఆనందించండి.';

  @override
  String get whiteNoiseTitle => 'వైట్ నాయిస్ సింథసైజర్';

  @override
  String get mixFrequency => 'మీకు కావలసిన ఫ్రీక్వెన్సీని కలపండి:';

  @override
  String get goBack => 'వెనుకకు వెళ్లు';

  @override
  String get noiseWhite => 'వైట్ నాయిస్';

  @override
  String get noisePink => 'పింక్ నాయిస్';

  @override
  String get noiseBrown => 'బ్రౌన్ నాయిస్';

  @override
  String get gratitudeTitle => 'కృతజ్ఞత బుడగలు';

  @override
  String get addGratitude => 'కృతజ్ఞతను జోడించండి';

  @override
  String get gratitudeHint => 'ఈ రోజు మీరు దేనికి కృతజ్ఞతతో ఉన్నారు?';

  @override
  String get add => 'జోడించు';

  @override
  String get noGratitudes =>
      'కృతజ్ఞతలు ఏమీ లేవు. తేలియాడటం చూడటానికి ఒకదాన్ని జోడించండి!';
}
