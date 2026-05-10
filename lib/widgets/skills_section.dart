// lib/widgets/skills_section.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/theme.dart';
import 'section_header.dart';

class SkillsSection extends StatelessWidget {
  final List<String> skills;
  const SkillsSection({super.key, required this.skills});

  // Icons + colors for common Flutter dev skills
  static const Map<String, Map<String, dynamic>> skillMeta = {
    'Flutter': {'emoji': '💙', 'color': Color(0xFF54C5F8)},
    'Dart': {'emoji': '🎯', 'color': Color(0xFF00B4D8)},
    'Firebase': {'emoji': '🔥', 'color': Color(0xFFFF6B35)},
    'REST APIs': {'emoji': '🌐', 'color': Color(0xFF06FFA5)},
    'Git': {'emoji': '🔀', 'color': Color(0xFFF05033)},
    'Android': {'emoji': '🤖', 'color': Color(0xFF3DDC84)},
    'iOS': {'emoji': '🍎', 'color': Colors.white},
    'UI/UX': {'emoji': '🎨', 'color': Color(0xFFAB5CF7)},
    'GetX': {'emoji': '⚡', 'color': Color(0xFFFFD60A)},
    'Bloc': {'emoji': '🧩', 'color': Color(0xFF0088FF)},
    'Provider': {'emoji': '📦', 'color': Color(0xFF7C3AED)},
    'SQL': {'emoji': '🗄️', 'color': Color(0xFF00D4FF)},
  };

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
            tag: '02',
            title: 'Skills & Tech',
            subtitle: 'What I work with',
          ),
          const SizedBox(height: 60),
          Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            children: skills.map((skill) => _SkillChip(skill: skill)).toList(),
          ),
        ],
      ),
    );
  }
}

class _SkillChip extends StatefulWidget {
  final String skill;
  const _SkillChip({required this.skill});

  @override
  State<_SkillChip> createState() => __SkillChipState();
}

class __SkillChipState extends State<_SkillChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final meta = SkillsSection.skillMeta[widget.skill];
    final color = meta != null
        ? meta['color'] as Color
        : AppTheme.primary;
    final emoji = meta != null ? meta['emoji'] as String : '⚙️';

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: _hovered
              ? color.withOpacity(0.15)
              : AppTheme.bgCard,
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: _hovered ? color : AppTheme.border,
            width: 1,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.2),
                    blurRadius: 15,
                    spreadRadius: 1,
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              widget.skill,
              style: GoogleFonts.inter(
                color: _hovered ? color : AppTheme.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
