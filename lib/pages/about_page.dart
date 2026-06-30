import 'dart:ui';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:skillcroma/values.dart';
import 'package:skillcroma/widgets/app_bar.dart';
import 'package:skillcroma/widgets/footer.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = true;
  Map<String, dynamic>? _aboutData;
  bool _isBusinessActive = true;

  @override
  void initState() {
    super.initState();
    _loadAboutData();
  }

  Future<void> _loadAboutData() async {
    try {
      final String response = await rootBundle.loadString('assets/data/about_data.json');
      final Map<String, dynamic> data = json.decode(response);
      if (!mounted) return;
      setState(() {
        _aboutData = data;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading about data: $e");
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
    var size = MediaQuery.of(context).size;
    bool isDesktop = size.width > 900;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    final List<dynamic> paragraphs;
    if (_aboutData != null) {
      if (_aboutData!.containsKey('business') && _aboutData!.containsKey('sports')) {
        paragraphs = _isBusinessActive
            ? _aboutData!['business']['paragraphs'] as List<dynamic>
            : _aboutData!['sports']['paragraphs'] as List<dynamic>;
      } else {
        if (_isBusinessActive) {
          paragraphs = _aboutData!['paragraphs'] ?? [];
        } else {
          paragraphs = const [
            "SkillCroma is a premier sports event and talent management platform dedicated to identifying, nurturing, and promoting genuine talent. We believe in providing a structured pathway for aspiring athletes through rigorous performance analysis and expert guidance.",
            "Our mission is to create a robust ecosystem where athletes from various disciplines—cricket, basketball, chess, esports, football, and more—can showcase their skills and unlock professional opportunities."
          ];
        }
      }
    } else {
      paragraphs = [];
    }

    return Scaffold(
      appBar: NavBar(
        currentPage: PageName.about,
        onContactTapped: _scrollToFooter,
      ),
      body: _isLoading || _aboutData == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
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
                        vertical: 64,
                      ),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Page Heading
                              Text(
                                "About us",
                                style: textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Glassmorphic Content Card
                              Container(
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
                                          // Toggle Pill Bar
                                          Container(
                                            padding: const EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              color: colorScheme.surface.withValues(alpha: 0.1),
                                              borderRadius: BorderRadius.circular(24),
                                              border: Border.all(
                                                color: colorScheme.onSurface.withValues(alpha: 0.05),
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                _buildTabPill(context, "Sports", !_isBusinessActive, () {
                                                  setState(() => _isBusinessActive = false);
                                                }),
                                                const SizedBox(width: 4),
                                                _buildTabPill(context, "Business", _isBusinessActive, () {
                                                  setState(() => _isBusinessActive = true);
                                                }),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 32),

                                          // Dynamic Paragraphs
                                          ...paragraphs
                                              .map((p) => Padding(
                                                    padding: const EdgeInsets.only(bottom: 20.0),
                                                    child: Text(
                                                      p.toString(),
                                                      style: textTheme.titleMedium?.copyWith(
                                                        color: colorScheme.onSurface,
                                                        height: 1.6,
                                                      ),
                                                    ),
                                                  )),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 80),

                              // Management Team Section
                              Center(
                                child: Column(
                                  children: [
                                    Text(
                                      "Our Management Team",
                                      style: textTheme.headlineMedium?.copyWith(
                                        color: colorScheme.onSurface,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: 180,
                                      height: 2,
                                      color: colorScheme.primary.withValues(alpha: 0.5),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 48),

                              // Team Layout (3-2 wrap on desktop, wrapping wrap on mobile)
                              if (isDesktop) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildTeamMember(context, _aboutData!['team'][0]),
                                    const SizedBox(width: 64),
                                    _buildTeamMember(context, _aboutData!['team'][1]),
                                    const SizedBox(width: 64),
                                    _buildTeamMember(context, _aboutData!['team'][2]),
                                  ],
                                ),
                                const SizedBox(height: 48),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _buildTeamMember(context, _aboutData!['team'][3]),
                                    const SizedBox(width: 64),
                                    _buildTeamMember(context, _aboutData!['team'][4]),
                                  ],
                                ),
                              ] else ...[
                                Center(
                                  child: Wrap(
                                    spacing: 32,
                                    runSpacing: 32,
                                    alignment: WrapAlignment.center,
                                    children: (_aboutData!['team'] as List<dynamic>)
                                        .map((member) => _buildTeamMember(context, member))
                                        .toList(),
                                  ),
                                ),
                              ],
                            ],
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

  Widget _buildTabPill(BuildContext context, String label, bool isActive, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? colorScheme.onSurface : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: textTheme.labelLarge?.copyWith(
            color: isActive ? colorScheme.surface : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, Map<String, dynamic> member) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 180,
          height: 180,
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.onSurface.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          child: Icon(
            Icons.person_outline_rounded,
            size: 64,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          member['name'],
          style: textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          member['role'],
          style: textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
