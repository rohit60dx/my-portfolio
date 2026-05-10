// lib/widgets/navbar.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/profile_model.dart';
import '../utils/theme.dart';

class PortfolioNavbar extends StatelessWidget {
  final VoidCallback onHeroTap;
  final VoidCallback onAboutTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onAppsTap;
  final VoidCallback onContactTap;
  final ProfileModel profile;

  const PortfolioNavbar({
    super.key,
    required this.onHeroTap,
    required this.onAboutTap,
    required this.onProjectsTap,
    required this.onAppsTap,
    required this.onContactTap,
    required this.profile,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: AppTheme.bg.withOpacity(0.9),
        border: const Border(
          bottom: BorderSide(color: AppTheme.border, width: 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Row(
          children: [
            // Logo / Name
            GestureDetector(
              onTap: onHeroTap,
              child: ShaderMask(
                shaderCallback: (bounds) =>
                    AppGradients.primaryGradient.createShader(bounds),
                child: Text(
                  '< ${profile.name.split(' ').first} />',
                  style: GoogleFonts.orbitron(
                    fontSize: isMobile ? 16 : 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            if (!isMobile) ...[
              _NavItem('Home', onHeroTap),
              _NavItem('About', onAboutTap),
              _NavItem('Projects', onProjectsTap),
              _NavItem('Apps', onAppsTap),
              _NavItem('Contact', onContactTap),
            ] else
              _MobileMenu(
                onAbout: onAboutTap,
                onProjects: onProjectsTap,
                onApps: onAppsTap,
                onContact: onContactTap,
              ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _NavItem(this.label, this.onTap);

  @override
  State<_NavItem> createState() => __NavItemState();
}

class __NavItemState extends State<_NavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.inter(
                  color: _hovered ? AppTheme.primary : AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 2,
                width: _hovered ? 40 : 0,
                decoration: BoxDecoration(
                  gradient: _hovered ? AppGradients.primaryGradient : null,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MobileMenu extends StatelessWidget {
  final VoidCallback onAbout;
  final VoidCallback onProjects;
  final VoidCallback onApps;
  final VoidCallback onContact;

  const _MobileMenu({
    required this.onAbout,
    required this.onProjects,
    required this.onApps,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.menu, color: AppTheme.textPrimary),
      color: AppTheme.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppTheme.border),
      ),
      itemBuilder: (_) => [
        _menuItem('About', Icons.person_outline),
        _menuItem('Projects', Icons.code_outlined),
        _menuItem('Apps', Icons.apps_outlined),
        _menuItem('Contact', Icons.mail_outline),
      ],
      onSelected: (val) {
        if (val == 'About') onAbout();
        if (val == 'Projects') onProjects();
        if (val == 'Apps') onApps();
        if (val == 'Contact') onContact();
      },
    );
  }

  PopupMenuItem<String> _menuItem(String label, IconData icon) {
    return PopupMenuItem(
      value: label,
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primary, size: 18),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(color: AppTheme.textPrimary)),
        ],
      ),
    );
  }
}
