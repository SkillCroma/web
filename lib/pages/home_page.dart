// Packages
import 'package:hugeicons_pro/hugeicons.dart';
import 'package:flutter/material.dart';

// Widgets
import 'package:skillcroma/widgets/carousel_quote_text.dart';
import 'package:skillcroma/widgets/numbers_container.dart';
import 'package:skillcroma/widgets/carousel_text.dart';
import 'package:skillcroma/widgets/social_media.dart';
import 'package:skillcroma/widgets/about_images.dart';
import 'package:skillcroma/widgets/app_bar.dart';
import 'package:skillcroma/widgets/footer.dart';

// Functions

// Values
import 'package:skillcroma/values.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToFooter() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    bool isDesktop = size.width > 800;

    return Scaffold(
      appBar: NavBar(
        currentPage: PageName.home,
        onContactTapped: _scrollToFooter,
      ),
      body: ListView(
        controller: _scrollController,
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
                padding: EdgeInsets.all(isDesktop ? 80 : 24),
                height: size.height - kToolbarHeight,
                width: size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: .bottomLeft,
                    end: .topCenter,
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
                    Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      crossAxisAlignment: WrapCrossAlignment.center,
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
            padding: EdgeInsets.all(isDesktop ? 80 : 24),
            color: colorScheme.surfaceContainerLowest,
            child: Column(
              children: [
                Wrap(
                  spacing: 40,
                  runSpacing: 40,
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.start,
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
                    Column(
                      crossAxisAlignment: isDesktop ? .end : .start,
                      mainAxisSize: .min,
                      children: [
                        SizedBox(
                          width: isDesktop ? size.width * 0.35 : null,
                          child: CarouselQuoteText(
                            text: "SPEED IS MORE",
                            textAlign: isDesktop ? .end : .start,
                          ),
                        ),
                        SizedBox(
                          width: isDesktop ? size.width * 0.35 : null,
                          child: CarouselQuoteText(
                            text: "THAN MOTION; IT",
                            textAlign: isDesktop ? .end : .start,
                          ),
                        ),
                        CarouselQuoteText(text: "IS INTELLIGENCE IN"),
                        CarouselQuoteText(text: "ACTION"),
                      ],
                    ),
                    Column(
                      mainAxisSize: .min,
                      children: [
                        SocialMedia(
                          socialMedia: SocialMediaTypes.twitter,
                          icon: HugeIconsStroke.newTwitter,
                        ),
                        const SizedBox(height: 8),
                        SocialMedia(
                          socialMedia: SocialMediaTypes.linkedIn,
                          icon: HugeIconsStroke.linkedin02,
                        ),
                        const SizedBox(height: 8),
                        SocialMedia(
                          socialMedia: SocialMediaTypes.instagram,
                          icon: HugeIconsStroke.instagram,
                        ),
                        const SizedBox(height: 8),
                        SocialMedia(
                          socialMedia: SocialMediaTypes.facebook,
                          icon: HugeIconsStroke.facebook02,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                Wrap(
                  spacing: 40,
                  runSpacing: 40,
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: isDesktop ? size.width * 0.35 : size.width,
                      child: Text(
                        "At SkillCroma, we believe every young young athlete deserves the right opportunity to shine.Many talented players have passion and potential but lack proper guidance and exposure.Our mission is to identify genuine talent through professional performance analysis and skill evaluation.",
                        style: textTheme.bodyLarge,
                      ),
                    ),
                    Wrap(
                      spacing: 16,
                      runSpacing: 16,
                      alignment: WrapAlignment.center,
                      children: [
                        AboutImages(image: "assets/common/About_Image_1.png"),
                        AboutImages(image: "assets/common/About_Image_2.png"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: size.width,
            padding: EdgeInsets.all(isDesktop ? 80 : 24),
            color: colorScheme.surface,
            child: Wrap(
              spacing: 50,
              runSpacing: 50,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                SizedBox(
                  width: isDesktop ? size.width * 0.45 : size.width,
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
                      const SizedBox(height: 40),
                      Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: [
                          NumbersContainer(
                            title: "20 +",
                            subtitle: "Training Programmes",
                            text:
                                "Professional or Amateur Athelets trust our platform",
                          ),
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
                ClipRRect(
                  borderRadius: .circular(48),
                  child: Image.asset(
                    "assets/common/By_The_Numbers.png",
                    fit: .cover,
                    width: isDesktop ? size.width * 0.4 : size.width,
                  ),
                ),
              ],
            ),
          ),
          const Footer(),
        ],
      ),
    );
  }
}
