// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'रेनबो';

  @override
  String get settings => 'सेटिंग्स';

  @override
  String get selectLanguage => 'भाषा चुनें';

  @override
  String helloUser(String userName) {
    return 'नमस्ते, $userName!';
  }

  @override
  String get thoughtOfDay => 'आज का सुविचार';

  @override
  String get selfCareCheckIn => 'आत्म-देखभाल चेक-इन';

  @override
  String get hydrate => 'हाइड्रेट';

  @override
  String get hydrateDesc =>
      'पानी लचीलेपन का ईंधन है। एक छोटा घूंट भी धुंध को साफ करने में मदद कर सकता है।';

  @override
  String get nourish => 'पोषण';

  @override
  String get nourishDesc =>
      'आपकी भावनाओं को संसाधित करने के लिए शरीर को ऊर्जा की आवश्यकता है।';

  @override
  String get rest => 'आराम';

  @override
  String get restDesc =>
      'रुकना ठीक है। रिकवरी के लिए शांत पलों की आवश्यकता होती है।';

  @override
  String get breathe => 'साँस';

  @override
  String get breatheDesc =>
      'एक गहरी साँस लें, बस अपने लिए। हवा को आपको स्थिर करने दें।';

  @override
  String get journal => 'डायरी';

  @override
  String get chatRen => 'रेन से बात करें';

  @override
  String get meditation => 'ध्यान';

  @override
  String get game => 'खेल';

  @override
  String get gratitude => 'आभार';

  @override
  String get vault => 'वॉल्ट';

  @override
  String get zenSpace => 'ज़ेन स्पेस';

  @override
  String get moodPulse => 'मूड पल्स';

  @override
  String get hotlines => 'हेल्पलाइन';

  @override
  String get cloudSyncComplete => 'क्लाउड सिंक पूरा हुआ';

  @override
  String get loadingThought => 'नया विचार लोड हो रहा है...';

  @override
  String get defaultThought =>
      'भविष्य की भविष्यवाणी करने का सबसे अच्छा तरीका इसे बनाना है।';

  @override
  String get breathingGuide => 'श्वास गाइड';

  @override
  String get breatheIn => 'साँस लें';

  @override
  String get hold => 'रोकें';

  @override
  String get breatheOut => 'साँस छोड़ें';

  @override
  String get startBreathing => 'शुरू करें';

  @override
  String get pauseBreathing => 'रुकें';

  @override
  String get journalCalendar => 'डायरी कैलेंडर';

  @override
  String get newEntry => 'नई प्रविष्टि';

  @override
  String todayIs(String date) {
    return 'आज $date है';
  }

  @override
  String get viewAllEntries => 'सभी प्रविष्टियां देखें';

  @override
  String get howAreYouFeeling => 'आप कैसा महसूस कर रहे हैं?';

  @override
  String get moodHappy => 'खुश';

  @override
  String get moodSad => 'उदास';

  @override
  String get moodAngry => 'गुस्सा';

  @override
  String get moodConfused => 'उलझन में';

  @override
  String get moodExcited => 'उत्साहित';

  @override
  String get moodCalm => 'शांत';

  @override
  String get moodNeutral => 'तटस्थ';

  @override
  String get vaultTitle => 'इमोशनल वॉल्ट';

  @override
  String get tabUnlocked => 'अनलॉक';

  @override
  String get tabLocked => 'लॉक';

  @override
  String get vaultEmpty => 'आपका वॉल्ट अभी खाली है।';

  @override
  String get readyToOpen => 'खोलने के लिए तैयार!';

  @override
  String unlocksInDays(int count) {
    return '$count दिन में खुलेगा';
  }

  @override
  String unlocksInHours(int count) {
    return '$count घंटे में खुलेगा';
  }

  @override
  String unlocksInMinutes(int count) {
    return '$count मिनट में खुलेगा';
  }

  @override
  String unlocksInSeconds(int count) {
    return '$count सेकंड में खुलेगा';
  }

  @override
  String patienceMessage(String time) {
    return 'धैर्य रखें! $time';
  }

  @override
  String get messageFromPast => 'अतीत से एक संदेश';

  @override
  String sealedOn(String date) {
    return 'सील किया गया: $date';
  }

  @override
  String get close => 'बंद करें';

  @override
  String get chatTitle => 'रेनबॉट चैट';

  @override
  String get endSession => 'सत्र समाप्त करें?';

  @override
  String get saveThreadQuestion => 'क्या आप इस बातचीत को सहेजना चाहेंगे?';

  @override
  String get discard => 'हटाएं';

  @override
  String get saveThread => 'सहेजें';

  @override
  String sessionDefaultTitle(String date) {
    return 'सत्र: $date';
  }

  @override
  String get connectionError => 'कनेक्ट करने में समस्या हो रही है। 😞';

  @override
  String get youAreNotAlone => 'आप अकेले नहीं हैं';

  @override
  String get hotlineQuestion => 'क्या आप मदद हेल्पलाइन देखना चाहेंगे?';

  @override
  String get notNow => 'अभी नहीं';

  @override
  String get viewHotlines => 'हेल्पलाइन देखें';

  @override
  String get savedThreads => 'सहेजी गई बातचीत';

  @override
  String get listening => 'सुन रहा हूँ...';

  @override
  String get messageHint => 'संदेश...';

  @override
  String get newTimeCapsule => 'नया टाइम कैप्सूल';

  @override
  String get dearFutureMe => 'प्रिय भविष्य के मैं...';

  @override
  String get unlocksAt => 'कब खुलेगा:';

  @override
  String get sealCapsule => 'कैप्सूल सील करें';

  @override
  String get capsuleEmptyError => 'कृपया अपने भविष्य के लिए एक संदेश लिखें।';

  @override
  String get capsuleTimeError => 'कृपया भविष्य का समय चुनें।';

  @override
  String get capsuleSealed => 'कैप्सूल सील और भविष्य को भेजा गया! 🚀';

  @override
  String get emotionHappy => '😊 खुश';

  @override
  String get emotionSad => '😢 उदास';

  @override
  String get emotionAngry => '😡 गुस्सा';

  @override
  String get emotionTired => '😴 थका हुआ';

  @override
  String get msgHappy => 'यह बहुत अच्छी बात है!';

  @override
  String get msgSad => 'मुझे खेद है कि आप ऐसा महसूस कर रहे हैं।';

  @override
  String get msgAngry => 'परेशान होना ठीक है।';

  @override
  String get msgTired => 'आराम महत्वपूर्ण है, इसे हल्के में लें।';

  @override
  String get journalPrompt => 'क्या आप इन भावनाओं को लिखना चाहेंगे?';

  @override
  String get yesJournal => 'हाँ, लिखें';

  @override
  String get no => 'नहीं';

  @override
  String get hotlinesTitle => 'मानसिक कल्याण हेल्पलाइन';

  @override
  String callTooltip(String phone) {
    return '$phone पर कॉल करें';
  }

  @override
  String contactPrefix(String person) {
    return 'संपर्क: $person';
  }

  @override
  String get hotlineKiran => 'किरण मानसिक स्वास्थ्य हेल्पलाइन';

  @override
  String get descKiran => 'तनाव, चिंता, अवसाद के लिए 24/7 सहायता।';

  @override
  String get personKiran => 'प्रशिक्षित परामर्शदाता';

  @override
  String get hotlineVandrevala => 'वंद्रेवाला फाउंडेशन';

  @override
  String get descVandrevala => 'भावनात्मक संकट और अवसाद के लिए सहायता।';

  @override
  String get personVandrevala => 'फाउंडेशन के परामर्शदाता';

  @override
  String get hotlineSnehi => 'स्नेही (एनजीओ)';

  @override
  String get descSnehi => 'आत्महत्या रोकथाम के लिए भावनात्मक समर्थन।';

  @override
  String get personSnehi => 'स्नेही स्वयंसेवक';

  @override
  String get untitled => 'शीर्षकहीन';

  @override
  String get editJournalEntry => 'प्रविष्टि संपादित करें';

  @override
  String get editEntryHint => 'अपनी प्रविष्टि संपादित करें...';

  @override
  String get saveChanges => 'परिवर्तन सहेजें';

  @override
  String get changeImage => 'छवि बदलें';

  @override
  String get recordAudio => 'ऑडियो रिकॉर्ड करें';

  @override
  String get stopRecording => 'रुकें';

  @override
  String get recordingStopped => 'रिकॉर्डिंग बंद हो गई';

  @override
  String get recordingStarted => 'रिकॉर्डिंग शुरू हो गई';

  @override
  String get permissionDenied => 'अनुमति अस्वीकृत';

  @override
  String get emptyEntryError =>
      'सहेजने से पहले कृपया लिखें, रिकॉर्ड करें या छवि जोड़ें।';

  @override
  String get noEntriesYet =>
      'अभी कोई प्रविष्टि नहीं है।\nआज ही अपनी यात्रा शुरू करें!';

  @override
  String get noEntriesForDay =>
      'इस दिन के लिए कोई प्रविष्टि नहीं।\nलिखने के लिए यहाँ टैप करें!';

  @override
  String get monthLabel => 'महीना';

  @override
  String get journalTitleHint => 'शीर्षक...';

  @override
  String get journalContentHint => 'आपका दिन कैसा था?';

  @override
  String get untitledEntry => 'शीर्षकहीन प्रविष्टि';

  @override
  String get entryUpdated => 'प्रविष्टि अपडेट की गई!';

  @override
  String get toolSticker => 'स्टिकर';

  @override
  String get toolPhoto => 'फोटो';

  @override
  String get toolVoice => 'आवाज़';

  @override
  String get toolType => 'टाइप';

  @override
  String get toolRead => 'पढ़ें';

  @override
  String get whiteNoise => 'व्हाइट नॉइज़';

  @override
  String get chooseTrack => 'एक ट्रैक चुनें:';

  @override
  String get reset => 'रीसेट';

  @override
  String get start => 'प्रारंभ';

  @override
  String get moodPulseTitle => 'मूड पल्स';

  @override
  String get defaultFeedback =>
      'यह दिखाने के लिए स्लाइडर्स ले जाएं कि आप कैसा महसूस कर रहे हैं।';

  @override
  String get defaultAdvice => 'हम इसे एक समय में एक कदम उठा सकते हैं।';

  @override
  String get feedbackOverwhelmed =>
      'सब कुछ तेज और धुंधला लगता है। यह उच्च तीव्रता वाली अराजकता है।';

  @override
  String get adviceGrounding =>
      'सलाह: आपका काम अभी सिर्फ साँस लेना है। 5-4-3-2-1 तकनीक का प्रयास करें।';

  @override
  String get feedbackSharp =>
      'आप एक तेज, स्पष्ट संकट या निराशा महसूस कर रहे हैं।';

  @override
  String get adviceExitEnergy =>
      'सलाह: इस ऊर्जा को बाहर निकलने की जरूरत है। अपना चेहरा ठंडे पानी से धोएं।';

  @override
  String get feedbackHeavy =>
      'आप एक भारी, धुंधला बोझ उठा रहे हैं। \'क्यों\' की पहचान करना भी कठिन है।';

  @override
  String get adviceComfort =>
      'सलाह: कोहरे से मत लड़ो। छोटे सुखों पर ध्यान दें - एक गर्म पेय या नरम कंबल।';

  @override
  String get feedbackSadness => 'एक शांत, स्पष्ट उदासी मौजूद है।';

  @override
  String get adviceValidate =>
      'सलाह: इसके साथ बैठना ठीक है। इस वजन का वर्णन करने वाले तीन शब्द लिखें।';

  @override
  String get feedbackHaze =>
      'आप मानसिक धुंध में हैं। चीजें थोड़ी अलग-थलग महसूस होती हैं।';

  @override
  String get adviceDigitalFast =>
      'सलाह: आपका दिमाग उत्तेजित हो सकता है। 10 मिनट का \'डिजिटल उपवास\' करें।';

  @override
  String get feedbackFlow => 'आप प्रवाह और स्पष्टता की सुंदर स्थिति में हैं।';

  @override
  String get adviceCreativity =>
      'सलाह: यह रचनात्मकता का बहुत अच्छा समय है। इस प्रकाश को अपने अगले कार्य में ले जाएं।';

  @override
  String get feedbackDreamy =>
      'आप एक कोमल, स्वप्निल प्रकार की खुशी महसूस कर रहे हैं।';

  @override
  String get adviceDaydream =>
      'सलाह: खुद को दिवास्वप्न देखने दें। आपको अभी उत्पादक होने की आवश्यकता नहीं है।';

  @override
  String get feedbackBalanced =>
      'आप एक स्थिर, मध्य स्थान में अपना संतुलन पा रहे हैं।';

  @override
  String get adviceCheckBody =>
      'सलाह: अपने शरीर की जाँच करते रहें। यदि आपके कंधे तनाव में हैं तो उन्हें ढीला छोड़ दें।';

  @override
  String get labelFoggy => 'धुंधला';

  @override
  String get labelClear => 'स्पष्ट';

  @override
  String get labelNegative => 'नकारात्मक';

  @override
  String get labelPositive => 'सकारात्मक';

  @override
  String get labelSoftEnergy => 'कोमल ऊर्जा';

  @override
  String get labelHighIntensity => 'उच्च तीव्रता';

  @override
  String get btnFeelHeard => 'मुझे सुना गया महसूस हो रहा है';

  @override
  String get zenSpaceTitle => 'ज़ेन स्पेस';

  @override
  String get zenInstructions => 'लहर के लिए टैप करें, चमक के लिए दबाए रखें';

  @override
  String get zenQuiet => 'शांत';

  @override
  String get zenSteady => 'स्थिर';

  @override
  String get zenVibrant => 'जीवंत';

  @override
  String get savedConversationsTitle => 'सहेजी गई बातचीत';

  @override
  String get noSavedThreads => 'अभी तक कोई बातचीत सहेजी नहीं गई।';

  @override
  String get defaultChatSession => 'चैट सत्र';

  @override
  String get deleteThreadTitle => 'बातचीत हटाएं?';

  @override
  String get deleteThreadContent => 'यह इस बातचीत को स्थायी रूप से हटा देगा।';

  @override
  String get cancel => 'रद्द करें';

  @override
  String get delete => 'हटाएं';

  @override
  String dateAtTime(String date, String time) {
    return '$date को $time बजे';
  }

  @override
  String get sessionsTitle => 'सत्र';

  @override
  String get upcomingSession => 'आगामी सत्र';

  @override
  String get allSessions => 'सभी सत्र';

  @override
  String get clinicalPsychology => 'नैदानिक मनोविज्ञान';

  @override
  String get counseling => 'परामर्श';

  @override
  String get reschedule => 'पुनर्निर्धारित';

  @override
  String get joinNow => 'अभी जुड़ें';

  @override
  String get rebook => 'पुनः बुक करें';

  @override
  String get tapToMove => 'गेंद को हिलाने के लिए टैप करें।';

  @override
  String get relaxAndEnjoy => 'बस आराम करें और आनंद लें।';

  @override
  String get whiteNoiseTitle => 'व्हाइट नॉइज़ सिंथेसाइज़र';

  @override
  String get mixFrequency => 'अपनी वांछित आवृत्ति मिलाएं:';

  @override
  String get goBack => 'वापस जाएं';

  @override
  String get noiseWhite => 'सफेद शोर';

  @override
  String get noisePink => 'गुलाबी शोर';

  @override
  String get noiseBrown => 'भूरा शोर';

  @override
  String get gratitudeTitle => 'आभार के बुलबुले';

  @override
  String get addGratitude => 'आभार जोड़ें';

  @override
  String get gratitudeHint => 'आज आप किस बात के लिए आभारी हैं?';

  @override
  String get add => 'जोड़ें';

  @override
  String get noGratitudes =>
      'अभी तक कोई आभार नहीं। इसे तैरते हुए देखने के लिए एक जोड़ें!';
}
