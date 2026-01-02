import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// Import directly from your folder
import 'package:renbo/l10n/gen/app_localizations.dart';

import 'utils/theme.dart';
import 'providers/mood_provider.dart';
import 'providers/capsule_provider.dart';
import 'providers/locale_provider.dart';
import 'firebase_options.dart';
import 'screens/welcome_screen.dart';
import 'screens/auth_page.dart';
import 'screens/home_screen.dart';
import 'services/journal_storage.dart';
import 'services/gratitude_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  await JournalStorage.init();
  await GratitudeStorage.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => MoodProvider()),
        ChangeNotifierProvider(create: (context) => CapsuleProvider()),
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      title: 'Renbo',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,

      // 🌍 LOCALIZATION SETUP 🌍
      locale: provider.locale, 
      supportedLocales: L10n.all,
      
      // ✅ FIX: Removed 'const' keyword here
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/auth_check': (context) => const AuthCheck(),
        '/home': (context) => const HomeScreen(),
        '/login': (context) => const AuthPage(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  const AuthCheck({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        }
        return const AuthPage();
      },
    );
  }
}