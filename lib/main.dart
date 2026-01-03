import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Localization and Theme Imports
import 'package:renbo/l10n/gen/app_localizations.dart';
import 'utils/theme.dart';
import 'providers/mood_provider.dart';
import 'providers/capsule_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';
import 'firebase_options.dart';

// Screen Imports
import 'screens/welcome_screen.dart';
import 'screens/auth_page.dart';
import 'screens/home_screen.dart';

// Service Imports
import 'services/journal_storage.dart';
import 'services/gratitude_storage.dart';
import 'services/app_usage_service.dart'; // Integrated usage service

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    // 1. Load Environment Variables
    await dotenv.load(fileName: ".env");

    // 2. Initialize Firebase
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // 3. Initialize Hive and Storage Services
    await Hive.initFlutter();
    await JournalStorage.init();
    await GratitudeStorage.init();

    // 4. Initialize Real-Time Usage Tracking
    final usageService = AppUsageService();
    usageService.init();

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => MoodProvider()),
          ChangeNotifierProvider(create: (context) => CapsuleProvider()),
          ChangeNotifierProvider(create: (context) => ThemeProvider()),
          ChangeNotifierProvider(create: (context) => LocaleProvider()),
          // Providing the usage service as a value so it's accessible via context
          Provider.value(value: usageService),
        ],
        child: const MyApp(),
      ),
    );
  } catch (e) {
    debugPrint("Initialization Error: $e");
    // Fallback UI in case of a critical boot failure
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text("App failed to start. Please restart.\nError: $e"),
          ),
        ),
      ),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing providers for dynamic UI updates (Locale and Theme)
    final localeProvider = Provider.of<LocaleProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'Renbo',
      debugShowCheckedModeBanner: false,

      // Theme Configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,

      // Localization Configuration
      locale: localeProvider.locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],

      // Navigation Logic
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
        // Show loading while checking Firebase Auth status
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // If snapshot has user data, user is logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // Otherwise, send them to the login/auth page
        return const AuthPage();
      },
    );
  }
}
