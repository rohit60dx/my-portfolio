// lib/widgets/add_app_dialog.dart
//
// Use karo kuch is tarah:
//   ElevatedButton(
//     onPressed: () => showAddAppDialog(context, onSave: (app) {
//       FirebaseService.saveApp(app); // apna save logic
//     }),
//     child: Text('Add App'),
//   )

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rohit_portfolio/models/app_model.dart';
import 'package:rohit_portfolio/services/app_fetch_service.dart';
import 'package:rohit_portfolio/utils/theme.dart';

void showAddAppDialog(
  BuildContext context, {
  required void Function(AppModel app) onSave,
}) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.75),
    builder: (_) => _AddAppDialog(onSave: onSave),
  );
}

class _AddAppDialog extends StatefulWidget {
  final void Function(AppModel app) onSave;
  const _AddAppDialog({required this.onSave});

  @override
  State<_AddAppDialog> createState() => __AddAppDialogState();
}

class __AddAppDialogState extends State<_AddAppDialog> {
  final _playCtrl = TextEditingController();
  final _appleCtrl = TextEditingController();

  bool _loading = false;
  String? _error;
  AppModel? _fetched;

  Future<void> _fetch() async {
    final play = _playCtrl.text.trim();
    final apple = _appleCtrl.text.trim();

    if (play.isEmpty && apple.isEmpty) {
      setState(() => _error = 'Kam se kam ek URL daalo');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _fetched = null;
    });

    final app = await AppFetchService.fetchFromStores(
      playStoreUrl: play.isNotEmpty ? play : null,
      appStoreUrl: apple.isNotEmpty ? apple : null,
    );

    setState(() {
      _loading = false;
      if (app == null) {
        _error = 'Details fetch nahi ho saki. URL check karo.';
      } else {
        _fetched = app;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.border),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title row
                Row(
                  children: [
                    const Icon(
                      Icons.add_circle_outline,
                      color: AppTheme.primary,
                      size: 22,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'App Add Karo',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Play Store URL
                _label('Play Store URL (optional)'),
                const SizedBox(height: 8),
                _textField(
                  controller: _playCtrl,
                  hint:
                      'https://play.google.com/store/apps/details?id=com.example.app',
                  icon: Icons.android,
                  iconColor: const Color(0xFF3DDC84),
                ),
                const SizedBox(height: 16),

                // App Store URL
                _label('App Store URL (optional)'),
                const SizedBox(height: 8),
                _textField(
                  controller: _appleCtrl,
                  hint: 'https://apps.apple.com/app/id123456789',
                  icon: Icons.apple,
                  iconColor: Colors.white,
                ),
                const SizedBox(height: 24),

                // Error
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.redAccent,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _error!,
                            style: GoogleFonts.inter(
                              color: Colors.redAccent,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                // Fetched preview
                if (_fetched != null) _buildPreview(_fetched!),

                // Fetch button
                if (_fetched == null)
                  SizedBox(
                    width: double.infinity,
                    child: _loading
                        ? const Center(
                            child: Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                color: AppTheme.primary,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : ElevatedButton.icon(
                            onPressed: _fetch,
                            icon: const Icon(Icons.search_rounded, size: 18),
                            label: Text(
                              'Details Fetch Karo',
                              style: GoogleFonts.spaceGrotesk(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: AppTheme.bg,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                  ),

                // Save button (shown after fetch)
                if (_fetched != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => setState(() => _fetched = null),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppTheme.textSecondary,
                            side: const BorderSide(color: AppTheme.border),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text('Wapas', style: GoogleFonts.inter()),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            widget.onSave(_fetched!);
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.save_outlined, size: 18),
                          label: Text(
                            'Firebase Mein Save Karo',
                            style: GoogleFonts.spaceGrotesk(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accent,
                            foregroundColor: AppTheme.bg,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(
    text,
    style: GoogleFonts.inter(
      color: AppTheme.textSecondary,
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
  );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) => TextField(
    controller: controller,
    style: GoogleFonts.inter(color: AppTheme.textPrimary, fontSize: 13),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: AppTheme.textSecondary, fontSize: 12),
      prefixIcon: Icon(icon, color: iconColor, size: 18),
      filled: true,
      fillColor: AppTheme.bgCard2,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppTheme.primary, width: 1.5),
      ),
    ),
  );

  Widget _buildPreview(AppModel app) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppTheme.bgCard2,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(
              Icons.check_circle_outline,
              color: AppTheme.accent,
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              'Details mil gayi!',
              style: GoogleFonts.spaceGrotesk(
                color: AppTheme.accent,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _previewRow('App', app.name),
        _previewRow('Category', app.category),
        _previewRow('Rating', app.rating.toStringAsFixed(1)),
        // _previewRow('Developer', app.developer),
        _previewRow('Screenshots', '${app.screenshots.length} screenshots'),
      ],
    ),
  );

  Widget _previewRow(String label, String value) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            label,
            style: GoogleFonts.inter(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value.isEmpty ? '—' : value,
            style: GoogleFonts.inter(
              color: AppTheme.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}
