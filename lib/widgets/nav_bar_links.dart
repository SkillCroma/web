// Packages
import 'package:flutter/material.dart';

class NavBarLinks extends StatelessWidget {
  const NavBarLinks({super.key, required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: onPressed, child: Text(label));
  }
}
