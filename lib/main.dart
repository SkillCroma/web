// Packages
import 'package:flutter/material.dart';

// Pages
import 'package:skillcroma/pages/home_page.dart';

// Theme
import 'package:skillcroma/theme/theme.dart';
import 'package:skillcroma/theme/util.dart';

void main() {
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
      routes: {'/': (_) => const HomePage()},
    );
  }
}
