// Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Pages
import 'package:skillcroma/pages/leaderboard_page.dart';
import 'package:skillcroma/pages/upcoming_page.dart';
import 'package:skillcroma/pages/home_page.dart';
import 'package:skillcroma/pages/news_page.dart';

// Theme
import 'package:skillcroma/theme/theme.dart';
import 'package:skillcroma/theme/util.dart';

// Values
import 'package:skillcroma/values.dart';

import 'dart:ui';

// Options
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  
  // Global Exception Handling
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
  };
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('Async error: $error\n$stack');
    return true;
  };
  
  // Custom Error Widget for UI Overflow/Crashes
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.red.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.red.withValues(alpha: 0.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.red, size: 48),
              const SizedBox(height: 16),
              const Text(
                'UI Exception Caught',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 8),
              Text(
                details.exceptionAsString(),
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  };

  runApp(const SkillCromaWeb());
}

class SkillCromaWeb extends StatelessWidget {
  const SkillCromaWeb({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, "Nunito Sans", "Nunito");
    MaterialTheme theme = MaterialTheme(textTheme);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SkillCroma",
      theme: theme.dark(),
      initialRoute: PageName.home.name,
      onGenerateRoute: (page) {
        final routeName = page.name;
        Widget pageWidget;

        if (routeName == PageName.home.name) {
          pageWidget = const HomePage();
        } else if (routeName == PageName.news.name) {
          pageWidget = const NewsPage();
        } else if (routeName == PageName.upcoming.name) {
          pageWidget = const UpcomingPage();
        } else if (routeName == PageName.leaderboards.name) {
          pageWidget = const LeaderboardPage();
        } else {
          return null;
        }

        return PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => pageWidget,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 300),
          reverseTransitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}
