// Packages
import 'package:flutter/material.dart';

// Functions
import 'package:skillcroma/functions.dart';

// Values
import 'package:skillcroma/values.dart';

class NavBarLinks extends StatelessWidget {
  const NavBarLinks({super.key, required this.label, required this.page});

  final String label;
  final pageName page;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () => navigatePage(page), child: Text(label));
  }
}
