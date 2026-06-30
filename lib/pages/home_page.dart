// Packages
import 'dart:convert';
import 'package:flutter/services.dart';
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
import 'package:skillcroma/widgets/reusable_dialog.dart';

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
  bool _isLoading = true;
  Map<String, dynamic>? _homeData;

  @override
  void initState() {
    super.initState();
    _loadHomeData();
  }

  Future<void> _loadHomeData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/home_data.json');
      final Map<String, dynamic> data = json.decode(response);
      if (!mounted) return;
      setState(() {
        _homeData = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading home data: $e");
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

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
      body: _isLoading || _homeData == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              controller: _scrollController,
              children: [
                ClipRect(
                  child: Stack(
                    children: [
                      AnimatedBuilder(
                        animation: _scrollController,
                        builder: (context, child) {
                          double offset = _scrollController.hasClients ? _scrollController.offset : 0;
                          return Transform.translate(
                            offset: Offset(0, offset * 0.5),
                            child: child,
                          );
                        },
                        child: Image.asset(
                          'assets/common/carousel_image_1.png',
                          width: size.width,
                          fit: BoxFit.cover,
                          height: size.height - kToolbarHeight,
                        ),
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
                          CarouselQuoteText(text: _homeData!['hero']['quotes'][0]),
                          CarouselQuoteText(text: _homeData!['hero']['quotes'][1]),
                          CarouselQuoteText(text: _homeData!['hero']['quotes'][2]),
                          const SizedBox(height: 40),
                          Wrap(
                            spacing: 24,
                            runSpacing: 24,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ReusableDialog(
                                      title: 'Start Free Trial',
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text('Unlock full athletic analysis and custom coaching support today. Sign up for your 7-day free trial!'),
                                          const SizedBox(height: 24),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Full Name',
                                              prefixIcon: const Icon(Icons.person_outline),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              labelText: 'Email Address',
                                              prefixIcon: const Icon(Icons.mail_outline),
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.of(context).pop(),
                                          child: const Text('Cancel'),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: const Text('Registration successful! Check your email to start your trial.'),
                                                backgroundColor: Theme.of(context).colorScheme.primary,
                                                behavior: SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          child: const Text('Register'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.onSurfaceVariant,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: Text(
                                    _homeData!['hero']['buttonText'],
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
                                  CarouselText(text: _homeData!['hero']['subtext'][0]),
                                  CarouselText(
                                    text: _homeData!['hero']['subtext'][1],
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
                ),
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(isDesktop ? 80 : 24),
                  color: colorScheme.surfaceContainerLowest,
                  child: Column(
                    children: [
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _homeData!['about']['title'],
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: colorScheme.onSurface,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    decorationColor: colorScheme.onSurface,
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CarouselQuoteText(
                                        text: _homeData!['about']['quotes'][0],
                                        textAlign: TextAlign.end,
                                      ),
                                      CarouselQuoteText(
                                        text: _homeData!['about']['quotes'][1],
                                        textAlign: TextAlign.end,
                                      ),
                                      CarouselQuoteText(
                                        text: _homeData!['about']['quotes'][2],
                                        textAlign: TextAlign.end,
                                      ),
                                      CarouselQuoteText(
                                        text: _homeData!['about']['quotes'][3],
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 80),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
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
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _homeData!['about']['title'],
                                  style: textTheme.headlineSmall?.copyWith(
                                    color: colorScheme.onSurface,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    decorationColor: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CarouselQuoteText(text: _homeData!['about']['quotes'][0]),
                                    CarouselQuoteText(text: _homeData!['about']['quotes'][1]),
                                    CarouselQuoteText(text: _homeData!['about']['quotes'][2]),
                                    CarouselQuoteText(text: _homeData!['about']['quotes'][3]),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SocialMedia(
                                      socialMedia: SocialMediaTypes.twitter,
                                      icon: HugeIconsStroke.newTwitter,
                                    ),
                                    const SizedBox(width: 8),
                                    SocialMedia(
                                      socialMedia: SocialMediaTypes.linkedIn,
                                      icon: HugeIconsStroke.linkedin02,
                                    ),
                                    const SizedBox(width: 8),
                                    SocialMedia(
                                      socialMedia: SocialMediaTypes.instagram,
                                      icon: HugeIconsStroke.instagram,
                                    ),
                                    const SizedBox(width: 8),
                                    SocialMedia(
                                      socialMedia: SocialMediaTypes.facebook,
                                      icon: HugeIconsStroke.facebook02,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                      const SizedBox(height: 60),
                      isDesktop
                          ? Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: size.width * 0.45,
                                  child: Text(
                                    _homeData!['about']['description'],
                                    style: textTheme.bodyLarge?.copyWith(
                                      height: 1.6,
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    AboutImages(image: "assets/common/About_Image_1.png"),
                                    const SizedBox(width: 16),
                                    AboutImages(image: "assets/common/About_Image_2.png"),
                                  ],
                                ),
                              ],
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  _homeData!['about']['description'],
                                  style: textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 24),
                                Center(
                                  child: Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: [
                                      AboutImages(image: "assets/common/About_Image_1.png"),
                                      AboutImages(image: "assets/common/About_Image_2.png"),
                                    ],
                                  ),
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
                              _homeData!['stats']['title'],
                              style: textTheme.displaySmall?.copyWith(
                                fontWeight: .bold,
                              ),
                            ),
                            const SizedBox(height: 24),
                            Text(
                              _homeData!['stats']['subtitle'],
                              style: textTheme.titleLarge,
                            ),
                            const SizedBox(height: 40),
                            Wrap(
                              spacing: 24,
                              runSpacing: 24,
                              children: [
                                NumbersContainer(
                                  title: _homeData!['stats']['items'][0]['title'],
                                  subtitle: _homeData!['stats']['items'][0]['subtitle'],
                                  text: _homeData!['stats']['items'][0]['text'],
                                ),
                                NumbersContainer(
                                  title: _homeData!['stats']['items'][1]['title'],
                                  subtitle: _homeData!['stats']['items'][1]['subtitle'],
                                  text: _homeData!['stats']['items'][1]['text'],
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
