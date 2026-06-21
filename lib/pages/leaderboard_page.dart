// Packages
import 'package:flutter/material.dart';

// Widgets
import 'package:skillcroma/widgets/app_bar.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(currentPage: .leaderboards),
      body: ListView(),
    );
  }
}
