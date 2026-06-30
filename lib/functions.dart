// Packages
import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:url_launcher/url_launcher.dart';

// Values
import 'package:skillcroma/values.dart';

import 'package:skillcroma/navigation/app_router.dart';

// NAVIGATIONS
void navigatePage(BuildContext context, PageName page) {
  AppRouter.replaceWith(context, page);
}

// SOCIAL MEDIA
void launchSocialMedia(SocialMediaTypes social) {
  String urlString = '';
  switch (social) {
    case SocialMediaTypes.twitter:
      urlString = 'https://x.com/skillcroma';
      break;
    case SocialMediaTypes.linkedIn:
      urlString = 'https://linkedin.com/company/skillcroma';
      break;
    case SocialMediaTypes.instagram:
      urlString = 'https://instagram.com/skillcroma';
      break;
    case SocialMediaTypes.facebook:
      urlString = 'https://facebook.com/skillcroma';
      break;
    case SocialMediaTypes.youtube:
      urlString = 'https://youtube.com/@skillcroma';
      break;
  }
  if (urlString.isNotEmpty) {
    launchUrl(Uri.parse(urlString), mode: LaunchMode.externalApplication);
    log(social.name, name: "Soc");
  }
}
