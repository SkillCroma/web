// Packages
import 'package:flutter/material.dart';

class NumbersContainer extends StatelessWidget {
  const NumbersContainer({
    super.key,
    required this.title,
    required this.subtitle,
    required this.text,
  });

  final String title;
  final String subtitle;
  final String text;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    bool isDesktop = size.width > 800;
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      width: isDesktop ? size.width * 0.2 : double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title, style: textTheme.displayLarge?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Text(subtitle, style: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(text, style: textTheme.titleMedium),
        ],
      ),
    );
  }
}
