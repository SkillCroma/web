// Packages
import 'package:flutter/material.dart';

// Functions
import 'package:skillcroma/functions.dart';

// Values
import 'package:skillcroma/values.dart';

class NavBarLinks extends StatelessWidget {
  const NavBarLinks({
    super.key,
    required this.label,
    required this.page,
    required this.isCurrentPage,
  });

  final String label;
  final pageName page;
  final bool isCurrentPage;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;

    return TextButton(
      onPressed: () => navigatePage(page),
      style: TextButton.styleFrom(
        backgroundColor: isCurrentPage
            ? Theme.of(context).colorScheme.surfaceContainer
            : Colors.transparent,
      ),
      child: Text(
        label,
        style: textTheme.titleMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
      ),
    );
  }
}
