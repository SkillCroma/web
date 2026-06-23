// Packages
import 'package:flutter/material.dart';

// Widgets
import 'package:skillcroma/widgets/footer_link.dart';

// Values
import 'package:skillcroma/values.dart';

// Functions
import 'package:skillcroma/functions.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;
    var textTheme = Theme.of(context).textTheme;
    var size = MediaQuery.of(context).size;
    bool isDesktop = size.width > 800;

    return Container(
      width: size.width,
      color: colorScheme.surfaceContainerHighest,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: isDesktop ? 32 : 24,
      ),
      child: Column(
        children: [
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "SKILLCROMA",
                            style: textTheme.displayMedium?.copyWith(
                              fontWeight: FontWeight.w900,
                              letterSpacing: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Identifying genuine talent through professional performance analysis.",
                            style: textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Company",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FooterLink(label: "Programmes", page: PageName.programmes),
                          const SizedBox(height: 8),
                          FooterLink(label: "Products", page: PageName.products),
                          const SizedBox(height: 8),
                          FooterLink(label: "About", page: PageName.about),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Socials",
                            style: textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 24),
                          FooterLink(label: "X (Twitter)", socialMedia: SocialMediaTypes.twitter),
                          const SizedBox(height: 8),
                          FooterLink(label: "LinkedIn", socialMedia: SocialMediaTypes.linkedIn),
                          const SizedBox(height: 8),
                          FooterLink(label: "Instagram", socialMedia: SocialMediaTypes.instagram),
                          const SizedBox(height: 8),
                          FooterLink(label: "Facebook", socialMedia: SocialMediaTypes.facebook),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "SKILLCROMA",
                          style: textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Identifying genuine talent through professional performance analysis.",
                          style: textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Company",
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FooterLink(label: "Programmes", page: PageName.programmes),
                        const SizedBox(height: 8),
                        FooterLink(label: "Products", page: PageName.products),
                        const SizedBox(height: 8),
                        FooterLink(label: "About", page: PageName.about),
                      ],
                    ),
                    const SizedBox(height: 48),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Socials",
                          style: textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        FooterLink(label: "X (Twitter)", socialMedia: SocialMediaTypes.twitter),
                        const SizedBox(height: 8),
                        FooterLink(label: "LinkedIn", socialMedia: SocialMediaTypes.linkedIn),
                        const SizedBox(height: 8),
                        FooterLink(label: "Instagram", socialMedia: SocialMediaTypes.instagram),
                        const SizedBox(height: 8),
                        FooterLink(label: "Facebook", socialMedia: SocialMediaTypes.facebook),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 64),
          Divider(color: colorScheme.outline.withAlpha(125)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 24,
            runSpacing: 16,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                "© 2026 SkillCroma. Design by Santhosh Sivakumar",
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  TextButton(
                    onPressed: () => navigatePage(context, PageName.privacyPolicies),
                    child: Text("Privacy Policy"),
                  ),
                  TextButton(
                    onPressed: () => navigatePage(context, PageName.termsAndConditions),
                    child: Text("Terms & Conditions"),
                  ),
                  TextButton(
                    onPressed: () => navigatePage(context, PageName.mail),
                    child: Text("hello@skillcroma.com"),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
