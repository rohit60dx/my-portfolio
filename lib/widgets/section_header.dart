// lib/widgets/section_header.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart';

class SectionHeader extends StatelessWidget {
  final String tag;
  final String title;
  final String subtitle;

  const SectionHeader({
    super.key,
    required this.tag,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tag
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
          ),
          child: Text(
            '// $tag',
            style: GoogleFonts.orbitron(
              color: AppTheme.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 16),
        ShaderMask(
          shaderCallback: (b) => AppGradients.primaryGradient.createShader(b),
          child: Text(
            title,
            style: GoogleFonts.orbitron(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 16),
        ),
      ],
    );
  }
}
