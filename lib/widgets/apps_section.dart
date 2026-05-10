// lib/widgets/apps_section.dart
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_model.dart';
import '../utils/theme.dart';
import 'section_header.dart';

class AppsSection extends StatelessWidget {
  final List<AppModel> apps;
  const AppsSection({super.key, required this.apps});

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
            tag: '04',
            title: 'Published Apps',
            subtitle: 'Available on Play Store & App Store',
          ),
          const SizedBox(height: 60),
          if (apps.isEmpty)
            Container(
              padding: const EdgeInsets.all(60),
              decoration: BoxDecoration(
                color: AppTheme.bgCard,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.phone_android,
                    color: AppTheme.primary,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Add apps in Firebase\n(apps collection)',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isMobile ? 1 : 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isMobile ? 4.5 : 4.0,
              ),
              itemCount: apps.length,
              itemBuilder: (context, index) => FadeInUp(
                delay: Duration(milliseconds: index * 100),
                child: _AppCompactCard(app: apps[index]),
              ),
            ),
        ],
      ),
    );
  }
}

// ── Compact card (like Play Store list item) ──────────────────────────────────

class _AppCompactCard extends StatefulWidget {
  final AppModel app;
  const _AppCompactCard({required this.app});

  @override
  State<_AppCompactCard> createState() => __AppCompactCardState();
}

class __AppCompactCardState extends State<_AppCompactCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _showAppDetail(context, widget.app),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          transform: Matrix4.identity()..translate(0.0, _hovered ? -2.0 : 0.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _hovered
                  ? AppTheme.primary.withOpacity(0.5)
                  : AppTheme.border,
            ),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppTheme.primary.withOpacity(0.08),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              // App icon
              _AppIcon(
                iconUrl: widget.app.iconUrl,
                name: widget.app.name,
                size: 56,
              ),
              const SizedBox(width: 14),
              // Name + category + rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.app.name,
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
                      widget.app.category,
                      style: GoogleFonts.inter(
                        color: AppTheme.primary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    _RatingMini(app: widget.app),
                  ],
                ),
              ),
              // Arrow hint
              Icon(
                Icons.chevron_right_rounded,
                color: _hovered ? AppTheme.primary : AppTheme.textSecondary,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showAppDetail(BuildContext context, AppModel app) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (_) => _AppDetailDialog(app: app),
  );
}

// ── Full detail dialog ────────────────────────────────────────────────────────

class _AppDetailDialog extends StatefulWidget {
  final AppModel app;
  const _AppDetailDialog({required this.app});

  @override
  State<_AppDetailDialog> createState() => __AppDetailDialogState();
}

