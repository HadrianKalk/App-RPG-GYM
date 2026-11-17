import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_sprite.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../app/ui/segmented_bar.dart';
import '../../../core/audio/sound_service.dart';
import '../../../core/game/combat.dart';
import '../../../core/game/hero_profile.dart';
import '../../../core/game/story.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';
import '../../arena/presentation/d20_roll_dialog.dart';
import '../../arena/presentation/d20_roller_widget.dart';
import '../domain/story_narrator.dart';

/// Interactive Dark Fantasy Story Mode screen driven by [StoryEngine] and
/// [StoryNarrator] (Offline Template in 7B; Remote AI in 7C).
class StoryModeView extends ConsumerStatefulWidget {
  const StoryModeView({
    super.key,
    required this.char,
    required this.hero,
    required this.testerEnabled,
    required this.onBackToHub,
    required this.onStartStoryCombat,
  });

  final CharacterState char;
  final HeroProfile hero;
  final bool testerEnabled;
  final VoidCallback onBackToHub;
  final ValueChanged<StoryCombatSpec> onStartStoryCombat;

  @override
  ConsumerState<StoryModeView> createState() => _StoryModeViewState();
}

class _StoryModeViewState extends ConsumerState<StoryModeView> {
  final _inputController = TextEditingController();
  StorySceneResponse? _scene;
  StorySkillCheckSpec? _lastSkillCheck;
  D20RollResult? _lastSkillRoll;
  bool _lastSkillUsedInspiration = false;
  int _rollSeed = 0;
  bool _loading = false;
  bool _initialized = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  CombatStats _heroStats() => CombatStats.fromHero(
        level: widget.char.levelInfo.level,
        characterClass: widget.char.characterClass,
        attributeScores: {
          for (final entry in widget.char.attributeProgressions.entries)
            entry.key: entry.value.score,
        },
      );

  StoryNarrationContext _buildContext(
    StoryArcState arc,
    StoryHabitDigest habits, {
    String? playerInput,
    StoryChoiceOption? selectedChoice,
  }) {
    final lang = Localizations.localeOf(context).languageCode;
    return StoryNarrationContext(
      languageCode: lang,
      heroProfile: widget.hero,
      heroLevel: widget.char.levelInfo.level,
      effectiveClass: widget.char.characterClass,
      heroStats: _heroStats(),
      arc: arc,
      habits: habits,
      playerInput: playerInput,
      selectedChoice: selectedChoice,
    );
  }

  Future<void> _ensureOpeningScene(
    StoryArcState arc,
    StoryHabitDigest habits,
  ) async {
    if (_initialized || _loading) return;
    _initialized = true;
    _loading = true;
    final narrator = ref.read(storyNarratorProvider);
    final response = await narrator.advanceScene(_buildContext(arc, habits));
    if (!mounted) return;
    setState(() {
      _scene = response;
      _loading = false;
    });
  }

