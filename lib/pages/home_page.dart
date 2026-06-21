// Packages
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
        ],
      ),
    );
  }
}

/* Widgets used in this Page */

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
  const CarouselQuoteText({super.key, required this.text});
  final String text;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    return Text(
      text,
      style: textTheme.displayLarge?.copyWith(
        fontWeight: .w600,
        color: colorScheme.onSurface,
      ),
    );
  }
}
