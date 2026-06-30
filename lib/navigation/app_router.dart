import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Pages
import 'package:skillcroma/pages/home_page.dart';
import 'package:skillcroma/pages/products_page.dart';
import 'package:skillcroma/pages/upcoming_page.dart';
import 'package:skillcroma/pages/leaderboard_page.dart';
import 'package:skillcroma/pages/about_page.dart';
import 'package:skillcroma/pages/legal_page.dart';
import 'package:skillcroma/pages/contact_page.dart';

// Values
import 'package:skillcroma/values.dart';

class AppRouter {
  // Centralized route definition map
  static Widget getPage(String routeName) {
    if (routeName == PageName.home.route) {
      return const HomePage();
    } else if (routeName == PageName.products.route) {
      return const ProductsPage();
    } else if (routeName == PageName.upcoming.route) {
      return const UpcomingPage();
    } else if (routeName == PageName.leaderboards.route) {
      return const LeaderboardPage();
    } else if (routeName == PageName.about.route) {
      return const AboutPage();
    } else if (routeName == PageName.privacyPolicies.route) {
      return const LegalPage(isPrivacyPolicy: true);
    } else if (routeName == PageName.termsAndConditions.route) {
      return const LegalPage(isPrivacyPolicy: false);
    } else if (routeName == PageName.contact.route) {
      return const ContactPage();
    }
    // Fallback/Unknown Route
    return const HomePage();
  }

  // Generate page route with custom transition animations
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? PageName.home.route;
    
    return PageRouteBuilder(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => getPage(routeName),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
    );
  }

  // Centralized Navigation methods
  static void navigateTo(BuildContext context, PageName page) {
    if (page == PageName.mail) {
      _launchMail();
      return;
    }
    Navigator.pushNamed(context, page.route);
    log('Pushed route: ${page.route}', name: 'AppRouter');
  }

  static void replaceWith(BuildContext context, PageName page) {
    if (page == PageName.mail) {
      _launchMail();
      return;
    }
    Navigator.pushReplacementNamed(context, page.route);
    log('Replaced route with: ${page.route}', name: 'AppRouter');
  }

  static void pop(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      log('Popped route', name: 'AppRouter');
    }
  }

  static void _launchMail() {
    launchUrl(Uri.parse('mailto:hello@skillcroma.com'));
    log('Launched mailto link', name: 'AppRouter');
  }
}
