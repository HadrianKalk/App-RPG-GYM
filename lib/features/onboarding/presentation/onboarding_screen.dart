import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/brand.dart';
import '../../../app/theme.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_sprite.dart';
import '../../../l10n/l10n.dart';
import '../../../core/game/hero_appearance.dart';
import '../../../core/game/hero_profile.dart';
import '../../../data/repositories/providers.dart';
import '../../character/presentation/hero_customization_sheet.dart';

/// Hero creation: prologue → name → origin → oath.
///
/// When finished the hero is saved and the router automatically moves on
/// to the hero screen.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  static const _stepCount = 4;

  final _pageController = PageController();
  final _nameController = TextEditingController();
  final _oathController = TextEditingController();

  int _step = 0;
  HeroForm _form = HeroForm.masculine;
  HeroOrigin? _origin;
  HeroAppearance _appearance = HeroAppearance.defaultAppearance;
  final _originNameController = TextEditingController();
  final _originStoryController = TextEditingController();
  bool _saving = false;
  HeroNameError? _nameError;

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _oathController.dispose();
    _originNameController.dispose();
    _originStoryController.dispose();
    super.dispose();
  }

  bool get _canAdvance => switch (_step) {
        1 => HeroProfile.validateName(_nameController.text) == null,
        2 => _origin != null &&
            (_origin != HeroOrigin.custom ||
                HeroProfile.validateOriginName(_originNameController.text) == null),
        _ => true,
      };

  void _goTo(int step) {
    FocusScope.of(context).unfocus();
    setState(() => _step = step);
    _pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
    );
  }

  void _next() {
    if (_step == 1) {
      final error = HeroProfile.validateName(_nameController.text);
      if (error != null) {
        setState(() => _nameError = error);
        return;
      }
    }
    if (_step < _stepCount - 1) {
      _goTo(_step + 1);
    } else {
      _forgeHero();
    }
  }

  Future<void> _forgeHero() async {
    setState(() => _saving = true);
    try {
      await ref.read(heroRepositoryProvider).createHero(
            name: _nameController.text,
            form: _form,
            origin: _origin!,
            customOriginName: _originNameController.text,
            customOriginStory: _originStoryController.text,
            oath: _oathController.text,
            appearance: _appearance,
          );
      // The router watches the hero and redirects by itself.
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.l10n.onbForgeError('$e'))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _PrologueStep(),
                  _NameStep(
                    controller: _nameController,
                    form: _form,
                    appearance: _appearance,
                    errorText: _nameErrorText(context),
                    onFormChanged: (f) => setState(() => _form = f),
                    onAppearanceChanged: (a) => setState(() => _appearance = a),
                    onNameChanged: (_) => setState(() => _nameError = null),
                    onSubmitted: _next,
                  ),
                  _OriginStep(
                    selected: _origin,
                    onSelected: (o) => setState(() => _origin = o),
                    nameController: _originNameController,
                    storyController: _originStoryController,
                    onTextChanged: () => setState(() {}),
                  ),
                  _OathStep(
                    controller: _oathController,
                    name: _nameController.text.trim(),
                    form: _form,
                    origin: _origin,
                    appearance: _appearance,
                    onAppearanceChanged: (a) => setState(() => _appearance = a),
                    customOriginName: _originNameController.text.trim(),
                  ),
                ],
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 56,
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: _step > 0
                ? IconButton(
                    tooltip: context.l10n.commonBack,
                    icon: const PixelIcon(PixelIcons.back, size: 22, color: AppTheme.dullSilver),
                    onPressed: _saving ? null : () => _goTo(_step - 1),
                  )
                : null,
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_stepCount, (i) {
                final active = i <= _step;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _step ? 28 : 10,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? AppTheme.emberGold : AppTheme.ironBorder,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  /// Maps the engine's validation reason to a localized message.
  String? _nameErrorText(BuildContext context) => switch (_nameError) {
        null => null,
        HeroNameError.empty => context.l10n.nameErrorEmpty,
        HeroNameError.tooShort => context.l10n.nameErrorTooShort,
        HeroNameError.tooLong => context.l10n.nameErrorTooLong(HeroProfile.maxNameLength),
      };

  Widget _buildFooter() {
    final l10n = context.l10n;
    final label = switch (_step) {
      0 => l10n.onbBegin,
      3 => l10n.onbForge,
      _ => l10n.commonContinue,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
      child: PixelButton(
        label: label.toUpperCase(),
        loading: _saving,
        onPressed: _saving || !_canAdvance ? null : _next,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Steps
// ---------------------------------------------------------------------------

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({required this.title, required this.children, this.subtitle});

  final String title;
  final String? subtitle;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      children: [
        Text(title, style: textTheme.headlineMedium?.copyWith(color: AppTheme.emberGold)),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(subtitle!, style: textTheme.bodyMedium),
        ],
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }
}

class _PrologueStep extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      children: [
        const Center(child: PixelIcon(PixelIcons.flame, size: 88, color: AppTheme.emberOrange, accent: AppTheme.emberGold)),
        const SizedBox(height: 20),
        Text(AppBrand.appName, textAlign: TextAlign.center, style: display.style(56, color: AppTheme.emberGold, height: 1)),
        const SizedBox(height: 4),
        Text(l10n.brandSubtitle, textAlign: TextAlign.center, style: display.style(22, color: AppTheme.dullSilver)),
        const SizedBox(height: 24),
        Text(
          l10n.onbPrologue,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppTheme.ashWhite, fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 24),
        _LoreRow(icon: PixelIcons.dumbbell, text: l10n.onbLoreTraining),
        _LoreRow(icon: PixelIcons.scroll, text: l10n.onbLoreMind),
        _LoreRow(icon: PixelIcons.star, text: l10n.onbLoreClass),
      ],
    );
  }
}

