import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:skillcroma/values.dart';
import 'package:skillcroma/widgets/app_bar.dart';
import 'package:skillcroma/widgets/footer.dart';

class LegalPage extends StatefulWidget {
  final bool isPrivacyPolicy;

  const LegalPage({super.key, required this.isPrivacyPolicy});

  @override
  State<LegalPage> createState() => _LegalPageState();
}

class _LegalPageState extends State<LegalPage> {
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
    var size = MediaQuery.of(context).size;
    bool isDesktop = size.width > 800;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    final String title = widget.isPrivacyPolicy ? "Privacy Policy" : "Terms & Conditions";
    final String lastUpdated = "Last Updated: June 30, 2026";

    return Scaffold(
      appBar: NavBar(
        currentPage: widget.isPrivacyPolicy ? PageName.privacyPolicies : PageName.termsAndConditions,
        onContactTapped: _scrollToFooter,
      ),
      body: Stack(
        children: [
          // Background Image for Glassmorphism
          Positioned.fill(
            child: Image.asset(
              'assets/common/About_Image_1.png',
              fit: BoxFit.cover,
            ),
          ),
          // Scrollable Content
          ListView(
            controller: _scrollController,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 80 : 24,
                  vertical: 80,
                ),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 900),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.35),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                        child: Container(
                          padding: EdgeInsets.all(isDesktop ? 48 : 24),
                          decoration: BoxDecoration(
                            color: colorScheme.surface.withValues(alpha: 0.45),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                lastUpdated,
                                style: textTheme.bodyMedium?.copyWith(
                                  color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
                                ),
                              ),
                              const Divider(height: 48),
                              if (widget.isPrivacyPolicy) ..._buildPrivacyPolicyContent(textTheme, colorScheme)
                              else ..._buildTermsAndConditionsContent(textTheme, colorScheme),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const Footer(),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPrivacyPolicyContent(TextTheme textTheme, ColorScheme colorScheme) {
    return [
      _sectionHeader(textTheme, colorScheme, "1. Information We Collect"),
      _sectionBody(textTheme, colorScheme, 
        "SkillCroma collects performance indicators, physical profiles, and training stats of registered athletes to help map career growth options. Personal identification information (e.g., name, contact details, sports affiliation) is strictly secured and only shared with authorized partners, scouts, and managers with your direct consent."),
      _sectionHeader(textTheme, colorScheme, "2. How We Use Data"),
      _sectionBody(textTheme, colorScheme, 
        "Your data helps analyze athletic development, track leaderboard rankings, customize sport-specific programmes, and deliver premium recommendations. We utilize performance history purely to match athletic skills with real-world academy opportunities."),
      _sectionHeader(textTheme, colorScheme, "3. Security and Storage"),
      _sectionBody(textTheme, colorScheme, 
        "All data processed on SkillCroma-Web is stored using industry-standard encryptions. We monitor vulnerability parameters consistently to safeguard training progress logs and purchase histories from unauthorized breaches."),
    ];
  }

  List<Widget> _buildTermsAndConditionsContent(TextTheme textTheme, ColorScheme colorScheme) {
    return [
      _sectionHeader(textTheme, colorScheme, "1. Acceptable Use Policy"),
      _sectionBody(textTheme, colorScheme, 
        "By accessing SkillCroma, you agree to submit genuine athletic telemetry and user details. Attempting to spoof performance records, manipulate leaderboard metrics, or scrape athlete profiles is strictly prohibited and leads to immediate termination."),
      _sectionHeader(textTheme, colorScheme, "2. Payments and Refunds"),
      _sectionBody(textTheme, colorScheme, 
        "Subscribing to training plans, scout packages, or purchasing sports gear on our Products platform involves processing third-party gateways. Refund requests for programmes are evaluated based on course progress and initial service terms."),
      _sectionHeader(textTheme, colorScheme, "3. Limitation of Liability"),
      _sectionBody(textTheme, colorScheme, 
        "SkillCroma facilitates sports analytics and coaching coordination. We are not responsible for physical injuries occurred during self-guided sessions or external academy trials. Users participate at their own athletic risk."),
    ];
  }

  Widget _sectionHeader(TextTheme textTheme, ColorScheme colorScheme, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(
        text,
        style: textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }

  Widget _sectionBody(TextTheme textTheme, ColorScheme colorScheme, String text) {
    return Text(
      text,
      style: textTheme.bodyLarge?.copyWith(
        color: colorScheme.onSurfaceVariant,
        height: 1.6,
      ),
    );
  }
}
