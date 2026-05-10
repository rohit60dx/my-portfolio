// lib/widgets/hero_section.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/profile_model.dart';
import '../utils/theme.dart';
import 'dart:math' as math;

class HeroSection extends StatefulWidget {
  final ProfileModel profile;
  const HeroSection({super.key, required this.profile});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _floatController;
  late AnimationController _glowController;

  int _titleIndex = 0;
  final List<String> _titles = [
    'Flutter Developer',
    'Mobile App Expert',
    'Firebase Specialist',
    'Cross-Platform Dev',
  ];

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // Cycle through titles
    Future.delayed(const Duration(seconds: 2), _cycleTitle);
  }

  void _cycleTitle() {
    if (!mounted) return;
    setState(() => _titleIndex = (_titleIndex + 1) % _titles.length);
    Future.delayed(const Duration(seconds: 3), _cycleTitle);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;

    return Container(
      width: double.infinity,
      height: isMobile ? null : size.height,
      constraints: BoxConstraints(minHeight: isMobile ? 500 : size.height),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: isMobile ? 60 : 0,
      ),
      child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(size),
    );
  }

  Widget _buildDesktopLayout(Size size) {
    return Row(
      children: [
        Expanded(flex: 6, child: _buildTextContent()),
        Expanded(flex: 4, child: _build3DVisual()),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      children: [
        _build3DVisual(),
        const SizedBox(height: 32),
        _buildTextContent(),
      ],
    );
  }

  Widget _buildTextContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Greeting
        FadeInDown(
          duration: const Duration(milliseconds: 600),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(50),
              color: AppTheme.primary.withOpacity(0.08),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accent.withOpacity(0.5),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Available for Work',
                  style: GoogleFonts.inter(
                    color: AppTheme.accent,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Name
        FadeInDown(
          delay: const Duration(milliseconds: 200),
          duration: const Duration(milliseconds: 600),
          child: ShaderMask(
            shaderCallback: (bounds) =>
                AppGradients.primaryGradient.createShader(bounds),
            child: Text(
              widget.profile.name,
              style: GoogleFonts.orbitron(
                fontSize: MediaQuery.of(context).size.width < 768 ? 32 : 52,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                height: 1.1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Animated title
        FadeInDown(
          delay: const Duration(milliseconds: 400),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 500),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0, 0.3),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            ),
            child: Text(
              _titles[_titleIndex],
              key: ValueKey(_titleIndex),
              style: GoogleFonts.spaceGrotesk(
                fontSize: MediaQuery.of(context).size.width < 768 ? 18 : 26,
                fontWeight: FontWeight.w600,
                color: AppTheme.primary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Description
        FadeInDown(
          delay: const Duration(milliseconds: 600),
          child: Text(
            widget.profile.about,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 16,
              height: 1.7,
            ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 40),

        // Stats row
        FadeInDown(
          delay: const Duration(milliseconds: 700),
          child: Row(
            children: [
              _StatItem(
                value: '${widget.profile.yearsOfExperience}+',
                label: 'Years Exp',
              ),
              _divider(),
              _StatItem(
                value: '${widget.profile.projectsCompleted}+',
                label: 'Projects',
              ),
              _divider(),
              _StatItem(
                value: '${widget.profile.appsPublished}+',
                label: 'Published Apps',
              ),
            ],
          ),
        ),
        // const SizedBox(height: 40),

        // CTA Buttons
        FadeInUp(
          delay: const Duration(milliseconds: 800),
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              // _GlowButton(
              //   label: 'View Projects',
              //   isPrimary: true,
              //   onTap: () {},
              // ),
              // _OutlineButton(
              //   label: 'Download CV',
              //   onTap: () async {
              //     if (widget.profile.resumeUrl.isNotEmpty) {
              //       await launchUrl(Uri.parse(widget.profile.resumeUrl));
              //     }
              //   },
              // ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(
    height: 30,
    width: 1,
    margin: const EdgeInsets.symmetric(horizontal: 20),
    color: AppTheme.border,
  );

  Widget _build3DVisual() {
    return AnimatedBuilder(
      animation: _floatController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatController.value * 15 - 7.5),
          child: child,
        );
      },
      child: Center(
        child: AnimatedBuilder(
          animation: _rotateController,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer rotating ring
                Transform.rotate(
                  angle: _rotateController.value * 2 * math.pi,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.primary.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: CustomPaint(
                      painter: _OrbitPainter(AppTheme.primary),
                    ),
                  ),
                ),
                // Inner rotating ring
                Transform.rotate(
                  angle: -_rotateController.value * 2 * math.pi * 1.5,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.secondary.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: CustomPaint(
                      painter: _OrbitPainter(AppTheme.secondary),
                    ),
                  ),
                ),
                // Profile image or Flutter logo
                AnimatedBuilder(
                  animation: _glowController,
                  builder: (context, child) {
                    return Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const RadialGradient(
                          colors: [Color(0xFF1A3A5C), Color(0xFF050B15)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primary.withOpacity(
                              0.3 + _glowController.value * 0.3,
                            ),
                            blurRadius: 30 + _glowController.value * 20,
                            spreadRadius: 5,
                          ),
                        ],
                        border: Border.all(
                          color: AppTheme.primary.withOpacity(0.5),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: widget.profile.profileImageUrl.isNotEmpty
                            ? Image.network(
                                widget.profile.profileImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => _flutterLogo(),
                              )
                            : _flutterLogo(),
                      ),
                    );
                  },
                ),
                // Tech icons on orbit
                ..._buildOrbitIcons(),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _buildOrbitIcons() {
    final icons = ['F', 'D', '🔥', 'G'];
    final colors = [
      const Color(0xFF54C5F8),
      const Color(0xFF00B4D8),
      const Color(0xFFFF6B35),
      Colors.white,
    ];

    return List.generate(4, (i) {
      final angle = _rotateController.value * 2 * math.pi + (i * math.pi / 2);
      const radius = 135.0;
      return Positioned(
        left: 140 + radius * math.cos(angle) - 18,
        top: 140 + radius * math.sin(angle) - 18,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            shape: BoxShape.circle,
            border: Border.all(color: colors[i].withOpacity(0.5), width: 1),
          ),
          child: Center(
            child: Text(
              icons[i],
              style: TextStyle(
                color: colors[i],
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _flutterLogo() {
    return Container(
      color: const Color(0xFF042B59),
      child: const Center(
        child: Text(
          'F',
          style: TextStyle(
            color: Color(0xFF54C5F8),
            fontSize: 60,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (b) => AppGradients.primaryGradient.createShader(b),
          child: Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class _GlowButton extends StatefulWidget {
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;
  const _GlowButton({
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  State<_GlowButton> createState() => __GlowButtonState();
}

class __GlowButtonState extends State<_GlowButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: AppGradients.primaryGradient,
            borderRadius: BorderRadius.circular(50),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _OutlineButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  const _OutlineButton({required this.label, required this.onTap});

  @override
  State<_OutlineButton> createState() => __OutlineButtonState();
}

class __OutlineButtonState extends State<_OutlineButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: _hovered ? AppTheme.primary : AppTheme.border,
              width: 1.5,
            ),
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.inter(
              color: _hovered ? AppTheme.primary : AppTheme.textSecondary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _OrbitPainter extends CustomPainter {
  final Color color;
  _OrbitPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Dot at top of circle
    canvas.drawCircle(Offset(size.width / 2, 4), 4, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