  Future<void> _consumeCombatOutcomeIfPending(
    StoryArcState arc,
    StoryHabitDigest habits,
  ) async {
    final pending = ref.read(storyPendingCombatOutcomeProvider);
    if (pending == null || _loading) return;
    // Clear provider immediately after current frame so it isn't re-consumed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(storyPendingCombatOutcomeProvider.notifier).state = null;
      }
    });

    _loading = true;
    final narrator = ref.read(storyNarratorProvider);
    final outcomeScene = await narrator.narrateCombatOutcome(
      context: _buildContext(arc, habits),
      combat: pending.spec,
      finishedEncounter: pending.encounter,
    );
    final wonBoss = pending.spec.tier == StoryCombatTier.legendary &&
        pending.encounter.status == CombatStatus.victory;
    await ref.read(storyRepositoryProvider).recordChapterBeat(
          currentArc: arc,
          locationName: outcomeScene.locationName,
          playerAction: pending.spec.reason,
          narration: outcomeScene.narration,
          triggerType: outcomeScene.triggerType,
          outcomeSummary: outcomeScene.memorySummary,
          memorySummary: outcomeScene.memorySummary,
          markBossDefeated: wonBoss,
        );
    if (!mounted) return;
    setState(() {
      _scene = outcomeScene;
      _lastSkillCheck = null;
      _lastSkillRoll = null;
      _loading = false;
    });
  }

  Future<void> _submitAction({
    required StoryArcState arc,
    required StoryHabitDigest habits,
    String? freeText,
    StoryChoiceOption? choice,
  }) async {
    if (_loading) return;
    final actionText = (freeText ?? choice?.actionPrompt ?? choice?.label ?? '')
        .trim();
    if (actionText.isEmpty && choice == null) return;

    setState(() => _loading = true);
    try {
      final narrator = ref.read(storyNarratorProvider);
      final response = await narrator.advanceScene(
        _buildContext(
          arc,
          habits,
          playerInput: freeText,
          selectedChoice: choice,
        ),
      );
      if (!mounted) return;
      _inputController.clear();

      if (response.triggerType == StoryTriggerType.skillCheck &&
          response.skillCheck != null) {
        await _runSkillCheckFlow(
          arc: arc,
          habits: habits,
          check: response.skillCheck!,
          actionLabel: choice?.label ?? actionText,
        );
        return;
      }

      if (response.triggerType == StoryTriggerType.combatTrigger &&
          response.combatTrigger != null) {
        await ref.read(storyRepositoryProvider).recordChapterBeat(
              currentArc: arc,
              locationName: response.locationName,
              playerAction: choice?.label ?? actionText,
              narration: response.narration,
              triggerType: response.triggerType,
              placeVisited: response.placeVisited,
              npcUpdate: response.npcUpdate,
              memorySummary: response.memorySummary,
            );
        if (!mounted) return;
        setState(() {
          _scene = response;
          _lastSkillCheck = null;
          _lastSkillRoll = null;
          _loading = false;
        });
        widget.onStartStoryCombat(response.combatTrigger!);
        return;
      }

      await ref.read(storyRepositoryProvider).recordChapterBeat(
            currentArc: arc,
            locationName: response.locationName,
            playerAction: choice?.label ?? actionText,
            narration: response.narration,
            triggerType: response.triggerType,
            placeVisited: response.placeVisited,
            npcUpdate: response.npcUpdate,
            memorySummary: response.memorySummary,
          );
      if (!mounted) return;
      setState(() {
        _scene = response;
        _lastSkillCheck = null;
        _lastSkillRoll = null;
        _loading = false;
      });
    } finally {
      if (mounted && _loading) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _runSkillCheckFlow({
    required StoryArcState arc,
    required StoryHabitDigest habits,
    required StorySkillCheckSpec check,
    required String actionLabel,
    bool isInspirationReroll = false,
  }) async {
    final sound = ref.read(soundServiceProvider);
    final forcedD20 = ref.read(testerModeProvider).forcedD20;
    final stats = _heroStats();

    final rolledNatural = await showInteractiveD20RollDialog(
      context: context,
      actionTitle: actionLabel,
      attribute: check.attribute,
      attributeModifier: stats.attackModifierFor(check.attribute),
      proficiencyBonus: stats.proficiencyBonus,
      targetNumber: check.difficultyClass,
      soundService: sound,
      isDifficultyClass: true,
      forcedD20: forcedD20,
    );
    if (rolledNatural == null || !mounted) {
      setState(() => _loading = false);
      return;
    }

    D20RollResult roll;
    if (isInspirationReroll && _lastSkillRoll != null) {
      final res = StoryEngine.rerollWithInspiration(
        hero: stats,
        attribute: check.attribute,
        difficultyClass: check.difficultyClass,
        availableInspiration: widget.char.inspirationCount,
        previousRoll: _lastSkillRoll!,
        forcedD20: rolledNatural,
      );
      roll = res.roll;
      if (res.spentInspiration && !widget.testerEnabled) {
        await ref
            .read(storyRepositoryProvider)
            .spendInspirationForReroll(check.attribute);
      }
    } else {
      roll = StoryEngine.resolveSkillCheck(
        hero: stats,
        attribute: check.attribute,
        difficultyClass: check.difficultyClass,
        forcedD20: rolledNatural,
      );
    }

    if (!mounted) return;
    final narrator = ref.read(storyNarratorProvider);
    final afterCheck = await narrator.narrateSkillCheckOutcome(
      context: _buildContext(arc, habits),
      check: check,
      roll: roll,
      usedInspirationReroll: isInspirationReroll,
    );

    await ref.read(storyRepositoryProvider).recordChapterBeat(
          currentArc: arc,
          locationName: afterCheck.locationName,
          playerAction: actionLabel,
          narration: afterCheck.narration,
          triggerType: afterCheck.triggerType,
          outcomeSummary: afterCheck.memorySummary,
          memorySummary: afterCheck.memorySummary,
        );
    if (!mounted) return;

    setState(() {
      _scene = afterCheck;
      _lastSkillCheck = check;
      _lastSkillRoll = roll;
      _lastSkillUsedInspiration = isInspirationReroll;
      _rollSeed++;
      _loading = false;
    });

    if (afterCheck.triggerType == StoryTriggerType.combatTrigger &&
        afterCheck.combatTrigger != null) {
      widget.onStartStoryCombat(afterCheck.combatTrigger!);
    }
  }

  void _openChronicleSheet(BuildContext context, String weekKey) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppTheme.castIron,
      isScrollControlled: true,
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.72,
          maxChildSize: 0.92,
          minChildSize: 0.4,
          expand: false,
          builder: (_, scrollCtrl) {
            return Consumer(
              builder: (context, ref, _) {
                final chaptersAsync =
                    ref.watch(weeklyStoryChaptersProvider(weekKey));
                final l10n = context.l10n;
                final display = DisplayFont.from(context);
                return Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${l10n.storyChronicleTitle} · $weekKey',
                        style: display.style(24, color: AppTheme.emberGold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: chaptersAsync.when(
                          loading: () =>
                              const Center(child: CircularProgressIndicator()),
                          error: (e, _) => Text('$e'),
                          data: (chapters) {
                            if (chapters.isEmpty) {
                              return Center(
                                child: Text(
                                  l10n.storyChronicleEmpty,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: AppTheme.dullSilver,
                                  ),
                                ),
                              );
                            }
                            return ListView.separated(
                              controller: scrollCtrl,
                              itemCount: chapters.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 8),
                              itemBuilder: (_, i) {
                                final c = chapters[i];
                                return PixelFrame(
                                  color: AppTheme.obsidianBlack,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      PixelTag(
                                        text: c.locationName,
                                        color: AppTheme.emberGold,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        '▶ ${c.playerAction}',
                                        style: const TextStyle(
                                          color: AppTheme.dullSilver,
                                          fontSize: 11,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        c.narration,
                                        style: const TextStyle(
                                          color: AppTheme.ashWhite,
                                          fontSize: 12,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final arcAsync = ref.watch(weeklyStoryArcProvider);
    final bundle = arcAsync.valueOrNull;
    if (arcAsync.hasError && bundle == null) {
      return Center(child: Text('${arcAsync.error}'));
    }
    if (bundle == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final arc = bundle.arc;
    final habits = bundle.habits;
    final chaptersCount =
        ref.watch(weeklyStoryChaptersProvider(arc.weekKey)).valueOrNull?.length ??
            0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _consumeCombatOutcomeIfPending(arc, habits);
      _ensureOpeningScene(arc, habits);
    });

    final boss = arc.weeklyBoss;
    final canReroll = _lastSkillCheck != null &&
        _lastSkillRoll != null &&
        !_lastSkillRoll!.isHit &&
        !_lastSkillUsedInspiration &&
        widget.char.inspirationCount > 0;

    return ListView(
          scrollCacheExtent: const ScrollCacheExtent.pixels(1800),
          padding: const EdgeInsets.all(12),
          children: [
            // --- Top Navigation & Chronicle Log -----------------------------
            Row(
              children: [
                TextButton.icon(
                  key: const Key('story_back_to_hub_btn'),
                  onPressed: widget.onBackToHub,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: Text(l10n.combatBackToHub),
                ),
                const Spacer(),
                PixelFrame(
                  key: const Key('story_chronicle_btn'),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  onTap: () => _openChronicleSheet(context, arc.weekKey),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const PixelIcon(
                        PixelIcons.scroll,
                        size: 16,
                        color: AppTheme.emberGold,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        l10n.storyChronicleButton(chaptersCount),
                        style: display.style(16, color: AppTheme.emberGold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // --- Weekly Legendary Boss & Weakness Seals Card ----------------
            PixelFrame(
              color: AppTheme.darkBlood,
              highlight: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OpponentAvatar(
                        opponentId: boss.id,
                        pixelSize: 2.0,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PixelTag(
                              text: l10n.storyWeeklyBossHeader(arc.weekKey),
                              color: AppTheme.emberGold,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              game.legendaryBossName(boss.id),
                              style: display.style(22, color: AppTheme.emberGold),
                            ),
                            Text(
                              game.legendaryBossClass(boss.id),
                              style: const TextStyle(
                                color: AppTheme.dullSilver,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    game.legendaryBossLore(boss.id),
                    style: const TextStyle(
                      color: AppTheme.ashWhite,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.storyWeaknessSealsLabel(arc.weaknessStacks),
                        style: display.style(16, color: AppTheme.emberGold),
                      ),
                      if (arc.bossDefeated)
                        PixelTag(
                          text: l10n.storyBossDefeatedBadge,
                          color: AppTheme.emberGold,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  SegmentedBar(
                    value: arc.weaknessStacks / 7.0,
                    color: AppTheme.emberGold,
                    segments: 7,
                    height: 8,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.storyWeaknessSealsHint,
                    style: const TextStyle(
                      color: AppTheme.darkAsh,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 10),
                  PixelButton(
                    key: const Key('story_challenge_boss_btn'),
                    label: l10n.storyChallengeWeeklyBoss,
                    onPressed: _loading
                        ? null
                        : () => widget.onStartStoryCombat(
                              StoryCombatSpec(
                                tier: StoryCombatTier.legendary,
                                opponentId: boss.id,
                                weaknessStacks: arc.weaknessStacks,
                                reason: l10n.storyChallengeWeeklyBoss,
                              ),
                            ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            // --- Latest Story D20 Check Banner + Inspiration Re-roll --------
            if (_lastSkillRoll != null) ...[
              D20RollerBanner(
                roll: _lastSkillRoll!,
                animationSeed: _rollSeed,
                isDifficultyClass: true,
              ),
              if (canReroll) ...[
                const SizedBox(height: 8),
                PixelButton(
                  key: const Key('story_reroll_inspiration_btn'),
                  label: l10n.storyRerollInspiration(
                    widget.char.inspirationCount,
                  ),
                  onPressed: _loading
                      ? null
                      : () => _runSkillCheckFlow(
                            arc: arc,
                            habits: habits,
                            check: _lastSkillCheck!,
                            actionLabel: _lastSkillCheck!.reason,
                            isInspirationReroll: true,
                          ),
                ),
              ],
              const SizedBox(height: 12),
            ],

            // --- Current Game Master Scene & Interactive Choices ------------
            PixelFrame(
              key: const Key('story_scene_card'),
              child: _loading || _scene == null
                  ? const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            PixelTag(
                              text: _scene!.locationName,
                              color: AppTheme.emberGold,
                            ),
                            const Spacer(),
                            PixelTag(
                              key: const Key('story_narrator_source_tag'),
                              text: _scene!.isAiGenerated
                                  ? l10n.storyModeAiBadge
                                  : l10n.storyModeOfflineBadge,
                              color: _scene!.isAiGenerated
                                  ? AppTheme.emberGold
                                  : AppTheme.dullSilver,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _scene!.narration,
                          key: const Key('story_narration_text'),
                          style: const TextStyle(
                            color: AppTheme.ashWhite,
                            fontSize: 13,
                            height: 1.45,
                          ),
                        ),
                        const SizedBox(height: 14),
                        for (final opt in _scene!.choices) ...[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: PixelFrame(
                              key: Key('story_choice_${opt.id}'),
                              color: AppTheme.obsidianBlack,
                              onTap: () => _submitAction(
                                arc: arc,
                                habits: habits,
                                choice: opt,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      opt.label,
                                      style: const TextStyle(
                                        color: AppTheme.emberGold,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: AppTheme.dullSilver,
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                key: const Key('story_free_input'),
                                controller: _inputController,
                                style: const TextStyle(
                                  color: AppTheme.ashWhite,
                                  fontSize: 13,
                                ),
                                decoration: InputDecoration(
                                  hintText: l10n.storyInputHint,
                                  isDense: true,
                                  border: const OutlineInputBorder(),
                                ),
                                onSubmitted: (txt) => _submitAction(
                                  arc: arc,
                                  habits: habits,
                                  freeText: txt,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 78,
                              child: PixelButton(
                                key: const Key('story_send_action_btn'),
                                label: l10n.storySendAction,
                                onPressed: () => _submitAction(
                                  arc: arc,
                                  habits: habits,
                                  freeText: _inputController.text,
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
