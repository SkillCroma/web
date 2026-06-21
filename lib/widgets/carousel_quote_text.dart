// Packages
import 'package:flutter/material.dart';

class CarouselQuoteText extends StatelessWidget {
  const CarouselQuoteText({
    super.key,
    required this.text,
    this.textAlign = .left,
  });

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      textAlign: textAlign,
      style: textTheme.displayLarge?.copyWith(
        fontWeight: .w600,
        color: colorScheme.onSurface,
      ),
    );
  }
}
