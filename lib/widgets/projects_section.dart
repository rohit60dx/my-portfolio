// lib/widgets/projects_section.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rohit_portfolio/models/app_model.dart';
import 'package:rohit_portfolio/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

import 'section_header.dart';

class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;
  const ProjectsSection({super.key, required this.projects});

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
            tag: '03',
            title: 'Projects',
            subtitle: 'Things I have built',
          ),
          const SizedBox(height: 60),
          if (projects.isEmpty)
            _EmptyState(
              message: 'Add projects in Firebase\n(projects collection)',
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                mainAxisSpacing: 24,
                crossAxisSpacing: 24,
                childAspectRatio: isMobile ? 1.2 : 1.1,
              ),
              itemCount: projects.length,
              itemBuilder: (context, index) => FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: _ProjectCard(project: projects[index]),
              ),
            ),
        ],
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  const _ProjectCard({required this.project});

  @override
  State<_ProjectCard> createState() => __ProjectCardState();
}

class __ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()..translate(0.0, _hovered ? -4.0 : 0.0),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppTheme.primary.withOpacity(0.5)
                : AppTheme.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.1),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screenshot / thumbnail
              Expanded(
                flex: 5,
                child: widget.project.screenshots.isNotEmpty
                    ? _ScreenshotCarousel(
                        screenshots: widget.project.screenshots,
                      )
                    : _PlaceholderImage(title: widget.project.title),
              ),
              // Details
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: AppTheme.primary.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          widget.project.category,
                          style: GoogleFonts.inter(
                            color: AppTheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        widget.project.title,
                        style: GoogleFonts.spaceGrotesk(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.project.description,
                        style: GoogleFonts.inter(
                          color: AppTheme.textSecondary,
                          fontSize: 13,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      // Tech chips
                      Wrap(
                        spacing: 6,
                        runSpacing: 4,
                        children: widget.project.technologies
                            .take(3)
                            .map(
                              (t) => Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.bgCard2,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  t,
                                  style: GoogleFonts.inter(
                                    color: AppTheme.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          if (widget.project.githubUrl != null)
                            _LinkBtn(
                              icon: Icons.code,
                              label: 'GitHub',
                              url: widget.project.githubUrl!,
                            ),
                          const SizedBox(width: 8),
                          if (widget.project.liveUrl != null)
                            _LinkBtn(
                              icon: Icons.open_in_new,
                              label: 'Live',
                              url: widget.project.liveUrl!,
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScreenshotCarousel extends StatefulWidget {
  final List<String> screenshots;
  const _ScreenshotCarousel({required this.screenshots});

  @override
  State<_ScreenshotCarousel> createState() => __ScreenshotCarouselState();
}

class __ScreenshotCarouselState extends State<_ScreenshotCarousel> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CachedNetworkImage(
          imageUrl: widget.screenshots[_current],
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            color: AppTheme.bgCard2,
            child: const Center(
              child: CircularProgressIndicator(
                color: AppTheme.primary,
                strokeWidth: 2,
              ),
            ),
          ),
          errorWidget: (_, __, ___) => _PlaceholderImage(title: ''),
        ),
        if (widget.screenshots.length > 1)
          Positioned(
            bottom: 8,
            right: 8,
            child: Row(
              children: widget.screenshots.asMap().entries.map((e) {
                return GestureDetector(
                  onTap: () => setState(() => _current = e.key),
                  child: Container(
                    width: _current == e.key ? 16 : 6,
                    height: 6,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: _current == e.key
                          ? AppTheme.primary
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
      ],
    );
  }
}

class _PlaceholderImage extends StatelessWidget {
  final String title;
  const _PlaceholderImage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.bgCard2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.code, color: AppTheme.primary, size: 40),
          if (title.isNotEmpty)
            Text(title, style: const TextStyle(color: AppTheme.textSecondary)),
        ],
      ),
    );
  }
}

class _LinkBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final String url;

  const _LinkBtn({required this.icon, required this.label, required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => launchUrl(Uri.parse(url)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppTheme.bgCard2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.primary, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
        border: Border.all(color: AppTheme.border, style: BorderStyle.solid),
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
