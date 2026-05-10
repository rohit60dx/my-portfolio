// lib/widgets/footer_widget.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/profile_model.dart';
import '../utils/theme.dart';

class FooterWidget extends StatelessWidget {
  final ProfileModel profile;
  const FooterWidget({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      child: Column(
        children: [
          ShaderMask(
            shaderCallback: (b) => AppGradients.primaryGradient.createShader(b),
            child: Text(
              '< ${profile.name} />',
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Flutter Developer • Building cross-platform experiences',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            '© ${DateTime.now().year} ${profile.name}. Built with Flutter 💙',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary.withOpacity(0.6),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
