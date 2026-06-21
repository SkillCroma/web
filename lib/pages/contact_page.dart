// Packages
import 'package:flutter/material.dart';

// Widgets
import 'package:skillcroma/widgets/app_bar.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(currentPage: .contact),
      body: ListView(),
    );
  }
}
