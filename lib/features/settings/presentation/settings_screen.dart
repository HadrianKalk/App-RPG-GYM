import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/brand.dart';
import '../../../app/theme.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../data/backup/backup_service.dart';
import '../../../l10n/l10n.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/xp_rules.dart';
import '../../../data/repositories/providers.dart';
import '../data/settings_providers.dart';
import '../domain/app_settings.dart';
import 'tester_panel_sheet.dart';

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
          _SectionTitle(l10n.settingsSound),
          PixelFrame(
            child: Row(
              children: [
                const Icon(Icons.volume_up, size: 22, color: AppTheme.emberGold),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.settingsSoundEffects,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        l10n.settingsSoundHint,
                        style: const TextStyle(color: AppTheme.darkAsh, fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Switch(
                  key: const Key('settings_sound_switch'),
                  value: settings.soundEnabled,
                  activeThumbColor: AppTheme.emberGold,
                  onChanged: notifier.setSoundEnabled,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(l10n.settingsTraining),
          const _WeeklyGoalTile(),
          const SizedBox(height: 10),
          const _WaterGoalTile(),
          const SizedBox(height: 20),
          _SectionTitle(l10n.testerButtonLabel),
          PixelFrame(
            key: const Key('settings_open_tester_btn'),
            onTap: () => showTesterPanelSheet(context),
            child: Row(
              children: [
                const PixelIcon(PixelIcons.swords, size: 22, color: AppTheme.emberGold),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.testerSheetTitle, style: Theme.of(context).textTheme.titleMedium),
                      Text(l10n.testerSheetSubtitle, style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: AppTheme.darkAsh),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle(l10n.settingsAiTitle),
          const _AiNarratorSection(),
          const SizedBox(height: 20),
          _SectionTitle(l10n.settingsBackup),
          const _BackupSection(),
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

/// Weekly goal stepper (stored on the hero: it changes game rewards).
class _WeeklyGoalTile extends ConsumerWidget {
  const _WeeklyGoalTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final goal = ref.watch(heroStreamProvider).valueOrNull?.weeklyGoal ?? XpRules.weeklyGoalDefault;
    final repo = ref.read(heroRepositoryProvider);

    Widget btn(IconData icon, VoidCallback? onTap) => InkWell(
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(border: Border.all(color: AppTheme.ironBorder, width: 2)),
            child: Icon(icon, size: 18, color: onTap == null ? AppTheme.forgedSteel : AppTheme.emberGold),
          ),
        );

    return PixelFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const PixelIcon(PixelIcons.flame, size: 20, color: AppTheme.emberOrange),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.settingsWeeklyGoal, style: Theme.of(context).textTheme.titleMedium)),
              btn(Icons.remove, goal > XpRules.weeklyGoalMin ? () => repo.setWeeklyGoal(goal - 1) : null),
              SizedBox(
                width: 76,
                child: Text(l10n.settingsWeeklyGoalValue(goal), textAlign: TextAlign.center, style: display.style(20, color: AppTheme.emberGold)),
              ),
              btn(Icons.add, goal < XpRules.weeklyGoalMax ? () => repo.setWeeklyGoal(goal + 1) : null),
            ],
          ),
          const SizedBox(height: 6),
          Text(l10n.settingsWeeklyGoalHint, style: const TextStyle(color: AppTheme.darkAsh, fontSize: 12)),
        ],
      ),
    );
  }
}

/// Daily water goal stepper (stored on the hero: it affects Constitution rewards).
class _WaterGoalTile extends ConsumerWidget {
  const _WaterGoalTile();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final goal = ref.watch(heroStreamProvider).valueOrNull?.waterGoalCups ?? XpRules.waterGoalDefaultCups;
    final repo = ref.read(heroRepositoryProvider);
    final conColor = AppTheme.attributeColor(Attribute.constitution);

