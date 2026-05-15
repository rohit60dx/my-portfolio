// lib/widgets/about_section.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/profile_model.dart';
import '../utils/theme.dart';
import 'section_header.dart';

class AboutSection extends StatelessWidget {
  final ProfileModel profile;
  const AboutSection({super.key, required this.profile});

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
            tag: '01',
            title: 'About Me',
            subtitle: 'Get to know me better',
          ),
          const SizedBox(height: 60),
          isMobile ? _buildMobile(context) : _buildDesktop(context),
        ],
      ),
    );
  }

  Widget _buildDesktop(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _buildInfo()),
        const SizedBox(width: 60),
        Expanded(flex: 5, child: _buildDetails()),
      ],
    );
  }

  Widget _buildMobile(BuildContext context) {
    return Column(
      children: [_buildInfo(), const SizedBox(height: 40), _buildDetails()],
    );
  }

  Widget _buildInfo() {
    return FadeInLeft(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello! I\'m a Flutter Developer 👋',
            style: GoogleFonts.spaceGrotesk(
              color: AppTheme.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            profile.about,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 16,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 32),
          // Contact Info Cards
          _InfoCard(
            icon: Icons.phone_outlined,
            label: 'Phone',
            value: profile.phone,
            onTap: () => launchUrl(Uri.parse('tel:${profile.phone}')),
          ),
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.email_outlined,
            label: 'Email',
            value: profile.email,
            onTap: () => launchUrl(Uri.parse('mailto:${profile.email}')),
          ),
          const SizedBox(height: 12),
          _InfoCard(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: profile.location,
            onTap: null,
          ),
          const SizedBox(height: 32),
          // Social Links
          Row(
            children: [
              if (profile.githubUrl.isNotEmpty)
                _SocialBtn(
                  icon: FontAwesomeIcons.github,
                  url: profile.githubUrl,
                  color: Colors.white,
                ),
              const SizedBox(width: 12),
              if (profile.linkedinUrl.isNotEmpty)
                _SocialBtn(
                  icon: FontAwesomeIcons.linkedin,
                  url: profile.linkedinUrl,
                  color: const Color(0xFF0A66C2),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return FadeInRight(
      child: Column(
        children: [
          // Stats grid
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.5,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _StatCard(
                value: '${profile.yearsOfExperience}+',
                label: 'Years Experience',
                icon: Icons.work_outline,
                gradient: AppGradients.primaryGradient,
              ),
              _StatCard(
                value: '${profile.projectsCompleted}+',
                label: 'Projects Done',
                icon: Icons.folder_outlined,
                gradient: AppGradients.accentGradient,
              ),
              _StatCard(
                value: '${profile.appsPublished}+',
                label: 'Apps Published',
                icon: Icons.phone_android,
                gradient: AppGradients.primaryGradient,
              ),
              _StatCard(
                value: '⭐ 4.8',
                label: 'Avg App Rating',
                icon: Icons.star_outline,
                gradient: AppGradients.accentGradient,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final VoidCallback? onTap;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppTheme.primary, size: 20),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    color: AppTheme.textSecondary,
                    fontSize: 12,
                  ),
                ),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    color: AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SocialBtn extends StatelessWidget {
  final IconData icon;
  final String url;
  final Color color;

  const _SocialBtn({
    required this.icon,
    required this.url,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppTheme.border),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final LinearGradient gradient;

  const _StatCard({
    required this.value,
    required this.label,
    required this.icon,
    required this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradient.colors.first.withOpacity(0.1),
            gradient.colors.last.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: gradient.colors.first.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: gradient.colors.first, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShaderMask(
                shaderCallback: (b) => gradient.createShader(b),
                child: Text(
                  value,
                  style: GoogleFonts.orbitron(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.inter(
                  color: AppTheme.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
