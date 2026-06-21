// Packages
import 'package:flutter/material.dart';

// Functions
import 'package:skillcroma/functions.dart';

// Values
import 'package:skillcroma/values.dart';

class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key, required this.socialMedia, required this.icon});

  final socialMediaTypes socialMedia;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () => launchSocialMedia(socialMedia),
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.onSurface,
      ),
      icon: Icon(icon),
    );
  }
}
