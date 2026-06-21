// Packages
import 'package:flutter/material.dart';

// Widgets
import 'package:skillcroma/widgets/app_bar.dart';

class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(currentPage: .news),
      body: ListView(),
    );
  }
}
