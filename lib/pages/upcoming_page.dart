// Packages
import 'package:flutter/material.dart';

// Widgets
import 'package:skillcroma/widgets/app_bar.dart';

class UpcomingPage extends StatelessWidget {
  const UpcomingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(currentPage: .upcoming),
      body: ListView(),
    );
  }
}