class __AppDetailDialogState extends State<_AppDetailDialog> {
  int _selectedScreenshot = 0;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxW = isMobile ? double.infinity : 760.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 40,
        vertical: 40,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxW),
        child: Container(
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              _buildHeader(isMobile),
              // Scrollable body
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height * 0.65,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Divider between header and body
                      Container(
                        height: 1,
                        color: AppTheme.border,
                        margin: const EdgeInsets.only(bottom: 20),
                      ),
                      // Description
                      if ((widget.app.description.isNotEmpty))
                        Text(
                          widget.app.description,
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        )
                      else if (widget.app.shortDescription.isNotEmpty)
                        Text(
                          widget.app.shortDescription,
                          style: GoogleFonts.inter(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                            height: 1.7,
                          ),
                        ),
                      // Screenshots
                      if (widget.app.screenshots.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _sectionTitle('Screenshots'),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.app.screenshots.length,
                            itemBuilder: (context, index) => GestureDetector(
                              onTap: () =>
                                  setState(() => _selectedScreenshot = index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 12),
                                width: 100,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: _selectedScreenshot == index
                                        ? AppTheme.primary
                                        : AppTheme.border,
                                    width: _selectedScreenshot == index ? 2 : 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(11),
                                  child: CachedNetworkImage(
                                    imageUrl: widget.app.screenshots[index],
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
                        ),
                      ],
                      // Features
                      if (widget.app.features.isNotEmpty) ...[
                        const SizedBox(height: 24),
                        _sectionTitle('Features'),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: widget.app.features
                              .map(
                                (f) => Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.bgCard2,
                                    borderRadius: BorderRadius.circular(50),
                                    border: Border.all(color: AppTheme.border),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.check_circle_outline,
                                        color: AppTheme.accent,
                                        size: 14,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        f,
                                        style: GoogleFonts.inter(
                                          color: AppTheme.textSecondary,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                      // Download buttons
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          if (widget.app.playStoreUrl != null)
                            _StoreButton(
                              label: 'Google Play',
                              sublabel: 'Get it on',
                              icon: Icons.android,
                              color: const Color(0xFF3DDC84),
                              url: widget.app.playStoreUrl!,
                            ),
                          if (widget.app.appStoreUrl != null)
                            _StoreButton(
                              label: 'App Store',
                              sublabel: 'Download on the',
                              icon: Icons.apple,
                              color: Colors.white,
                              url: widget.app.appStoreUrl!,
                            ),
                          if (widget.app.androidApkUrl != null)
                            _StoreButton(
                              label: 'Download APK',
                              sublabel: 'Direct',
                              icon: Icons.download_outlined,
                              color: AppTheme.primary,
                              url: widget.app.androidApkUrl!,
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

  Widget _buildHeader(bool isMobile) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _AppIcon(
            iconUrl: widget.app.iconUrl,
            name: widget.app.name,
            size: 64,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.app.name,
                  style: GoogleFonts.spaceGrotesk(
                    color: AppTheme.textPrimary,
                    fontSize: isMobile ? 18 : 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: AppTheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Text(
                    widget.app.category,
                    style: GoogleFonts.inter(
                      color: AppTheme.primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                _RatingRow(app: widget.app),
              ],
            ),
          ),
          // Close button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              Icons.close_rounded,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: GoogleFonts.spaceGrotesk(
      color: AppTheme.textPrimary,
      fontSize: 15,
      fontWeight: FontWeight.w600,
    ),
  );
}

// ── Shared widgets ────────────────────────────────────────────────────────────

class _AppIcon extends StatelessWidget {
  final String iconUrl;
  final String name;
  final double size;
  const _AppIcon({required this.iconUrl, required this.name, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.22),
        border: Border.all(color: AppTheme.border),
        gradient: AppGradients.primaryGradient,
      ),
      child: iconUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(size * 0.22 - 1),
              child: CachedNetworkImage(
                imageUrl: iconUrl,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => _fallback(name),
              ),
            )
          : _fallback(name),
    );
  }

  Widget _fallback(String name) => Center(
    child: Text(
      name.isNotEmpty ? name[0].toUpperCase() : 'A',
      style: TextStyle(
        color: Colors.white,
        fontSize: size * 0.4,
        fontWeight: FontWeight.w900,
      ),
    ),
  );
}

class _RatingMini extends StatelessWidget {
  final AppModel app;
  const _RatingMini({required this.app});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StarRow(rating: app.rating, size: 12),
        const SizedBox(width: 5),
        Text(
          app.rating.toStringAsFixed(1),
          style: GoogleFonts.inter(
            color: const Color(0xFFFFD700),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  final AppModel app;
  const _RatingRow({required this.app});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StarRow(rating: app.rating, size: 16),
        const SizedBox(width: 8),
        Text(
          app.rating.toStringAsFixed(1),
          style: GoogleFonts.orbitron(
            color: const Color(0xFFFFD700),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '(${_formatNumber(app.totalRatings)} ratings)',
          style: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 13),
        ),
        if (app.downloads > 0) ...[
          const SizedBox(width: 16),
          const Icon(
            Icons.download_outlined,
            color: AppTheme.textSecondary,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            '${_formatNumber(app.downloads)}+ downloads',
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ],
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

class _StarRow extends StatelessWidget {
  final double rating;
  final double size;
  const _StarRow({required this.rating, required this.size});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(
            Icons.star_rounded,
            color: const Color(0xFFFFD700),
            size: size,
          );
        } else if (index < rating) {
          return Icon(
            Icons.star_half_rounded,
            color: const Color(0xFFFFD700),
            size: size,
          );
        } else {
          return Icon(
            Icons.star_outline_rounded,
            color: const Color(0xFFFFD700),
            size: size,
          );
        }
      }),
    );
  }
}

class _StoreButton extends StatefulWidget {
  final String label;
  final String sublabel;
  final IconData icon;
  final Color color;
  final String url;

  const _StoreButton({
    required this.label,
    required this.sublabel,
    required this.icon,
    required this.color,
    required this.url,
  });

  @override
  State<_StoreButton> createState() => __StoreButtonState();
}

class __StoreButtonState extends State<_StoreButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => launchUrl(Uri.parse(widget.url)),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: _hovered ? widget.color.withOpacity(0.15) : AppTheme.bgCard2,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered ? widget.color : AppTheme.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: widget.color, size: 22),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.sublabel,
                    style: GoogleFonts.inter(
                      color: AppTheme.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    widget.label,
                    style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
