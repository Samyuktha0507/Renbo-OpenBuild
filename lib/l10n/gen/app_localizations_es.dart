// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Renbo';

  @override
  String get settings => 'Configuración';

  @override
  String get selectLanguage => 'Seleccionar Idioma';

  @override
  String get accountDetails => 'Account Details';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get analytics => 'Analytics';

  @override
  String get wellnessDashboard => 'Wellness Dashboard';

  @override
  String get viewTrends => 'View your mental health trends';

  @override
  String get preferences => 'Preferences';

  @override
  String get logout => 'Log Out';

  @override
  String helloUser(String userName) {
    return 'Hola, $userName!';
  }

  @override
  String get thoughtOfDay => 'Pensamiento del día';

  @override
  String get selfCareCheckIn => 'Chequeo de Autocuidado';

  @override
  String get hydrate => 'Hidratarse';

  @override
  String get hydrateDesc =>
      'El agua es combustible para la resiliencia. Incluso un pequeño sorbo ayuda.';

  @override
  String get nourish => 'Nutrir';

  @override
  String get nourishDesc =>
      'Tu cuerpo necesita energía. Un refrigerio suave es amor propio.';

  @override
  String get rest => 'Descansar';

  @override
  String get restDesc =>
      'Está bien pausar. La recuperación requiere momentos tranquilos.';

  @override
  String get breathe => 'Respirar';

  @override
  String get breatheDesc =>
      'Toma una respiración profunda, solo para ti. Deja que el aire te conecte.';

  @override
  String get journal => 'Diario';

  @override
  String get chatRen => 'Hablar con Ren';

  @override
  String get meditation => 'Meditación';

  @override
  String get game => 'Juego';

  @override
  String get gratitude => 'Gratitud';

  @override
  String get vault => 'Bóveda';

  @override
  String get zenSpace => 'Espacio Zen';

  @override
  String get moodPulse => 'Pulso Emocional';

  @override
  String get hotlines => 'Líneas de Ayuda';

  @override
  String get cloudSyncComplete => 'Sincronización completa';

  @override
  String get loadingThought => 'Cargando pensamiento...';

  @override
  String get defaultThought =>
      'La mejor forma de predecir el futuro es crearlo.';

  @override
  String get breathingGuide => 'Guía de Respiración';

  @override
  String get breatheIn => 'Inhala';

  @override
  String get hold => 'Mantén';

  @override
  String get breatheOut => 'Exhala';

  @override
  String get startBreathing => 'Comenzar';

  @override
  String get pauseBreathing => 'Pausar';

  @override
  String get journalCalendar => 'Calendario Diario';

  @override
  String get newEntry => 'Nueva Entrada';

  @override
  String todayIs(String date) {
    return 'Hoy es $date';
  }

  @override
  String get viewAllEntries => 'Ver todas las entradas';

  @override
  String get howAreYouFeeling => '¿Cómo te sientes?';

  @override
  String get moodHappy => 'Feliz';

  @override
  String get moodSad => 'Triste';

  @override
  String get moodAngry => 'Enojado';

  @override
  String get moodConfused => 'Confundido';

  @override
  String get moodExcited => 'Emocionado';

  @override
  String get moodCalm => 'Tranquilo';

  @override
  String get moodNeutral => 'Neutral';

  @override
  String get vaultTitle => 'Bóveda Emocional';

  @override
  String get tabUnlocked => 'Desbloqueado';

  @override
  String get tabLocked => 'Bloqueado';

  @override
  String get vaultEmpty => 'Tu bóveda está vacía actualmente.';

  @override
  String get readyToOpen => '¡Listo para abrir!';

  @override
  String unlocksInDays(int count) {
    return 'Desbloquea en ${count}d';
  }

  @override
  String unlocksInHours(int count) {
    return 'Desbloquea en ${count}h';
  }

  @override
  String unlocksInMinutes(int count) {
    return 'Desbloquea en ${count}m';
  }

  @override
  String unlocksInSeconds(int count) {
    return 'Desbloquea en ${count}s';
  }

  @override
  String patienceMessage(String time) {
    return '¡Paciencia! $time';
  }

  @override
  String get messageFromPast => 'Un Mensaje del Pasado';

  @override
  String sealedOn(String date) {
    return 'Sellado el $date';
  }

  @override
  String get close => 'Cerrar';

  @override
  String get chatTitle => 'Chat con Renbot';

  @override
  String get endSession => '¿Terminar Sesión?';

  @override
  String get saveThreadQuestion => '¿Te gustaría guardar este hilo?';

  @override
  String get discard => 'Descartar';

  @override
  String get saveThread => 'Guardar Hilo';

  @override
  String sessionDefaultTitle(String date) {
    return 'Sesión: $date';
  }

  @override
  String get connectionError => 'Tengo problemas para conectarme. 😞';

  @override
  String get youAreNotAlone => 'No Estás Solo';

  @override
  String get hotlineQuestion => '¿Te gustaría ver líneas de ayuda?';

  @override
  String get notNow => 'Ahora No';

  @override
  String get viewHotlines => 'Ver Líneas';

  @override
  String get savedThreads => 'Hilos Guardados';

  @override
  String get listening => 'Escuchando...';

  @override
  String get messageHint => 'Mensaje...';

  @override
  String get newTimeCapsule => 'Nueva Cápsula';

  @override
  String get dearFutureMe => 'Querido yo del futuro...';

  @override
  String get unlocksAt => 'Se desbloquea:';

  @override
  String get sealCapsule => 'Sellar Cápsula';

  @override
  String get capsuleEmptyError => 'Escribe un mensaje para tu futuro yo.';

  @override
  String get capsuleTimeError => 'Selecciona una fecha en el futuro.';

  @override
  String get capsuleSealed => '¡Cápsula sellada y enviada al futuro! 🚀';

  @override
  String get emotionHappy => '😊 Feliz';

  @override
  String get emotionSad => '😢 Triste';

  @override
  String get emotionAngry => '😡 Enojado';

  @override
  String get emotionTired => '😴 Cansado';

  @override
  String get msgHappy => '¡Eso es maravilloso!';

  @override
  String get msgSad => 'Lamento que te sientas así.';

  @override
  String get msgAngry => 'Está bien sentirse molesto.';

  @override
  String get msgTired => 'El descanso es importante, tómatelo con calma.';

  @override
  String get journalPrompt => '¿Te gustaría escribir sobre esto?';

  @override
  String get yesJournal => 'Sí, escribir';

  @override
  String get no => 'No';

  @override
  String get hotlinesTitle => 'Líneas de Ayuda Mental';

  @override
  String callTooltip(String phone) {
    return 'Llamar a $phone';
  }

  @override
  String contactPrefix(String person) {
    return 'Contacto: $person';
  }

  @override
  String get hotlineKiran => 'Línea de Ayuda KIRAN';

  @override
  String get descKiran => 'Apoyo 24/7 para estrés, ansiedad, depresión.';

  @override
  String get personKiran => 'Consejeros Capacitados';

  @override
  String get hotlineVandrevala => 'Fundación Vandrevala';

  @override
  String get descVandrevala => 'Apoyo para angustia emocional y depresión.';

  @override
  String get personVandrevala => 'Consejeros de la Fundación';

  @override
  String get hotlineSnehi => 'Snehi (ONG)';

  @override
  String get descSnehi => 'Apoyo emocional para prevención del suicidio.';

  @override
  String get personSnehi => 'Voluntarios de Snehi';

  @override
  String get untitled => 'Sin Título';

  @override
  String get editJournalEntry => 'Editar Entrada';

  @override
  String get editEntryHint => 'Edita tu entrada...';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get changeImage => 'Cambiar Imagen';

  @override
  String get recordAudio => 'Grabar Audio';

  @override
  String get stopRecording => 'Detener';

  @override
  String get recordingStopped => 'Grabación detenida';

  @override
  String get recordingStarted => 'Grabación iniciada';

  @override
  String get permissionDenied => 'Permiso denegado';

  @override
  String get emptyEntryError =>
      'Por favor escribe, graba o añade una imagen antes de guardar.';

  @override
  String get noEntriesYet => 'No hay entradas aún.\n¡Empieza tu viaje hoy!';

  @override
  String get noEntriesForDay =>
      'No hay entradas para este día.\n¡Toca aquí para escribir!';

  @override
  String get monthLabel => 'Mes';

  @override
  String get journalTitleHint => 'Título...';

  @override
  String get journalContentHint => '¿Cómo estuvo tu día?';

  @override
  String get untitledEntry => 'Entrada sin título';

  @override
  String get entryUpdated => '¡Entrada actualizada!';

  @override
  String get toolSticker => 'Sticker';

  @override
  String get toolPhoto => 'Foto';

  @override
  String get toolVoice => 'Voz';

  @override
  String get toolType => 'Escribir';

  @override
  String get toolRead => 'Leer';

  @override
  String get whiteNoise => 'Ruido Blanco';

  @override
  String get chooseTrack => 'Elige una pista:';

  @override
  String get reset => 'Reiniciar';

  @override
  String get start => 'Inicio';

  @override
  String get moodPulseTitle => 'Pulso Emocional';

  @override
  String get defaultFeedback =>
      'Mueve los controles para mostrar cómo te sientes.';

  @override
  String get defaultAdvice => 'Podemos ir paso a paso.';

  @override
  String get feedbackOverwhelmed =>
      'Todo se siente ruidoso y borroso. Es un caos de alta intensidad.';

  @override
  String get adviceGrounding =>
      'Consejo: Tu único trabajo ahora es respirar. Prueba la técnica 5-4-3-2-1: nombra 5 cosas que ves, 4 que puedes tocar.';

  @override
  String get feedbackSharp =>
      'Sientes una angustia o frustración aguda y clara.';

  @override
  String get adviceExitEnergy =>
      'Consejo: Esta energía necesita salir. Lávate la cara con agua fría o haz un movimiento rápido para reiniciar tu sistema.';

  @override
  String get feedbackHeavy =>
      'Cargas un peso pesado y difuso. Es difícil identificar el \'por qué\'.';

  @override
  String get adviceComfort =>
      'Consejo: No luches contra la niebla. Busca pequeños consuelos: una bebida caliente, una manta suave o bajar las luces.';

  @override
  String get feedbackSadness =>
      'Hay una tristeza o decepción tranquila y clara presente.';

  @override
  String get adviceValidate =>
      'Consejo: Está bien sentir esto. Escribe tres palabras que describan este peso. Validarlo ayuda a que pase.';

  @override
  String get feedbackHaze =>
      'Estás en una neblina mental. Las cosas se sienten desconectadas.';

  @override
  String get adviceDigitalFast =>
      'Consejo: Tu cerebro puede estar sobreestimulado. Prueba un \'ayuno digital\' de 10 min: deja el teléfono y mira por la ventana.';

  @override
  String get feedbackFlow => 'Estás en un hermoso estado de flujo y claridad.';

  @override
  String get adviceCreativity =>
      'Consejo: Es un gran momento para crear o conectar. Lleva esta luz contigo a tu siguiente tarea.';

  @override
  String get feedbackDreamy => 'Sientes una felicidad suave y soñadora.';

  @override
  String get adviceDaydream =>
      'Consejo: Déjate soñar despierto. No necesitas ser productivo ahora. Solo disfruta la calidez.';

  @override
  String get feedbackBalanced =>
      'Estás encontrando tu equilibrio en un espacio estable.';

  @override
  String get adviceCheckBody =>
      'Consejo: Revisa tu cuerpo. Nota si tus hombros están tensos y déjalos caer.';

  @override
  String get labelFoggy => 'Confuso';

  @override
  String get labelClear => 'Claro';

  @override
  String get labelNegative => 'Negativo';

  @override
  String get labelPositive => 'Positivo';

  @override
  String get labelSoftEnergy => 'Energía Suave';

  @override
  String get labelHighIntensity => 'Alta Intensidad';

  @override
  String get btnFeelHeard => 'Me siento escuchado';

  @override
  String get zenSpaceTitle => 'Espacio Zen';

  @override
  String get zenInstructions => 'Toca para ondular, Mantén para brillar';

  @override
  String get zenQuiet => 'Tranquilo';

  @override
  String get zenSteady => 'Estable';

  @override
  String get zenVibrant => 'Vibrante';

  @override
  String get savedConversationsTitle => 'Conversaciones Guardadas';

  @override
  String get noSavedThreads => 'Aún no hay hilos guardados.';

  @override
  String get defaultChatSession => 'Sesión de Chat';

  @override
  String get deleteThreadTitle => '¿Eliminar Hilo?';

  @override
  String get deleteThreadContent =>
      'Esto eliminará permanentemente esta conversación.';

  @override
  String get cancel => 'Cancelar';

  @override
  String get delete => 'Eliminar';

  @override
  String dateAtTime(String date, String time) {
    return '$date a las $time';
  }

  @override
  String get sessionsTitle => 'Sesiones';

  @override
  String get upcomingSession => 'Próxima Sesión';

  @override
  String get allSessions => 'Todas las Sesiones';

  @override
  String get clinicalPsychology => 'Psicología Clínica';

  @override
  String get counseling => 'Consejería';

  @override
  String get reschedule => 'Reprogramar';

  @override
  String get joinNow => 'Unirse Ahora';

  @override
  String get rebook => 'Reservar de nuevo';

  @override
  String get tapToMove => 'Toca la bola para moverla.';

  @override
  String get relaxAndEnjoy => 'Solo relájate y disfruta.';

  @override
  String get whiteNoiseTitle => 'Sintetizador de Ruido Blanco';

  @override
  String get mixFrequency => 'Mezcla tu frecuencia deseada:';

  @override
  String get goBack => 'Volver';

  @override
  String get noiseWhite => 'Ruido BLANCO';

  @override
  String get noisePink => 'Ruido ROSA';

  @override
  String get noiseBrown => 'Ruido MARRÓN';

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
