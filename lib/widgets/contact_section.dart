// lib/widgets/contact_section.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/profile_model.dart';
import '../services/firebase_service.dart';
import '../utils/theme.dart';
import 'section_header.dart';

class ContactSection extends StatefulWidget {
  final ProfileModel profile;
  const ContactSection({super.key, required this.profile});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sending = false;
  String? _status;

  Future<void> _submit() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _messageController.text.isEmpty) {
      setState(() => _status = 'Please fill all fields');
      return;
    }

    setState(() {
      _sending = true;
      _status = null;
    });

    final success = await FirebaseService.submitContact(
      name: _nameController.text,
      email: _emailController.text,
      message: _messageController.text,
    );

    setState(() {
      _sending = false;
      _status = success
          ? '✅ Message sent successfully!'
          : '❌ Failed to send. Try again.';
    });

    if (success) {
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 80,
      ),
      child: Column(
        children: [
          const SectionHeader(
            tag: '05',
            title: 'Contact Me',
            subtitle: 'Let\'s work together',
          ),
          const SizedBox(height: 60),
          Container(
            constraints: const BoxConstraints(maxWidth: 700),
            child: FadeInUp(
              child: Container(
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppTheme.bgCard,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Direct contact info
                    Row(
                      children: [
                        _ContactInfo(
                          icon: Icons.email_outlined,
                          label: widget.profile.email,
                          color: AppTheme.primary,
                        ),
                        const SizedBox(width: 24),
                        _ContactInfo(
                          icon: Icons.phone_outlined,
                          label: widget.profile.phone,
                          color: AppTheme.accent,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Divider(color: AppTheme.border),
                    const SizedBox(height: 32),
                    Text(
                      'Send a Message',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textPrimary,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 24),
                    isMobile
                        ? Column(
                            children: [
                              _InputField(
                                controller: _nameController,
                                label: 'Your Name',
                                icon: Icons.person_outline,
                              ),
                              const SizedBox(height: 16),
                              _InputField(
                                controller: _emailController,
                                label: 'Your Email',
                                icon: Icons.email_outlined,
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: _InputField(
                                  controller: _nameController,
                                  label: 'Your Name',
                                  icon: Icons.person_outline,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _InputField(
                                  controller: _emailController,
                                  label: 'Your Email',
                                  icon: Icons.email_outlined,
                                ),
                              ),
                            ],
                          ),
                    const SizedBox(height: 16),
                    _InputField(
                      controller: _messageController,
                      label: 'Your Message',
                      icon: Icons.message_outlined,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 24),
                    if (_status != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: _status!.startsWith('✅')
                              ? AppTheme.accent.withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _status!.startsWith('✅')
                                ? AppTheme.accent.withOpacity(0.3)
                                : Colors.red.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          _status!,
                          style: GoogleFonts.inter(
                            color: _status!.startsWith('✅')
                                ? AppTheme.accent
                                : Colors.redAccent,
                          ),
                        ),
                      ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _sending ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.all(
                            Colors.transparent,
                          ),
                          overlayColor: MaterialStateProperty.all(
                            AppTheme.primary.withOpacity(0.1),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: AppGradients.primaryGradient,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            child: _sending
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    'Send Message 🚀',
                                    style: GoogleFonts.inter(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
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
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }
}

class _ContactInfo extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _ContactInfo({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              label,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final int maxLines;

  const _InputField({
    required this.controller,
    required this.label,
    required this.icon,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.inter(color: AppTheme.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
        prefixIcon: Icon(icon, color: AppTheme.primary, size: 20),
        filled: true,
        fillColor: AppTheme.bgCard2,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
        ),
      ),
    );
  }
}