class _LoreRow extends StatelessWidget {
  const _LoreRow({required this.icon, required this.text});

  final List<String> icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          PixelIcon(icon, size: 20, color: AppTheme.emberGold),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _NameStep extends StatelessWidget {
  const _NameStep({
    required this.controller,
    required this.form,
    required this.appearance,
    required this.errorText,
    required this.onFormChanged,
    required this.onAppearanceChanged,
    required this.onNameChanged,
    required this.onSubmitted,
  });

  final TextEditingController controller;
  final HeroForm form;
  final HeroAppearance appearance;
  final String? errorText;
  final ValueChanged<HeroForm> onFormChanged;
  final ValueChanged<HeroAppearance> onAppearanceChanged;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);

    return _StepScaffold(
      title: l10n.onbNameTitle,
      subtitle: l10n.onbNameSubtitle,
      children: [
        TextField(
          controller: controller,
          maxLength: HeroProfile.maxNameLength,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.next,
          style: const TextStyle(color: AppTheme.ashWhite, fontSize: 18),
          onChanged: onNameChanged,
          onSubmitted: (_) => onSubmitted(),
          decoration: InputDecoration(
            labelText: l10n.onbNameLabel,
            errorText: errorText,
            filled: true,
            fillColor: AppTheme.castIron,
            prefixIcon: const Icon(Icons.edit, color: AppTheme.emberGold),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.emberGold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(l10n.onbFormQuestion, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          children: [
            for (final f in HeroForm.values)
              ChoiceChip(
                label: Text('${game.heroFormLabel(f)} · ${game.heroFormTitle(f)}'),
                selected: form == f,
                onSelected: (_) => onFormChanged(f),
                selectedColor: AppTheme.emberGold,
                backgroundColor: AppTheme.castIron,
                labelStyle: TextStyle(
                  color: form == f ? AppTheme.obsidianBlack : AppTheme.ashWhite,
                  fontWeight: FontWeight.w600,
                ),
                side: BorderSide(color: form == f ? AppTheme.emberGold : AppTheme.ironBorder),
                showCheckmark: false,
              ),
          ],
        ),
        const SizedBox(height: 20),
        PixelFrame(
          color: AppTheme.castIron,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppTheme.obsidianBlack,
                      border: Border.all(color: AppTheme.emberGold, width: 2),
                    ),
                    child: HeroAvatar(appearance: appearance, pixelSize: 2.8),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appearancePresetsTitle,
                          style: display.style(20, color: AppTheme.emberGold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${game.hairStyle(appearance.hairStyle)} · ${game.torsoStyle(appearance.torsoStyle)}',
                          style: const TextStyle(color: AppTheme.dullSilver, fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        PixelButton(
                          key: const Key('onb_open_appearance_btn'),
                          label: l10n.appearanceCustomizeButton,
                          variant: PixelButtonVariant.secondary,
                          onPressed: () => showOnboardingAppearanceSheet(
                            context: context,
                            initialAppearance: appearance,
                            onChanged: onAppearanceChanged,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: [
                  for (final preset in HeroAppearancePreset.values)
                    InkWell(
                      key: Key('onb_preset_${preset.name}'),
                      onTap: () => onAppearanceChanged(HeroAppearance.fromPreset(preset)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                        decoration: BoxDecoration(
                          color: appearance == HeroAppearance.fromPreset(preset)
                              ? AppTheme.emberGold
                              : AppTheme.obsidianBlack,
                          border: Border.all(
                            color: appearance == HeroAppearance.fromPreset(preset)
                                ? AppTheme.emberGold
                                : AppTheme.ironBorder,
                          ),
                        ),
                        child: Text(
                          game.appearancePreset(preset),
                          style: TextStyle(
                            color: appearance == HeroAppearance.fromPreset(preset)
                                ? AppTheme.obsidianBlack
                                : AppTheme.ashWhite,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _OriginStep extends StatelessWidget {
  const _OriginStep({
    required this.selected,
    required this.onSelected,
    required this.nameController,
    required this.storyController,
    required this.onTextChanged,
  });

  final HeroOrigin? selected;
  final ValueChanged<HeroOrigin> onSelected;
  final TextEditingController nameController;
  final TextEditingController storyController;
  final VoidCallback onTextChanged;

  @override
  Widget build(BuildContext context) {
    return _StepScaffold(
      title: context.l10n.onbOriginTitle,
      subtitle: context.l10n.onbOriginSubtitle,
      children: [
        for (final origin in HeroOrigin.values)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OriginCard(
              origin: origin,
              selected: origin == selected,
              onTap: () => onSelected(origin),
            ),
          ),
        // Custom origin: the player writes the name and (optionally) the story.
        if (selected == HeroOrigin.custom) ...[
          TextField(
            controller: nameController,
            maxLength: HeroProfile.maxOriginNameLength,
            textCapitalization: TextCapitalization.words,
            onChanged: (_) => onTextChanged(),
            style: const TextStyle(color: AppTheme.ashWhite, fontSize: 16),
            decoration: InputDecoration(
              labelText: context.l10n.onbCustomOriginName,
              hintText: context.l10n.onbCustomOriginNameHint,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: storyController,
            maxLength: HeroProfile.maxOriginStoryLength,
            maxLines: 4,
            style: const TextStyle(color: AppTheme.ashWhite, fontSize: 14),
            decoration: InputDecoration(
              labelText: context.l10n.onbCustomOriginStory,
              hintText: context.l10n.onbCustomOriginStoryHint,
              alignLabelWithHint: true,
            ),
          ),
        ],
      ],
    );
  }
}

class _OriginCard extends StatelessWidget {
  const _OriginCard({required this.origin, required this.selected, required this.onTap});

  final HeroOrigin origin;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PixelFrame(
      highlight: selected,
      color: selected ? AppTheme.forgedSteel : AppTheme.castIron,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(origin.icon, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.game.originName(origin),
                  style: DisplayFont.from(context).style(22, color: selected ? AppTheme.emberGold : AppTheme.ashWhite),
                ),
                const SizedBox(height: 2),
                Text(
                  context.game.originDescription(origin),
                  style: const TextStyle(color: AppTheme.dullSilver, fontSize: 13, height: 1.35),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OathStep extends StatelessWidget {
  const _OathStep({
    required this.controller,
    required this.name,
    required this.form,
    required this.origin,
    required this.appearance,
    required this.onAppearanceChanged,
    this.customOriginName = '',
  });

  final TextEditingController controller;
  final String name;
  final HeroForm form;
  final HeroOrigin? origin;
  final HeroAppearance appearance;
  final ValueChanged<HeroAppearance> onAppearanceChanged;
  final String customOriginName;

  /// Origin label for the summary (typed name for custom origins).
  String _originLabel(BuildContext context) {
    if (origin == null) return '—';
    if (origin == HeroOrigin.custom && customOriginName.isNotEmpty) return customOriginName;
    return context.game.originName(origin!);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return _StepScaffold(
      title: context.l10n.onbOathTitle,
      subtitle: context.l10n.onbOathSubtitle,
      children: [
        TextField(
          controller: controller,
          maxLength: HeroProfile.maxOathLength,
          maxLines: 3,
          style: const TextStyle(color: AppTheme.ashWhite),
          decoration: InputDecoration(
            hintText: context.l10n.onbOathHint,
            hintStyle: const TextStyle(color: AppTheme.darkAsh),
            filled: true,
            fillColor: AppTheme.castIron,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.emberGold),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.castIron,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppTheme.emberGold.withValues(alpha: 0.5)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => showOnboardingAppearanceSheet(
                  context: context,
                  initialAppearance: appearance,
                  onChanged: onAppearanceChanged,
                ),
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.obsidianBlack,
                    border: Border.all(color: AppTheme.emberGold, width: 2),
                  ),
                  child: HeroAvatar(appearance: appearance, pixelSize: 2.5),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name.isEmpty ? '—' : name, style: textTheme.titleLarge?.copyWith(color: AppTheme.emberGold)),
                    const SizedBox(height: 4),
                    Text(
                      context.l10n.onbSummaryLine(context.game.heroFormTitle(form), _originLabel(context)),
                      style: textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      context.l10n.onbSummaryNote,
                      style: textTheme.bodySmall?.copyWith(color: AppTheme.dullSilver, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
