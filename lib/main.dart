// Packages
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// Pages
import 'package:skillcroma/pages/leaderboard_page.dart';
import 'package:skillcroma/pages/upcoming_page.dart';
import 'package:skillcroma/pages/contact_page.dart';
import 'package:skillcroma/pages/home_page.dart';
import 'package:skillcroma/pages/news_page.dart';

// Theme
import 'package:skillcroma/theme/theme.dart';
import 'package:skillcroma/theme/util.dart';

// Values
import 'package:skillcroma/values.dart';

// Options
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      initialRoute: pageName.home.name,
      onGenerateRoute: (page) {
        final routeName = page.name;
        if (routeName == pageName.home.name) {
          return PageRouteBuilder(
            pageBuilder: (_, _, _) => const HomePage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        } else if (routeName == pageName.news.name) {
          return PageRouteBuilder(
            pageBuilder: (_, _, _) => const NewsPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        } else if (routeName == pageName.upcoming.name) {
          return PageRouteBuilder(
            pageBuilder: (_, _, _) => const UpcomingPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        } else if (routeName == pageName.leaderboards.name) {
          return PageRouteBuilder(
            pageBuilder: (_, _, _) => const LeaderboardPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        } else if (routeName == pageName.contact.name) {
          return PageRouteBuilder(
            pageBuilder: (_, _, _) => const ContactPage(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          );
        }
        return null;
      },
    );
  }
}
