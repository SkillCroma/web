// Packages
import 'package:flutter/material.dart';
import 'dart:developer';

// Values
import 'package:skillcroma/values.dart';

// NAVIGATIONS
void navigatePage(context, pageName page) {
  // TODO: Implement function
  Navigator.pushReplacementNamed(context, page.name);
  log(page.name, name: "Nav");
}

// SOCIAL MEDIA
void launchSocialMedia(socialMediaTypes social) {
  // TODO: Implement function
  log(social.name, name: "Soc");
}
