// Packages
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:flutter/material.dart';

// Widgets
import 'package:skillcroma/widgets/carousel_quote_text.dart';
import 'package:skillcroma/widgets/numbers_container.dart';
import 'package:skillcroma/widgets/carousel_text.dart';
import 'package:skillcroma/widgets/social_media.dart';
import 'package:skillcroma/widgets/about_images.dart';
import 'package:skillcroma/widgets/footer_link.dart';
import 'package:skillcroma/widgets/app_bar.dart';

// Functions
import 'package:skillcroma/functions.dart';

// Values
import 'package:skillcroma/values.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: NavBar(currentPage: .home),
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
                        SocialMedia(
                          socialMedia: socialMediaTypes.twitter,
                          icon: HugeIconsStroke.newTwitter,
                        ),
                        const SizedBox(height: 8),
                        SocialMedia(
                          socialMedia: socialMediaTypes.linkedIn,
                          icon: HugeIconsStroke.linkedin02,
                        ),
                        const SizedBox(height: 8),
                        SocialMedia(
                          socialMedia: socialMediaTypes.instagram,
                          icon: HugeIconsStroke.instagram,
                        ),
                        const SizedBox(height: 8),
                        SocialMedia(
                          socialMedia: socialMediaTypes.facebook,
                          icon: HugeIconsStroke.facebook02,
                        ),
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
                        FooterLink(label: "Programmes", page: .programmes),
                        FooterLink(label: "Products", page: .products),
                        FooterLink(label: "About", page: .about),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: size.width * 0.15,
                          child: Divider(
                            color: colorScheme.outline.withAlpha(125),
                          ),
                        ),
                        const SizedBox(height: 4),
                        FooterLink(
                          label: "X (formerly Twitter)",
                          socialMedia: .twitter,
                        ),
                        FooterLink(label: "LinkedIn", socialMedia: .linkedIn),
                        FooterLink(label: "Instagram", socialMedia: .instagram),
                        FooterLink(label: "Facebook", socialMedia: .facebook),
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
                      onPressed: () => navigatePage(.privacyPolicies),
                      child: Text("Privacy Policies"),
                    ),
                    const SizedBox(width: 48),
                    TextButton(
                      onPressed: () => navigatePage(.termsAndConditions),
                      child: Text("Terms & Conditions"),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () => navigatePage(.mail),
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
