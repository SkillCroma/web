import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:skillcroma/values.dart';
import 'package:skillcroma/widgets/app_bar.dart';
import 'package:skillcroma/widgets/footer.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final ScrollController _scrollController = ScrollController();
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedSport = "Cricket";

  bool _isSubmitting = false;

  @override
  void dispose() {
    _scrollController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _scrollToFooter() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isSubmitting = true;
    });

    // Mock submission delay
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Thank you, ${_nameController.text}! Our scouts will contact you shortly regarding $_selectedSport."),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );

    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    bool isDesktop = size.width > 900;
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: NavBar(
        currentPage: PageName.contact,
        onContactTapped: _scrollToFooter,
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/common/About_Image_2.png',
              fit: BoxFit.cover,
            ),
          ),
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
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: Flex(
                      direction: isDesktop ? Axis.horizontal : Axis.vertical,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Column - Info
                        Expanded(
                          flex: isDesktop ? 5 : 0,
                          child: Padding(
                            padding: EdgeInsets.only(right: isDesktop ? 48 : 0, bottom: isDesktop ? 0 : 48),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Connect With Our Scouts",
                                  style: textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Are you an emerging athlete looking for a professional scout matchup or customized training? Send us a message, and our career advisors will get back to you.",
                                  style: textTheme.titleLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 32),
                                _buildContactInfoItem(
                                  context,
                                  Icons.email_outlined,
                                  "hello@skillcroma.com",
                                  "Get in touch via support email",
                                ),
                                const SizedBox(height: 16),
                                _buildContactInfoItem(
                                  context,
                                  Icons.phone_outlined,
                                  "+1 (800) 555-0199",
                                  "Mon-Fri, 9:00 AM - 6:00 PM EST",
                                ),
                                const SizedBox(height: 16),
                                _buildContactInfoItem(
                                  context,
                                  Icons.location_on_outlined,
                                  "120 Talent Circle, Suite 400",
                                  "New York, NY 10001",
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Right Column - Glassmorphic Form
                        Expanded(
                          flex: isDesktop ? 6 : 0,
                          child: Container(
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
                                  padding: const EdgeInsets.all(32),
                                  decoration: BoxDecoration(
                                    color: colorScheme.surface.withValues(alpha: 0.45),
                                    borderRadius: BorderRadius.circular(32),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.12),
                                      width: 1.0,
                                    ),
                                  ),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Send a Message",
                                          style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(height: 24),

                                        // Name Field
                                        TextFormField(
                                          controller: _nameController,
                                          decoration: InputDecoration(
                                            labelText: "Full Name",
                                            prefixIcon: const Icon(Icons.person_outline),
                                            filled: true,
                                            fillColor: colorScheme.surface.withValues(alpha: 0.1),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          validator: (value) => value == null || value.isEmpty ? "Please enter your name" : null,
                                        ),
                                        const SizedBox(height: 16),

                                        // Email Field
                                        TextFormField(
                                          controller: _emailController,
                                          keyboardType: TextInputType.emailAddress,
                                          decoration: InputDecoration(
                                            labelText: "Email Address",
                                            prefixIcon: const Icon(Icons.mail_outline),
                                            filled: true,
                                            fillColor: colorScheme.surface.withValues(alpha: 0.1),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          validator: (value) {
                                            if (value == null || value.isEmpty) return "Please enter your email";
                                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) return "Enter a valid email address";
                                            return null;
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        // Sport Selection
                                        DropdownButtonFormField<String>(
                                          initialValue: _selectedSport,
                                          decoration: InputDecoration(
                                            labelText: "Primary Sport Area",
                                            prefixIcon: const Icon(Icons.sports_soccer_outlined),
                                            filled: true,
                                            fillColor: colorScheme.surface.withValues(alpha: 0.1),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          items: const [
                                            DropdownMenuItem(value: "Cricket", child: Text("Cricket")),
                                            DropdownMenuItem(value: "Basketball", child: Text("Basketball")),
                                            DropdownMenuItem(value: "Chess", child: Text("Chess")),
                                            DropdownMenuItem(value: "Esports", child: Text("Esports")),
                                            DropdownMenuItem(value: "Football", child: Text("Football")),
                                            DropdownMenuItem(value: "Volleyball", child: Text("Volleyball")),
                                            DropdownMenuItem(value: "Karate", child: Text("Karate")),
                                            DropdownMenuItem(value: "Swimming", child: Text("Swimming")),
                                          ],
                                          onChanged: (val) {
                                            if (val != null) {
                                              setState(() {
                                                _selectedSport = val;
                                              });
                                            }
                                          },
                                        ),
                                        const SizedBox(height: 16),

                                        // Message Field
                                        TextFormField(
                                          controller: _messageController,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                            labelText: "Describe your goals...",
                                            prefixIcon: const Padding(
                                              padding: EdgeInsets.only(bottom: 56.0),
                                              child: Icon(Icons.chat_bubble_outline),
                                            ),
                                            filled: true,
                                            fillColor: colorScheme.surface.withValues(alpha: 0.1),
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                          ),
                                          validator: (value) => value == null || value.isEmpty ? "Please write your query details" : null,
                                        ),
                                        const SizedBox(height: 24),

                                        // Submit Button
                                        SizedBox(
                                          width: double.infinity,
                                          height: 56,
                                          child: FilledButton(
                                            onPressed: _isSubmitting ? null : _submitForm,
                                            style: FilledButton.styleFrom(
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                            ),
                                            child: _isSubmitting 
                                                ? const SizedBox(
                                                    height: 24,
                                                    width: 24,
                                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                                  )
                                                : const Text("Submit Query", style: TextStyle(fontWeight: FontWeight.bold)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
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

  Widget _buildContactInfoItem(BuildContext context, IconData icon, String primary, String secondary) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: colorScheme.primary, size: 24),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(primary, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 2),
            Text(secondary, style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }
}
