import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('hi'),
    Locale('ta'),
    Locale('te')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Renbo'**
  String get appTitle;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @helloUser.
  ///
  /// In en, this message translates to:
  /// **'Hello, {userName}!'**
  String helloUser(String userName);

  /// No description provided for @thoughtOfDay.
  ///
  /// In en, this message translates to:
  /// **'Thought of the day'**
  String get thoughtOfDay;

  /// No description provided for @selfCareCheckIn.
  ///
  /// In en, this message translates to:
  /// **'Self-Care Check-in'**
  String get selfCareCheckIn;

  /// No description provided for @hydrate.
  ///
  /// In en, this message translates to:
  /// **'Hydrate'**
  String get hydrate;

  /// No description provided for @hydrateDesc.
  ///
  /// In en, this message translates to:
  /// **'Water is fuel for resilience. Even a small sip can help clear the fog.'**
  String get hydrateDesc;

  /// No description provided for @nourish.
  ///
  /// In en, this message translates to:
  /// **'Nourish'**
  String get nourish;

  /// No description provided for @nourishDesc.
  ///
  /// In en, this message translates to:
  /// **'Your body needs energy to process big feelings. A gentle snack is self-love.'**
  String get nourishDesc;

  /// No description provided for @rest.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get rest;

  /// No description provided for @restDesc.
  ///
  /// In en, this message translates to:
  /// **'It is okay to hit the pause button. Recovery requires quiet moments.'**
  String get restDesc;

  /// No description provided for @breathe.
  ///
  /// In en, this message translates to:
  /// **'Breathe'**
  String get breathe;

  /// No description provided for @breatheDesc.
  ///
  /// In en, this message translates to:
  /// **'Take one deep breath, just for you. Let the air ground you.'**
  String get breatheDesc;

  /// No description provided for @journal.
  ///
  /// In en, this message translates to:
  /// **'Journal'**
  String get journal;

  /// No description provided for @chatRen.
  ///
  /// In en, this message translates to:
  /// **'Chat with Ren'**
  String get chatRen;

  /// No description provided for @meditation.
  ///
  /// In en, this message translates to:
  /// **'Meditation'**
  String get meditation;

  /// No description provided for @game.
  ///
  /// In en, this message translates to:
  /// **'Game'**
  String get game;

  /// No description provided for @gratitude.
  ///
  /// In en, this message translates to:
  /// **'Gratitude'**
  String get gratitude;

  /// No description provided for @vault.
  ///
  /// In en, this message translates to:
  /// **'Vault'**
  String get vault;

  /// No description provided for @zenSpace.
  ///
  /// In en, this message translates to:
  /// **'Zen Space'**
  String get zenSpace;

  /// No description provided for @moodPulse.
  ///
  /// In en, this message translates to:
  /// **'Mood Pulse'**
  String get moodPulse;

  /// No description provided for @hotlines.
  ///
  /// In en, this message translates to:
  /// **'Hotlines'**
  String get hotlines;

  /// No description provided for @cloudSyncComplete.
  ///
  /// In en, this message translates to:
  /// **'Cloud Sync Complete'**
  String get cloudSyncComplete;

  /// No description provided for @loadingThought.
  ///
  /// In en, this message translates to:
  /// **'Loading a new thought...'**
  String get loadingThought;

  /// No description provided for @defaultThought.
  ///
  /// In en, this message translates to:
  /// **'The best way to predict the future is to create it.'**
  String get defaultThought;

  /// No description provided for @breathingGuide.
  ///
  /// In en, this message translates to:
  /// **'Breathing Guide'**
  String get breathingGuide;

  /// No description provided for @breatheIn.
  ///
  /// In en, this message translates to:
  /// **'Breathe in'**
  String get breatheIn;

  /// No description provided for @hold.
  ///
  /// In en, this message translates to:
  /// **'Hold'**
  String get hold;

  /// No description provided for @breatheOut.
  ///
  /// In en, this message translates to:
  /// **'Breathe out'**
  String get breatheOut;

  /// No description provided for @startBreathing.
  ///
  /// In en, this message translates to:
  /// **'Start Breathing'**
  String get startBreathing;

  /// No description provided for @pauseBreathing.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pauseBreathing;

  /// No description provided for @journalCalendar.
  ///
  /// In en, this message translates to:
  /// **'Journal Calendar'**
  String get journalCalendar;

  /// No description provided for @newEntry.
  ///
  /// In en, this message translates to:
  /// **'New Entry'**
  String get newEntry;

  /// No description provided for @todayIs.
  ///
  /// In en, this message translates to:
  /// **'Today is {date}'**
  String todayIs(String date);

  /// No description provided for @viewAllEntries.
  ///
  /// In en, this message translates to:
  /// **'View All Journal Entries'**
  String get viewAllEntries;

  /// No description provided for @howAreYouFeeling.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get howAreYouFeeling;

  /// No description provided for @moodHappy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get moodHappy;

  /// No description provided for @moodSad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get moodSad;

  /// No description provided for @moodAngry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get moodAngry;

  /// No description provided for @moodConfused.
  ///
  /// In en, this message translates to:
  /// **'Confused'**
  String get moodConfused;

  /// No description provided for @moodExcited.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get moodExcited;

  /// No description provided for @moodCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get moodCalm;

  /// No description provided for @moodNeutral.
  ///
  /// In en, this message translates to:
  /// **'Neutral'**
  String get moodNeutral;

  /// No description provided for @vaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Emotional Vault'**
  String get vaultTitle;

  /// No description provided for @tabUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Unlocked'**
  String get tabUnlocked;

  /// No description provided for @tabLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get tabLocked;

  /// No description provided for @vaultEmpty.
  ///
  /// In en, this message translates to:
  /// **'Your vault is currently empty.'**
  String get vaultEmpty;

  /// No description provided for @readyToOpen.
  ///
  /// In en, this message translates to:
  /// **'Ready to open!'**
  String get readyToOpen;

  /// No description provided for @unlocksInDays.
  ///
  /// In en, this message translates to:
  /// **'Unlocks in {count}d'**
  String unlocksInDays(int count);

  /// No description provided for @unlocksInHours.
  ///
  /// In en, this message translates to:
  /// **'Unlocks in {count}h'**
  String unlocksInHours(int count);

  /// No description provided for @unlocksInMinutes.
  ///
  /// In en, this message translates to:
  /// **'Unlocks in {count}m'**
  String unlocksInMinutes(int count);

  /// No description provided for @unlocksInSeconds.
  ///
  /// In en, this message translates to:
  /// **'Unlocks in {count}s'**
  String unlocksInSeconds(int count);

  /// No description provided for @patienceMessage.
  ///
  /// In en, this message translates to:
  /// **'Patience! {time}'**
  String patienceMessage(String time);

  /// No description provided for @messageFromPast.
  ///
  /// In en, this message translates to:
  /// **'A Message from the Past'**
  String get messageFromPast;

  /// No description provided for @sealedOn.
  ///
  /// In en, this message translates to:
  /// **'Sealed on {date}'**
  String sealedOn(String date);

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @chatTitle.
  ///
  /// In en, this message translates to:
  /// **'Renbot Chat'**
  String get chatTitle;

  /// No description provided for @endSession.
  ///
  /// In en, this message translates to:
  /// **'End Session?'**
  String get endSession;

  /// No description provided for @saveThreadQuestion.
  ///
  /// In en, this message translates to:
  /// **'Would you like to save this thread?'**
  String get saveThreadQuestion;

  /// No description provided for @discard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get discard;

  /// No description provided for @saveThread.
  ///
  /// In en, this message translates to:
  /// **'Save Thread'**
  String get saveThread;

  /// No description provided for @sessionDefaultTitle.
  ///
  /// In en, this message translates to:
  /// **'Session: {date}'**
  String sessionDefaultTitle(String date);

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'I am having trouble connecting. 😞'**
  String get connectionError;

  /// No description provided for @youAreNotAlone.
  ///
  /// In en, this message translates to:
  /// **'You’re Not Alone'**
  String get youAreNotAlone;

  /// No description provided for @hotlineQuestion.
  ///
  /// In en, this message translates to:
  /// **'Would you like to see help hotlines?'**
  String get hotlineQuestion;

  /// No description provided for @notNow.
  ///
  /// In en, this message translates to:
  /// **'Not Now'**
  String get notNow;

  /// No description provided for @viewHotlines.
  ///
  /// In en, this message translates to:
  /// **'View Hotlines'**
  String get viewHotlines;

  /// No description provided for @savedThreads.
  ///
  /// In en, this message translates to:
  /// **'Saved Threads'**
  String get savedThreads;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening...'**
  String get listening;

  /// No description provided for @messageHint.
  ///
  /// In en, this message translates to:
  /// **'Message...'**
  String get messageHint;

  /// No description provided for @newTimeCapsule.
  ///
  /// In en, this message translates to:
  /// **'New Time Capsule'**
  String get newTimeCapsule;

  /// No description provided for @dearFutureMe.
  ///
  /// In en, this message translates to:
  /// **'Dear future me...'**
  String get dearFutureMe;

  /// No description provided for @unlocksAt.
  ///
  /// In en, this message translates to:
  /// **'Unlocks at:'**
  String get unlocksAt;

  /// No description provided for @sealCapsule.
  ///
  /// In en, this message translates to:
  /// **'Seal Capsule'**
  String get sealCapsule;

  /// No description provided for @capsuleEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Please write a message to your future self.'**
  String get capsuleEmptyError;

  /// No description provided for @capsuleTimeError.
  ///
  /// In en, this message translates to:
  /// **'Please select a time in the future.'**
  String get capsuleTimeError;

  /// No description provided for @capsuleSealed.
  ///
  /// In en, this message translates to:
  /// **'Capsule sealed and sent to the future! 🚀'**
  String get capsuleSealed;

  /// No description provided for @emotionHappy.
  ///
  /// In en, this message translates to:
  /// **'😊 Happy'**
  String get emotionHappy;

  /// No description provided for @emotionSad.
  ///
  /// In en, this message translates to:
  /// **'😢 Sad'**
  String get emotionSad;

  /// No description provided for @emotionAngry.
  ///
  /// In en, this message translates to:
  /// **'😡 Angry'**
  String get emotionAngry;

  /// No description provided for @emotionTired.
  ///
  /// In en, this message translates to:
  /// **'😴 Tired'**
  String get emotionTired;

  /// No description provided for @msgHappy.
  ///
  /// In en, this message translates to:
  /// **'That\'s wonderful!'**
  String get msgHappy;

  /// No description provided for @msgSad.
  ///
  /// In en, this message translates to:
  /// **'I’m sorry you’re feeling this way.'**
  String get msgSad;

  /// No description provided for @msgAngry.
  ///
  /// In en, this message translates to:
  /// **'It’s okay to feel upset.'**
  String get msgAngry;

  /// No description provided for @msgTired.
  ///
  /// In en, this message translates to:
  /// **'Rest is important, take it easy.'**
  String get msgTired;

  /// No description provided for @journalPrompt.
  ///
  /// In en, this message translates to:
  /// **'Would you like to journal these emotions?'**
  String get journalPrompt;

  /// No description provided for @yesJournal.
  ///
  /// In en, this message translates to:
  /// **'Yes, Journal'**
  String get yesJournal;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @hotlinesTitle.
  ///
  /// In en, this message translates to:
  /// **'Mental Wellness Hotlines'**
  String get hotlinesTitle;

  /// No description provided for @callTooltip.
  ///
  /// In en, this message translates to:
  /// **'Call {phone}'**
  String callTooltip(String phone);

  /// No description provided for @contactPrefix.
  ///
  /// In en, this message translates to:
  /// **'Contact: {person}'**
  String contactPrefix(String person);

  /// No description provided for @hotlineKiran.
  ///
  /// In en, this message translates to:
  /// **'KIRAN Mental Health Helpline'**
  String get hotlineKiran;

  /// No description provided for @descKiran.
  ///
  /// In en, this message translates to:
  /// **'24/7 support for stress, anxiety, depression, suicidal thoughts.'**
  String get descKiran;

  /// No description provided for @personKiran.
  ///
  /// In en, this message translates to:
  /// **'Trained Mental Health Counselors'**
  String get personKiran;

  /// No description provided for @hotlineVandrevala.
  ///
  /// In en, this message translates to:
  /// **'Vandrevala Foundation Helpline'**
  String get hotlineVandrevala;

  /// No description provided for @descVandrevala.
  ///
  /// In en, this message translates to:
  /// **'Support for emotional distress, depression, suicidal thoughts.'**
  String get descVandrevala;

  /// No description provided for @personVandrevala.
  ///
  /// In en, this message translates to:
  /// **'Counselors at Vandrevala Foundation'**
  String get personVandrevala;

  /// No description provided for @hotlineSnehi.
  ///
  /// In en, this message translates to:
  /// **'Snehi (Delhi-based NGO)'**
  String get hotlineSnehi;

  /// No description provided for @descSnehi.
  ///
  /// In en, this message translates to:
  /// **'Emotional support for suicide prevention & crisis intervention.'**
  String get descSnehi;

  /// No description provided for @personSnehi.
  ///
  /// In en, this message translates to:
  /// **'Snehi Volunteer Counselors'**
  String get personSnehi;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @editJournalEntry.
  ///
  /// In en, this message translates to:
  /// **'Edit Journal Entry'**
  String get editJournalEntry;

  /// No description provided for @editEntryHint.
  ///
  /// In en, this message translates to:
  /// **'Edit your entry...'**
  String get editEntryHint;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @changeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get changeImage;

  /// No description provided for @recordAudio.
  ///
  /// In en, this message translates to:
  /// **'Record Audio'**
  String get recordAudio;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stopRecording;

  /// No description provided for @recordingStopped.
  ///
  /// In en, this message translates to:
  /// **'Recording stopped'**
  String get recordingStopped;

  /// No description provided for @recordingStarted.
  ///
  /// In en, this message translates to:
  /// **'Recording started'**
  String get recordingStarted;

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'Permission denied'**
  String get permissionDenied;

  /// No description provided for @emptyEntryError.
  ///
  /// In en, this message translates to:
  /// **'Please write, record, or add an image before saving.'**
  String get emptyEntryError;

  /// No description provided for @noEntriesYet.
  ///
  /// In en, this message translates to:
  /// **'No entries yet.\nStart your journey today!'**
  String get noEntriesYet;

  /// No description provided for @noEntriesForDay.
  ///
  /// In en, this message translates to:
  /// **'No entries for this day.\nTap here to write!'**
  String get noEntriesForDay;

  /// No description provided for @monthLabel.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get monthLabel;

  /// No description provided for @journalTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Title...'**
  String get journalTitleHint;

  /// No description provided for @journalContentHint.
  ///
  /// In en, this message translates to:
  /// **'How was your day?'**
  String get journalContentHint;

  /// No description provided for @untitledEntry.
  ///
  /// In en, this message translates to:
  /// **'Untitled Entry'**
  String get untitledEntry;

  /// No description provided for @entryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Entry Updated!'**
  String get entryUpdated;

  /// No description provided for @toolSticker.
  ///
  /// In en, this message translates to:
  /// **'Sticker'**
  String get toolSticker;

  /// No description provided for @toolPhoto.
  ///
  /// In en, this message translates to:
  /// **'Photo'**
  String get toolPhoto;

  /// No description provided for @toolVoice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get toolVoice;

  /// No description provided for @toolType.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get toolType;

  /// No description provided for @toolRead.
  ///
  /// In en, this message translates to:
  /// **'Read'**
  String get toolRead;

  /// No description provided for @whiteNoise.
  ///
  /// In en, this message translates to:
  /// **'White Noise'**
  String get whiteNoise;

  /// No description provided for @chooseTrack.
  ///
  /// In en, this message translates to:
  /// **'Choose a track:'**
  String get chooseTrack;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @moodPulseTitle.
  ///
  /// In en, this message translates to:
  /// **'Mood Pulse'**
  String get moodPulseTitle;

  /// No description provided for @defaultFeedback.
  ///
  /// In en, this message translates to:
  /// **'Move the sliders to show how you\'re feeling right now.'**
  String get defaultFeedback;

  /// No description provided for @defaultAdvice.
  ///
  /// In en, this message translates to:
  /// **'We can take it one step at a time.'**
  String get defaultAdvice;

  /// No description provided for @feedbackOverwhelmed.
  ///
  /// In en, this message translates to:
  /// **'Everything feels loud and blurry right now. It\'s high-intensity chaos.'**
  String get feedbackOverwhelmed;

  /// No description provided for @adviceGrounding.
  ///
  /// In en, this message translates to:
  /// **'Advice: Your only job right now is to breathe. Try the 5-4-3-2-1 grounding technique: name 5 things you see, 4 things you can touch.'**
  String get adviceGrounding;

  /// No description provided for @feedbackSharp.
  ///
  /// In en, this message translates to:
  /// **'You\'re feeling a sharp, clear sense of distress or frustration.'**
  String get feedbackSharp;

  /// No description provided for @adviceExitEnergy.
  ///
  /// In en, this message translates to:
  /// **'Advice: This energy needs an exit. Try a \'cold water shock\' on your face or a quick, vigorous movement to reset your nervous system.'**
  String get adviceExitEnergy;

  /// No description provided for @feedbackHeavy.
  ///
  /// In en, this message translates to:
  /// **'You\'re carrying a heavy, foggy weight. It feels hard to even identify the \'why\'.'**
  String get feedbackHeavy;

  /// No description provided for @adviceComfort.
  ///
  /// In en, this message translates to:
  /// **'Advice: Don\'t fight the fog. Just focus on small comforts—a warm drink, a soft blanket, or dimming the lights.'**
  String get adviceComfort;

  /// No description provided for @feedbackSadness.
  ///
  /// In en, this message translates to:
  /// **'There is a quiet, clear sadness or disappointment present.'**
  String get feedbackSadness;

  /// No description provided for @adviceValidate.
  ///
  /// In en, this message translates to:
  /// **'Advice: It\'s okay to sit with this. Try writing down just three words that describe this weight. Validating it helps it pass.'**
  String get adviceValidate;

  /// No description provided for @feedbackHaze.
  ///
  /// In en, this message translates to:
  /// **'You\'re in a bit of a mental haze. Things feel a bit disconnected.'**
  String get feedbackHaze;

  /// No description provided for @adviceDigitalFast.
  ///
  /// In en, this message translates to:
  /// **'Advice: Your brain might be overstimulated. Try a 10-minute \'digital fast\'—put the phone away and look at something distant out a window.'**
  String get adviceDigitalFast;

  /// No description provided for @feedbackFlow.
  ///
  /// In en, this message translates to:
  /// **'You\'re in a beautiful state of flow and clarity.'**
  String get feedbackFlow;

  /// No description provided for @adviceCreativity.
  ///
  /// In en, this message translates to:
  /// **'Advice: This is a great time for creativity or connection. Carry this light with you into your next task.'**
  String get adviceCreativity;

  /// No description provided for @feedbackDreamy.
  ///
  /// In en, this message translates to:
  /// **'You\'re feeling a gentle, dreamy kind of happiness.'**
  String get feedbackDreamy;

  /// No description provided for @adviceDaydream.
  ///
  /// In en, this message translates to:
  /// **'Advice: Let yourself daydream. You don\'t need to be productive right now. Just enjoy the warmth.'**
  String get adviceDaydream;

  /// No description provided for @feedbackBalanced.
  ///
  /// In en, this message translates to:
  /// **'You\'re finding your balance in a steady, middle space.'**
  String get feedbackBalanced;

  /// No description provided for @adviceCheckBody.
  ///
  /// In en, this message translates to:
  /// **'Advice: Keep checking in with your body. Notice if your shoulders are tense and let them drop.'**
  String get adviceCheckBody;

  /// No description provided for @labelFoggy.
  ///
  /// In en, this message translates to:
  /// **'Foggy'**
  String get labelFoggy;

  /// No description provided for @labelClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get labelClear;

  /// No description provided for @labelNegative.
  ///
  /// In en, this message translates to:
  /// **'Negative'**
  String get labelNegative;

  /// No description provided for @labelPositive.
  ///
  /// In en, this message translates to:
  /// **'Positive'**
  String get labelPositive;

  /// No description provided for @labelSoftEnergy.
  ///
  /// In en, this message translates to:
  /// **'Soft Energy'**
  String get labelSoftEnergy;

  /// No description provided for @labelHighIntensity.
  ///
  /// In en, this message translates to:
  /// **'High Intensity'**
  String get labelHighIntensity;

  /// No description provided for @btnFeelHeard.
  ///
  /// In en, this message translates to:
  /// **'I feel heard'**
  String get btnFeelHeard;

  /// No description provided for @zenSpaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Zen Space'**
  String get zenSpaceTitle;

  /// No description provided for @zenInstructions.
  ///
  /// In en, this message translates to:
  /// **'Tap to ripple, Hold to glow'**
  String get zenInstructions;

  /// No description provided for @zenQuiet.
  ///
  /// In en, this message translates to:
  /// **'Quiet'**
  String get zenQuiet;

  /// No description provided for @zenSteady.
  ///
  /// In en, this message translates to:
  /// **'Steady'**
  String get zenSteady;

  /// No description provided for @zenVibrant.
  ///
  /// In en, this message translates to:
  /// **'Vibrant'**
  String get zenVibrant;

  /// No description provided for @savedConversationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved Conversations'**
  String get savedConversationsTitle;

  /// No description provided for @noSavedThreads.
  ///
  /// In en, this message translates to:
  /// **'No saved threads yet.'**
  String get noSavedThreads;

  /// No description provided for @defaultChatSession.
  ///
  /// In en, this message translates to:
  /// **'Chat Session'**
  String get defaultChatSession;

  /// No description provided for @deleteThreadTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Thread?'**
  String get deleteThreadTitle;

  /// No description provided for @deleteThreadContent.
  ///
  /// In en, this message translates to:
  /// **'This will permanently remove this conversation.'**
  String get deleteThreadContent;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @dateAtTime.
  ///
  /// In en, this message translates to:
  /// **'{date} at {time}'**
  String dateAtTime(String date, String time);

  /// No description provided for @sessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sessions'**
  String get sessionsTitle;

  /// No description provided for @upcomingSession.
  ///
  /// In en, this message translates to:
  /// **'Upcoming Session'**
  String get upcomingSession;

  /// No description provided for @allSessions.
  ///
  /// In en, this message translates to:
  /// **'All Sessions'**
  String get allSessions;

  /// No description provided for @clinicalPsychology.
  ///
  /// In en, this message translates to:
  /// **'Clinical Psychology'**
  String get clinicalPsychology;

  /// No description provided for @counseling.
  ///
  /// In en, this message translates to:
  /// **'Counseling'**
  String get counseling;

  /// No description provided for @reschedule.
  ///
  /// In en, this message translates to:
  /// **'Reschedule'**
  String get reschedule;

  /// No description provided for @joinNow.
  ///
  /// In en, this message translates to:
  /// **'Join Now'**
  String get joinNow;

  /// No description provided for @rebook.
  ///
  /// In en, this message translates to:
  /// **'Re-book'**
  String get rebook;

  /// No description provided for @tapToMove.
  ///
  /// In en, this message translates to:
  /// **'Tap the ball to move it.'**
  String get tapToMove;

  /// No description provided for @relaxAndEnjoy.
  ///
  /// In en, this message translates to:
  /// **'Just relax and enjoy.'**
  String get relaxAndEnjoy;

  /// No description provided for @whiteNoiseTitle.
  ///
  /// In en, this message translates to:
  /// **'White Noise Synthesizer'**
  String get whiteNoiseTitle;

  /// No description provided for @mixFrequency.
  ///
  /// In en, this message translates to:
  /// **'Mix your desired frequency:'**
  String get mixFrequency;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @noiseWhite.
  ///
  /// In en, this message translates to:
  /// **'WHITE Noise'**
  String get noiseWhite;

  /// No description provided for @noisePink.
  ///
  /// In en, this message translates to:
  /// **'PINK Noise'**
  String get noisePink;

  /// No description provided for @noiseBrown.
  ///
  /// In en, this message translates to:
  /// **'BROWN Noise'**
  String get noiseBrown;

  /// No description provided for @gratitudeTitle.
  ///
  /// In en, this message translates to:
  /// **'Gratitude Bubbles'**
  String get gratitudeTitle;

  /// No description provided for @addGratitude.
  ///
  /// In en, this message translates to:
  /// **'Add a Gratitude'**
  String get addGratitude;

  /// No description provided for @gratitudeHint.
  ///
  /// In en, this message translates to:
  /// **'What are you grateful for today?'**
  String get gratitudeHint;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noGratitudes.
  ///
  /// In en, this message translates to:
  /// **'No gratitudes yet. Add one to see it float!'**
  String get noGratitudes;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'hi', 'ta', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'hi':
      return AppLocalizationsHi();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