    Widget btn(IconData icon, VoidCallback? onTap) => InkWell(
          onTap: onTap,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(border: Border.all(color: AppTheme.ironBorder, width: 2)),
            child: Icon(icon, size: 18, color: onTap == null ? AppTheme.forgedSteel : AppTheme.emberGold),
          ),
        );

    return PixelFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PixelIcon(PixelIcons.heart, size: 20, color: conColor),
              const SizedBox(width: 10),
              Expanded(child: Text(l10n.settingsWaterGoal, style: Theme.of(context).textTheme.titleMedium)),
              btn(Icons.remove, goal > XpRules.waterGoalMinCups ? () => repo.setWaterGoalCups(goal - 1) : null),
              SizedBox(
                width: 112,
                child: Text(
                  l10n.settingsWaterGoalValue(goal, goal * XpRules.waterCupMl),
                  textAlign: TextAlign.center,
                  style: display.style(18, color: AppTheme.emberGold),
                ),
              ),
              btn(Icons.add, goal < XpRules.waterGoalMaxCups ? () => repo.setWaterGoalCups(goal + 1) : null),
            ],
          ),
          const SizedBox(height: 6),
          Text(l10n.settingsWaterGoalHint, style: const TextStyle(color: AppTheme.darkAsh, fontSize: 12)),
        ],
      ),
    );
  }
}

/// Export & Restore portable JSON backup section for PWA / desktop safety.
class _BackupSection extends ConsumerWidget {
  const _BackupSection();

  Future<void> _exportBackup(BuildContext context, WidgetRef ref) async {
    final l10n = context.l10n;
    final backup = ref.read(backupServiceProvider);
    final settings = ref.read(settingsProvider);
    final downloaded = await backup.exportAndShare(settings: settings);
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          downloaded
              ? l10n.settingsBackupExportSuccessDownload
              : l10n.settingsBackupExportSuccessClipboard,
        ),
      ),
    );
  }

  Future<void> _openRestoreDialog(BuildContext context, WidgetRef ref) async {
    final restored = await showDialog<bool>(
      context: context,
      builder: (_) => _RestoreBackupDialog(ref: ref),
    );
    if (restored == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.settingsBackupRestoreSuccess)),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Column(
      children: [
        PixelFrame(
          key: const Key('settings_export_backup_btn'),
          onTap: () => _exportBackup(context, ref),
          child: Row(
            children: [
              const Icon(Icons.download, size: 22, color: AppTheme.emberGold),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsBackupExportTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      l10n.settingsBackupExportHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.darkAsh),
            ],
          ),
        ),
        const SizedBox(height: 10),
        PixelFrame(
          key: const Key('settings_restore_backup_btn'),
          onTap: () => _openRestoreDialog(context, ref),
          child: Row(
            children: [
              const Icon(Icons.upload, size: 22, color: AppTheme.emberGold),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.settingsBackupRestoreTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      l10n.settingsBackupRestoreHint,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppTheme.darkAsh),
            ],
          ),
        ),
      ],
    );
  }
}

class _RestoreBackupDialog extends StatefulWidget {
  const _RestoreBackupDialog({required this.ref});

  final WidgetRef ref;

  @override
  State<_RestoreBackupDialog> createState() => _RestoreBackupDialogState();
}

