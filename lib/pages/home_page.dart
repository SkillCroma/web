// Packages
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:svg_flutter/svg_flutter.dart';
import 'package:flutter/material.dart';

// Widgets
import 'package:skillcroma/widgets/nav_bar_links.dart';

// Values
import 'package:skillcroma/values.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness =
        View.of(context).platformDispatcher.platformBrightness ==
            Brightness.dark
        ? "light"
        : "dark";
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: colorScheme.primaryContainer,
        title: IconButton(
          onPressed: () {},
          icon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset("assets/$brightness/icon.svg", height: 32),
              const SizedBox(width: 8),
              Text("SkillCroma", style: textTheme.titleLarge),
            ],
          ),
        ),
        actions: [
          NavBarLinks(label: "Home", onPressed: () {}),
          NavBarLinks(label: "News", onPressed: () {}),
          NavBarLinks(label: "Upcoming", onPressed: () {}),
          NavBarLinks(label: "Leaderboards", onPressed: () {}),
          NavBarLinks(label: "Contact", onPressed: () {}),
          SizedBox(width: 24),
        ],
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              Image.asset(
                'assets/common/carousel_image_1.png',
                width: size.width,
                fit: .cover,
                height: size.height - kToolbarHeight,
              ),
              Container(
                padding: const EdgeInsets.all(80),
                height: size.height - kToolbarHeight,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .bottomLeft,
                    end: .topRight,
                    colors: [colorScheme.surface, Colors.transparent],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Spacer(),
                    CarouselQuoteText(text: "DON'T BE AVERAGE,"),
                    CarouselQuoteText(text: "WHEN YOU HAVE FULL"),
                    CarouselQuoteText(text: "POTENTIAL"),
                    const SizedBox(height: 40),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colorScheme.onSurfaceVariant,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: Text(
                              "START FREE TRIAL",
                              style: textTheme.titleLarge?.copyWith(
                                color: colorScheme.surface,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 24),
                        Column(
                          crossAxisAlignment: .start,
                          mainAxisSize: .min,
                          children: [
                            CarouselText(text: "Get 7 days free, then"),
                            CarouselText(
                              text: "3 Months for ₹ $subscriptionValue/month",
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: size.width,
            height: size.height * 0.75,
            padding: const EdgeInsets.all(80),
            color: colorScheme.surfaceContainerLowest,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      "About SkillCroma",
                      style: textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onSurface,
                        decoration: .underline,
                        decorationThickness: 2,
                        decorationColor: colorScheme.onSurface,
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: .start,
                      mainAxisSize: .min,
                      children: [
                        SizedBox(
                          width: size.width * 0.35,
                          child: CarouselQuoteText(
                            text: "SPEED IS MORE",
                            textAlign: .end,
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.35,
                          child: CarouselQuoteText(
                            text: "THAN MOTION; IT",
                            textAlign: .end,
                          ),
                        ),
                        CarouselQuoteText(text: "IS INTELLIGENCE IN"),
                        CarouselQuoteText(text: "ACTION"),
                      ],
                    ),
                    Spacer(flex: 2),
                    Column(
                      mainAxisSize: .min,
                      children: [
                        SocialMedia(icon: HugeIconsStroke.newTwitter),
                        const SizedBox(height: 8),
                        SocialMedia(icon: HugeIconsStroke.linkedin02),
                        const SizedBox(height: 8),
                        SocialMedia(icon: HugeIconsStroke.instagram),
                        const SizedBox(height: 8),
                        SocialMedia(icon: HugeIconsStroke.facebook02),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: size.width * 0.35,
                      child: Text(
                        "At SkillCroma, we believe every young young athlete deserves the right opportunity to shine.Many talented players have passion and potential but lack proper guidance and exposure.Our mission is to identify genuine talent through professional performance analysis and skill evaluation.",
                        style: textTheme.bodyLarge,
                      ),
                    ),
                    Spacer(),
                    AboutImages(image: "assets/common/About_Image_1.png"),
                    const SizedBox(width: 16),
                    AboutImages(image: "assets/common/About_Image_2.png"),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: size.height - kToolbarHeight,
            width: size.width,
            padding: const EdgeInsets.all(80),
            color: colorScheme.surface,
            child: Row(
              children: [
                SizedBox(
                  width: size.width * 0.45,
                  child: Column(
                    crossAxisAlignment: .start,
                    mainAxisAlignment: .start,
                    children: [
                      Text(
                        "BY THE NUMBERS",
                        style: textTheme.displaySmall?.copyWith(
                          fontWeight: .bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        "Our proven track record speaks for itself. Join other organizations who have transformed their performance",
                        style: textTheme.titleLarge,
                      ),
                      Spacer(),
                      Row(
                        mainAxisSize: .min,
                        children: [
                          NumbersContainer(
                            title: "20 +",
                            subtitle: "Training Programmes",
                            text:
                                "Professional or Amateur Athelets trust our platform",
                          ),
                          const SizedBox(width: 24),
                          NumbersContainer(
                            title: "50 +",
                            subtitle: "Championships",
                            text:
                                "Customized Programs for every Organizations and Skill Levels",
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 50),
                ClipRRect(
                  borderRadius: .circular(48),
                  child: Image.asset(
                    "assets/common/By_The_Numbers.png",
                    fit: .cover,
                    height: double.infinity,
                    width: size.width * 0.4,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: size.height * 0.75,
            width: size.width,
            color: colorScheme.surfaceContainerHighest,
            padding: .all(80),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      "SKILLCROMA",
                      style: textTheme.displayLarge?.copyWith(
                        fontSize: 120,
                        fontWeight: .bold,
                      ),
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: .end,
                      children: [
                        FooterLink(label: "Programmes"),
                        FooterLink(label: "Products"),
                        FooterLink(label: "About"),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: size.width * 0.15,
                          child: Divider(
                            color: colorScheme.outline.withAlpha(125),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FooterLink(label: "X (formerly Twitter)"),
                        FooterLink(label: "LinkedIn"),
                        FooterLink(label: "Instagram"),
                        FooterLink(label: "Facebook"),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 64),
                Divider(color: colorScheme.outline.withAlpha(125)),
                const SizedBox(height: 64),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: Text("Privacy Policies"),
                    ),
                    const SizedBox(width: 48),
                    TextButton(
                      onPressed: () {},
                      child: Text("Terms & Conditions"),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text("hello@skillcroma.com"),
                    ),
                    const SizedBox(width: 48),
                    Text("© Design by Santhosh Sivakumar, 2026"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
/* Widgets used in this Page */

// Footer Link
class FooterLink extends StatelessWidget {
  const FooterLink({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        onPressed: () {},
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

// Numbers Container
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

// About Images
class AboutImages extends StatelessWidget {
  const AboutImages({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: .circular(24),
      child: Image.asset(image, fit: .cover, height: 320, width: 280),
    );
  }
}

// Social Media
class SocialMedia extends StatelessWidget {
  const SocialMedia({super.key, required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      onPressed: () {},
      style: IconButton.styleFrom(
        backgroundColor: colorScheme.surfaceContainer,
        foregroundColor: colorScheme.onSurface,
      ),
      icon: Icon(icon),
    );
  }
}

// Carousel Text
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

// Carousel Quote Text
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
