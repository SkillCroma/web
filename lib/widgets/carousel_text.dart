// Packages
import 'package:flutter/material.dart';

class CarouselText extends StatelessWidget {
  const CarouselText({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurface),
    );
  }
}
