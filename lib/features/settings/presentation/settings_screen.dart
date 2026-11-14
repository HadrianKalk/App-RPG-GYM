import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/brand.dart';
import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../l10n/l10n.dart';
import '../data/settings_providers.dart';
import '../domain/app_settings.dart';

/// User preferences: language and display font, plus the About section.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  /// Language options shown to the user (null = device default).
  /// Native names are intentionally not translated.
  static const List<(String?, String?)> _languages = [
    (null, null),
    ('pt', 'Português (Brasil)'),
    ('en', 'English'),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);
    final notifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.commonSettings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle(l10n.settingsLanguage),
          PixelFrame(
            padding: EdgeInsets.zero,
            child: Column(
              children: [
                for (final (code, nativeName) in _languages)
                  _OptionTile(
                    label: nativeName ?? l10n.languageSystem,
                    selected: settings.languageCode == code,
                    onTap: () => notifier.setLanguage(code),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(l10n.settingsFont),
          Row(
            children: [
              for (final style in AppFontStyle.values) ...[
                if (style != AppFontStyle.values.first) const SizedBox(width: 10),
                Expanded(
                  child: _FontCard(
                    style: style,
                    label: style == AppFontStyle.pixel ? l10n.fontPixel : l10n.fontClassic,
                    preview: l10n.fontPreview,
                    selected: settings.fontStyle == style,
                    onTap: () => notifier.setFontStyle(style),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 20),
          _SectionTitle(l10n.settingsAbout),
          PixelFrame(
            onTap: () => context.push('/settings/credits'),
            child: Row(
              children: [
                const PixelIcon(PixelIcons.trophy, size: 22, color: AppTheme.emberGold),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.creditsTitle, style: Theme.of(context).textTheme.titleMedium),
                      Text(l10n.creditsSubtitle, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.darkAsh),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${AppBrand.fullTitle} · ${l10n.appVersion(AppBrand.version)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(left: 2, bottom: 8),
        child: Text(text, style: Theme.of(context).textTheme.titleLarge),
      );
}

/// Radio-like row used for the language list.
class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                border: Border.all(color: selected ? AppTheme.emberGold : AppTheme.ironBorder, width: 2),
              ),
              padding: const EdgeInsets.all(3),
              child: selected ? Container(color: AppTheme.emberGold) : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(color: selected ? AppTheme.ashWhite : AppTheme.dullSilver, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Font-style option rendered with its own font so users see the result.
class _FontCard extends StatelessWidget {
  const _FontCard({
    required this.style,
    required this.label,
    required this.preview,
    required this.selected,
    required this.onTap,
  });

  final AppFontStyle style;
  final String label;
  final String preview;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final font = DisplayFont.of(style);
    return PixelFrame(
      highlight: selected,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: font.style(26, color: selected ? AppTheme.emberGold : AppTheme.ashWhite)),
          const SizedBox(height: 6),
          Text(preview, style: font.style(17, color: AppTheme.dullSilver)),
        ],
      ),
    );
  }
}