class _RestoreBackupDialogState extends State<_RestoreBackupDialog> {
  final _controller = TextEditingController();
  BackupPreview? _preview;
  String? _error;
  bool _restoring = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _inspectText(String text) {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      setState(() {
        _preview = null;
        _error = null;
      });
      return;
    }
    try {
      final service = widget.ref.read(backupServiceProvider);
      final preview = service.inspectJson(trimmed);
      setState(() {
        _preview = preview;
        _error = null;
      });
    } catch (_) {
      setState(() {
        _preview = null;
        _error = context.l10n.settingsBackupInvalidError;
      });
    }
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    if (!mounted) return;
    final text = data?.text ?? '';
    _controller.text = text;
    _inspectText(text);
  }

  Future<void> _confirmRestore() async {
    if (_preview == null || _restoring) return;
    setState(() => _restoring = true);
    try {
      final service = widget.ref.read(backupServiceProvider);
      final restoredSettings = await service.restoreJson(_controller.text);
      if (restoredSettings != null) {
        final settingsNotifier = widget.ref.read(settingsProvider.notifier);
        await settingsNotifier.setLanguage(restoredSettings.languageCode);
        await settingsNotifier.setFontStyle(restoredSettings.fontStyle);
        await settingsNotifier.setSoundEnabled(restoredSettings.soundEnabled);
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _restoring = false;
        _error = context.l10n.settingsBackupInvalidError;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: PixelFrame(
          highlight: true,
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.settingsBackupRestoreTitle,
                  style: display.style(22, color: AppTheme.emberGold),
                ),
                const SizedBox(height: 8),
                TextField(
                  key: const Key('backup_restore_input'),
                  controller: _controller,
                  maxLines: 5,
                  style: const TextStyle(fontSize: 12, color: AppTheme.ashWhite),
                  decoration: InputDecoration(
                    labelText: l10n.settingsBackupPasteLabel,
                    border: const OutlineInputBorder(),
                  ),
                  onChanged: _inspectText,
                ),
                const SizedBox(height: 8),
                OutlinedButton.icon(
                  onPressed: _pasteFromClipboard,
                  icon: const Icon(Icons.paste, size: 16),
                  label: Text(l10n.settingsBackupPasteFromClipboard),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    _error!,
                    style: const TextStyle(
                      color: AppTheme.bloodCrimson,
                      fontSize: 12,
                    ),
                  ),
                ],
                if (_preview != null) ...[
                  const SizedBox(height: 10),
                  PixelFrame(
                    color: AppTheme.obsidianBlack,
                    child: Text(
                      l10n.settingsBackupPreviewSummary(
                        _preview!.heroName ?? '-',
                        _preview!.workoutCount,
                        _preview!.xpEntryCount,
                      ),
                      key: const Key('backup_preview_summary'),
                      style: const TextStyle(
                        color: AppTheme.emberGold,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            _restoring ? null : () => Navigator.of(context).pop(false),
                        child: Text(l10n.commonCancel),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 2,
                      child: PixelButton(
                        key: const Key('backup_confirm_restore_btn'),
                        label: l10n.settingsBackupConfirmButton,
                        onPressed:
                            (_preview != null && !_restoring) ? _confirmRestore : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Optional local-only Gemini BYOK configuration for live AI storytelling.
class _AiNarratorSection extends ConsumerStatefulWidget {
  const _AiNarratorSection();

  @override
  ConsumerState<_AiNarratorSection> createState() => _AiNarratorSectionState();
}

class _AiNarratorSectionState extends ConsumerState<_AiNarratorSection> {
  late final TextEditingController _keyController;
  late final TextEditingController _modelController;

  @override
  void initState() {
    super.initState();
    final initial = ref.read(settingsProvider);
    _keyController = TextEditingController(text: initial.geminiApiKey ?? '');
    _modelController = TextEditingController(text: initial.geminiModel);
  }

  @override
  void dispose() {
    _keyController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    await ref.read(settingsProvider.notifier).setGeminiConfig(
          apiKey: _keyController.text,
          model: _modelController.text,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.settingsAiSavedToast)),
    );
  }

  Future<void> _clear() async {
    _keyController.clear();
    await ref.read(settingsProvider.notifier).setGeminiConfig(
          apiKey: null,
          model: _modelController.text,
        );
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(context.l10n.settingsAiSavedToast)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final settings = ref.watch(settingsProvider);

    return PixelFrame(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const PixelIcon(
                PixelIcons.scroll,
                size: 20,
                color: AppTheme.emberGold,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.settingsAiTitle,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              PixelTag(
                key: const Key('settings_ai_status_tag'),
                text: settings.hasGeminiKey
                    ? l10n.settingsAiStatusActive
                    : l10n.settingsAiStatusOffline,
                color: settings.hasGeminiKey
                    ? AppTheme.emberGold
                    : AppTheme.dullSilver,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.settingsAiHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 10),
          TextField(
            key: const Key('settings_ai_key_input'),
            controller: _keyController,
            obscureText: true,
            style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13),
            decoration: InputDecoration(
              labelText: l10n.settingsAiKeyLabel,
              isDense: true,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            key: const Key('settings_ai_model_input'),
            controller: _modelController,
            style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13),
            decoration: InputDecoration(
              labelText: l10n.settingsAiModelLabel,
              isDense: true,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: PixelButton(
                  key: const Key('settings_ai_save_btn'),
                  label: l10n.settingsAiSaveButton,
                  onPressed: _save,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PixelButton(
                  key: const Key('settings_ai_clear_btn'),
                  label: l10n.settingsAiClearButton,
                  variant: PixelButtonVariant.secondary,
                  onPressed: settings.hasGeminiKey ? _clear : null,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
