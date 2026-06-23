import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/event.dart';

enum FormType { register, contact }

class EventActionForm extends StatefulWidget {
  final Event event;
  final FormType formType;
  final VoidCallback onSuccess;

  const EventActionForm({
    super.key,
    required this.event,
    required this.formType,
    required this.onSuccess,
  });

  @override
  State<EventActionForm> createState() => _EventActionFormState();
}

class _EventActionFormState extends State<EventActionForm> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.formType == FormType.register
                  ? 'Successfully registered for ${widget.event.title}!'
                  : 'Message sent! We will contact you soon.',
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        );
        
        widget.onSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User Input Fields
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Full Name',
              prefixIcon: Icon(Icons.person_outline_rounded),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.name,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              if (!RegExp(r"^[a-zA-Z\s]+$").hasMatch(value)) {
                return 'Only letters and spaces are allowed';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email Address',
              prefixIcon: Icon(Icons.email_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              prefixIcon: Icon(Icons.phone_outlined),
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Phone number must be at least 10 digits';
              }
              return null;
            },
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 24.0),
            child: Divider(),
          ),

          // Event Read-Only Details
          Text(
            'Event Details',
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          _buildReadOnlyField(context, 'Event ID', widget.event.id, Icons.tag_rounded),
          const SizedBox(height: 12),
          _buildReadOnlyField(context, 'Date', widget.event.date, Icons.calendar_today_rounded),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildReadOnlyField(context, 'Start Time', widget.event.startTime, Icons.access_time_rounded)),
              const SizedBox(width: 16),
              Expanded(child: _buildReadOnlyField(context, 'End Time', widget.event.endTime, Icons.access_time_filled_rounded)),
            ],
          ),
          const SizedBox(height: 12),
          _buildReadOnlyField(context, 'Location', widget.event.location, Icons.location_on_outlined),

          const SizedBox(height: 32),

          // Submit Button
          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: _isSubmitting ? null : _submitForm,
              child: _isSubmitting 
                  ? const SizedBox(
                      width: 24, 
                      height: 24, 
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                    )
                  : Text(widget.formType == FormType.register ? 'Submit Registration' : 'Send Message'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(BuildContext context, String label, String value, IconData icon) {
    return TextFormField(
      initialValue: value,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
      ),
    );
  }
}
