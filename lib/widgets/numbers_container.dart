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
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Container(
      width: size.width * 0.2,
      height: size.height * 0.35,
      padding: .all(24),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHigh,
        borderRadius: .circular(24),
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(title, style: textTheme.displayLarge),
          Spacer(),
          Text(subtitle, style: textTheme.headlineLarge),
          Text(text, style: textTheme.titleMedium),
        ],
      ),
    );
  }
}
