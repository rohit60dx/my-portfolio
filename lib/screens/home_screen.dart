// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:rohit_portfolio/models/app_model.dart';
import 'package:rohit_portfolio/models/profile_model.dart';
import 'package:rohit_portfolio/services/firebase_service.dart';
import 'package:rohit_portfolio/utils/theme.dart';
import 'package:rohit_portfolio/widgets/about_section.dart';
import 'package:rohit_portfolio/widgets/apps_section.dart';
import 'package:rohit_portfolio/widgets/contact_section.dart';
import 'package:rohit_portfolio/widgets/footer_widget.dart';
import 'package:rohit_portfolio/widgets/hero_section.dart';
import 'package:rohit_portfolio/widgets/navbar.dart';
import 'package:rohit_portfolio/widgets/projects_section.dart';
import 'package:rohit_portfolio/widgets/skills_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  // Section keys for navigation
  final GlobalKey heroKey = GlobalKey();
  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey appsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  // Data
  ProfileModel? _profile;
  List<ProjectModel> _projects = [];
  List<AppModel> _apps = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final results = await Future.wait([
      FirebaseService.getProfile(),
      FirebaseService.getProjects(),
      FirebaseService.getApps(),
    ]);

    setState(() {
      _profile = results[0] as ProfileModel;
      _projects = results[1] as List<ProjectModel>;
      _apps = results[2] as List<AppModel>;
      _isLoading = false;
    });
  }

  void _scrollTo(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: _isLoading
          ? _buildLoader()
          : Stack(
              children: [
                // Animated background
                const _AnimatedBackground(),
                // Main content
                SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(
                    children: [
                      // NAVBAR
                      PortfolioNavbar(
                        onHeroTap: () => _scrollTo(heroKey),
                        onAboutTap: () => _scrollTo(aboutKey),
                        onProjectsTap: () => _scrollTo(projectsKey),
                        onAppsTap: () => _scrollTo(appsKey),
                        onContactTap: () => _scrollTo(contactKey),
                        profile: _profile!,
                      ),
                      // HERO SECTION
                      HeroSection(key: heroKey, profile: _profile!),
                      // ABOUT SECTION
                      AboutSection(key: aboutKey, profile: _profile!),
                      // SKILLS SECTION
                      SkillsSection(skills: _profile!.skills),
                      // PROJECTS SECTION
                      ProjectsSection(key: projectsKey, projects: _projects),
                      // APPS SECTION
                      AppsSection(key: appsKey, apps: _apps),
                      // CONTACT SECTION
                      ContactSection(key: contactKey, profile: _profile!),
                      // FOOTER
                      FooterWidget(profile: _profile!),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLoader() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: AppTheme.primary,
              strokeWidth: 2,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Loading Portfolio...',
            style: TextStyle(color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}

// Animated gradient background
class _AnimatedBackground extends StatefulWidget {
  const _AnimatedBackground();

  @override
  State<_AnimatedBackground> createState() => __AnimatedBackgroundState();
}

class __AnimatedBackgroundState extends State<_AnimatedBackground>
    with TickerProviderStateMixin {
  late AnimationController _controller1;
  late AnimationController _controller2;

  @override
  void initState() {
    super.initState();
    _controller1 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    _controller2 = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 12),
    )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller1, _controller2]),
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment(
                -0.5 + _controller1.value,
                -0.5 + _controller2.value * 0.5,
              ),
              radius: 1.5,
              colors: const [
                Color(0xFF0A1628),
                Color(0xFF050B15),
                Color(0xFF050B15),
              ],
            ),
          ),
          child: CustomPaint(painter: _GridPainter()),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00D4FF).withOpacity(0.03)
      ..strokeWidth = 1;

    const step = 60.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
