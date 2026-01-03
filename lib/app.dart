import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Localization and Theme Imports
import 'package:renbo/l10n/gen/app_localizations.dart';
import 'utils/theme.dart';
import 'providers/theme_provider.dart';
import 'providers/locale_provider.dart';

// Screen Imports
import 'screens/welcome_screen.dart';
import 'screens/auth_page.dart';
import 'screens/home_screen.dart';
import 'main.dart'; // To access AuthCheck if defined there

class RenboApp extends StatelessWidget {
  const RenboApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Consume providers to allow real-time theme and language switching
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
      // We use '/welcome' as the initial route to match your main.dart configuration
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
