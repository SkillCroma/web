// Packages
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:flutter/material.dart';

// Functions
import 'package:skillcroma/functions.dart';

// Values
import 'package:skillcroma/values.dart';

class FooterLink extends StatelessWidget {
  const FooterLink({
    super.key,
    required this.label,
    this.socialMedia,
    this.page,
  });

  final String label;
  final socialMediaTypes? socialMedia;
  final pageName? page;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {
          if (page != null) {
            navigatePage(context, page!);
          }
          if (socialMedia != null) {
            launchSocialMedia(socialMedia!);
          }
        },
        child: Row(
          children: [
            Text(
              label,
              style: textTheme.titleMedium?.copyWith(
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Icon(HugeIconsStroke.arrowUpRight01),
          ],
        ),
      ),
    );
  }
}
