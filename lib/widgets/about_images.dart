// Packages
import 'package:flutter/material.dart';

class AboutImages extends StatelessWidget {
  const AboutImages({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(24),
      child: Image.asset(image, fit: .cover, height: 320, width: 280),
    );
  }
}
