// lib/widgets/projects_section.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rohit_portfolio/models/project_model.dart';
import 'package:rohit_portfolio/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import 'section_header.dart';

class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;
  const ProjectsSection({super.key, required this.projects});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    final liveProjects = projects.where((p) => p.isProduction).toList();
    final upcomingProjects = projects.where((p) => !p.isProduction).toList();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 80,
        vertical: 80,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SectionHeader(
          //   tag: '03',
          //   title: 'Projects',
          //   subtitle: 'Things I have built & what\'s coming',
          // ),
          // NAYA
          Center(
            child: const SectionHeader(
              tag: '03',
              title: 'Projects',
              subtitle: 'Work in Progress 🚧',
            ),
          ),
          const SizedBox(height: 60),

          if (projects.isEmpty)
            _EmptyState(
              message: 'Add projects in Firebase\n(projects collection)',
            )
          else ...[
            // ── LIVE PROJECTS ──────────────────────────────
            if (liveProjects.isNotEmpty) ...[
              _SectionLabel(
                icon: Icons.check_circle_outline,
                label: 'Live Projects',
                color: AppTheme.accent,
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: liveProjects.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => FadeInUp(
                  delay: Duration(milliseconds: index * 80),
                  child: _ProjectTile(project: liveProjects[index]),
                ),
              ),
            ],

            // ── UPCOMING PROJECTS ──────────────────────────
            if (upcomingProjects.isNotEmpty) ...[
              SizedBox(height: liveProjects.isNotEmpty ? 48 : 0),
              _SectionLabel(
                icon: Icons.rocket_launch_outlined,
                label: 'Upcoming Projects',
                color: const Color(0xFFFFD700),
              ),
              const SizedBox(height: 16),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: upcomingProjects.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) => FadeInUp(
                  delay: Duration(milliseconds: index * 80),
                  child: _ProjectTile(project: upcomingProjects[index]),
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}

// ── Section Label ───────────────────────────────────────────────
class _SectionLabel extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _SectionLabel({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 10),
        Text(
          label,
          style: GoogleFonts.spaceGrotesk(
            color: color,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.4), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ── Compact Project Tile ────────────────────────────────────────
class _ProjectTile extends StatefulWidget {
  final ProjectModel project;
  const _ProjectTile({required this.project});

  @override
  State<_ProjectTile> createState() => __ProjectTileState();
}

class __ProjectTileState extends State<_ProjectTile> {
  bool _hovered = false;
  bool _expanded = false;

  Color get _badgeColor =>
      widget.project.isProduction ? AppTheme.accent : const Color(0xFFFFD700);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: _hovered ? AppTheme.bgCard2 : AppTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered ? _badgeColor.withOpacity(0.4) : AppTheme.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: _badgeColor.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Column(
            children: [
              // ── Main Row ──────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  children: [
                    // Thumbnail
                    _Thumbnail(project: widget.project),
                    const SizedBox(width: 16),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.title,
                            style: GoogleFonts.spaceGrotesk(
                              color: AppTheme.textPrimary,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Text(
                            widget.project.category,
                            style: GoogleFonts.inter(
                              color: _badgeColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 6,
                            runSpacing: 4,
                            children: widget.project.technologies
                                .take(3)
                                .map(
                                  (t) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 7,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.bg,
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(
                                        color: AppTheme.border,
                                      ),
                                    ),
                                    child: Text(
                                      t,
                                      style: GoogleFonts.inter(
                                        color: AppTheme.textSecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Badge + Arrow
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _badgeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(50),
                            border: Border.all(
                              color: _badgeColor.withOpacity(0.4),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: _badgeColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: _badgeColor.withOpacity(0.7),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                widget.project.isProduction
                                    ? 'Live'
                                    : 'Upcoming',
                                style: GoogleFonts.inter(
                                  color: _badgeColor,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        AnimatedRotation(
                          turns: _expanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: AppTheme.textSecondary,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // ── Expanded Details ──────────────────────────
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 250),
                crossFadeState: _expanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(color: AppTheme.border),
                      const SizedBox(height: 8),
                      Text(
                        widget.project.description,
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                      if (widget.project.screenshots.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 160,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.project.screenshots.length,
                            itemBuilder: (context, i) => Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppTheme.border),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(7),
                                child: CachedNetworkImage(
                                  imageUrl: widget.project.screenshots[i],
                                  fit: BoxFit.cover,
                                  placeholder: (_, __) => Container(
                                    color: AppTheme.bgCard2,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppTheme.primary,
                                        strokeWidth: 1.5,
                                      ),
                                    ),
                                  ),
                                  errorWidget: (_, __, ___) => Container(
                                    color: AppTheme.bgCard2,
                                    child: const Icon(
                                      Icons.image_outlined,
                                      color: AppTheme.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (widget.project.isProduction) ...[
                            if (widget.project.githubUrl != null)
                              _ActionBtn(
                                icon: Icons.code,
                                label: 'GitHub',
                                url: widget.project.githubUrl!,
                                color: AppTheme.primary,
                              ),
                            const SizedBox(width: 8),
                            if (widget.project.liveUrl != null)
                              _ActionBtn(
                                icon: Icons.open_in_new,
                                label: 'Live Demo',
                                url: widget.project.liveUrl!,
                                color: AppTheme.accent,
                              ),
                          ] else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFFFFD700,
                                ).withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: const Color(
                                    0xFFFFD700,
                                  ).withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.schedule,
                                    color: Color(0xFFFFD700),
                                    size: 14,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Coming Soon',
                                    style: GoogleFonts.inter(
                                      color: const Color(0xFFFFD700),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                secondChild: const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Thumbnail ───────────────────────────────────────────────────
class _Thumbnail extends StatelessWidget {
  final ProjectModel project;
  const _Thumbnail({required this.project});

  @override
  Widget build(BuildContext context) {
    final color = project.isProduction
        ? AppTheme.primary
        : const Color(0xFFFFD700);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
        color: AppTheme.bg,
      ),
      child: project.screenshots.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(11),
              child: CachedNetworkImage(
                imageUrl: project.screenshots[0],
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _fallback(color),
              ),
            )
          : _fallback(color),
    );
  }

  Widget _fallback(Color color) => Center(
    child: Icon(
      project.isProduction ? Icons.code_rounded : Icons.rocket_launch_outlined,
      color: color,
      size: 24,
    ),
  );
}

// ── Action Button ───────────────────────────────────────────────
class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;
  final Color color;

  const _ActionBtn({
    required this.icon,
    required this.label,
    required this.url,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                color: color,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Empty State ─────────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  final String message;
  const _EmptyState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(60),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.add_circle_outline,
            color: AppTheme.primary,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
