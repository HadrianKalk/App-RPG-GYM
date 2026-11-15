import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_button.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../app/ui/pixel_sprite.dart';
import '../../../app/ui/pixel_tag.dart';
import '../../../app/ui/segmented_bar.dart';
import '../../../core/game/attributes.dart';
import '../../../core/game/combat.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../data/repositories/combat_repository.dart';
import '../../../data/repositories/providers.dart';
import '../../../l10n/l10n.dart';

/// Forge Arena screen: 1v1 NPC duels and multi-round Tournaments (Gauntlet).
///
/// Combats never grant XP (Decision #40); victories unlock titles and cosmetics.
class ArenaScreen extends ConsumerStatefulWidget {
  const ArenaScreen({super.key});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen> {
  CombatEncounter? _encounter;
  TournamentRun? _tournamentRun;
  bool _showTournamentsTab = false;
  bool _firstUnlockOnLastVictory = false;
  bool _busy = false;

  CombatStats _buildHeroStats(CharacterState char) {
    return CombatStats.fromHero(
      level: char.levelInfo.level,
      characterClass: char.characterClass,
      attributeScores: {
        for (final entry in char.attributeProgressions.entries)
          entry.key: entry.value.score,
      },
    );
  }

  Future<void> _startChallenge(
    ArenaOpponent opponent,
    CharacterState char,
  ) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final consumed =
          await ref.read(combatRepositoryProvider).consumeDailyEntry();
      if (!consumed) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.arenaNoTokens)),
          );
        }
        return;
      }

      final started = CombatEngine.start(
        hero: _buildHeroStats(char),
        opponent: opponent,
        availableInspiration: char.inspirationCount,
      );

      if (mounted) {
        setState(() {
          _tournamentRun = null;
          _encounter = started;
          _firstUnlockOnLastVictory = false;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _startTournament(
    TournamentDefinition tournament,
    CharacterState char,
  ) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final consumed =
          await ref.read(combatRepositoryProvider).consumeDailyEntry();
      if (!consumed) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.arenaNoTokens)),
          );
        }
        return;
      }

      final run = CombatEngine.startTournament(
        hero: _buildHeroStats(char),
        tournament: tournament,
        availableInspiration: char.inspirationCount,
      );

      if (mounted) {
        setState(() {
          _tournamentRun = run;
          _encounter = run.encounter;
          _firstUnlockOnLastVictory = false;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _executeAction(CombatAction action) async {
    final current = _encounter;
    if (current == null ||
        current.status != CombatStatus.ongoing ||
        _busy) {
      return;
    }

    final next = CombatEngine.executeTurn(current, action);
    final activeRun = _tournamentRun;

    if (activeRun != null) {
      final updatedRun = TournamentRun(
        tournament: activeRun.tournament,
        rounds: activeRun.rounds,
        roundIndex: activeRun.roundIndex,
        encounter: next,
      );
      setState(() {
        _tournamentRun = updatedRun;
        _encounter = next;
      });

      // Only finalize tournament when defeated or when the FINAL round is won.
      if (next.status == CombatStatus.defeat ||
          updatedRun.isTournamentVictory) {
        setState(() => _busy = true);
        try {
          final firstUnlock = await ref
              .read(combatRepositoryProvider)
              .finishTournament(
                tournament: updatedRun.tournament,
                victory: updatedRun.isTournamentVictory,
                spentInspiration: next.inspirationUsed,
              );
          if (mounted) {
            setState(() => _firstUnlockOnLastVictory = firstUnlock);
          }
        } finally {
          if (mounted) setState(() => _busy = false);
        }
      }
      return;
    }

    setState(() => _encounter = next);

    if (next.status != CombatStatus.ongoing) {
      setState(() => _busy = true);
      try {
        final firstUnlock =
            await ref.read(combatRepositoryProvider).finishMatch(
                  opponent: next.opponent,
                  victory: next.status == CombatStatus.victory,
                  spentInspiration: next.inspirationUsed,
                );
        if (mounted) {
          setState(() => _firstUnlockOnLastVictory = firstUnlock);
        }
      } finally {
        if (mounted) setState(() => _busy = false);
      }
    }
  }

  void _advanceTournamentRound() {
    final run = _tournamentRun;
    if (run == null || !run.isRoundVictory) return;
    final nextRun = CombatEngine.advanceTournamentRound(run);
    setState(() {
      _tournamentRun = nextRun;
      _encounter = nextRun.encounter;
    });
  }

  Future<void> _equipReward(CombatReward reward) async {
    final heroRepo = ref.read(heroRepositoryProvider);
    await heroRepo.setEquippedTitle(reward.titleId);
    await heroRepo.setEquippedCosmetic(reward.cosmeticId);
    if (mounted) {
      setState(() {
        _encounter = null;
        _tournamentRun = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final charAsync = ref.watch(characterStreamProvider);
    final arenaAsync = ref.watch(arenaStateStreamProvider);
    final hero = ref.watch(heroStreamProvider).valueOrNull;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          key: const Key('arena_back_btn'),
          icon: const PixelIcon(PixelIcons.back, color: AppTheme.emberGold),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(l10n.arenaScreenTitle),
      ),
      body: charAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.loadError('$e'))),
        data: (char) => arenaAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.loadError('$e'))),
          data: (arena) {
            if (_encounter != null) {
              return _ActiveCombatView(
                encounter: _encounter!,
                tournamentRun: _tournamentRun,
                heroName: hero?.name ?? l10n.navHero,
                firstUnlock: _firstUnlockOnLastVictory,
                busy: _busy,
                onAction: _executeAction,
                onNextTournamentRound: _advanceTournamentRound,
                onEquipReward: () => _equipReward(_encounter!.opponent.reward),
                onBackToRoster: () => setState(() {
                  _encounter = null;
                  _tournamentRun = null;
                }),
              );
            }
            return _ArenaRosterView(
              arena: arena,
              char: char,
              busy: _busy,
              showTournamentsTab: _showTournamentsTab,
              onSelectTab: (tournaments) =>
                  setState(() => _showTournamentsTab = tournaments),
              onChallenge: (npc) => _startChallenge(npc, char),
              onEnterTournament: (t) => _startTournament(t, char),
            );
          },
        ),
      ),
    );
  }
}

class _ArenaRosterView extends StatelessWidget {
  const _ArenaRosterView({
    required this.arena,
    required this.char,
    required this.busy,
    required this.showTournamentsTab,
    required this.onSelectTab,
    required this.onChallenge,
    required this.onEnterTournament,
  });

  final ArenaState arena;
  final CharacterState char;
  final bool busy;
  final bool showTournamentsTab;
  final ValueChanged<bool> onSelectTab;
  final ValueChanged<ArenaOpponent> onChallenge;
  final ValueChanged<TournamentDefinition> onEnterTournament;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final hasTokens = arena.entriesRemainingToday > 0;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        PixelFrame(
          highlight: true,
          color: AppTheme.darkBlood,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PixelIcon(
                    PixelIcons.swords,
                    size: 26,
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(l10n.arenaBannerTitle, style: display.style(28)),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.arenaTokensExplain,
                style: const TextStyle(color: AppTheme.ashWhite, fontSize: 12),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  PixelTag(
                    text: l10n.arenaTokensBadge(
                      arena.entriesRemainingToday,
                      arena.totalEntriesToday,
                    ),
                    color: hasTokens
                        ? AppTheme.emberGold
                        : AppTheme.bloodCrimson,
                  ),
                  PixelTag(
                    text: l10n.arenaChampionsBadge(
                      arena.defeatedChampionsCount,
                      ArenaCatalog.opponents.length,
                    ),
                    color: AppTheme.dullSilver,
                  ),
                ],
              ),
              if (!hasTokens) ...[
                const SizedBox(height: 8),
                Text(
                  l10n.arenaNoTokens,
                  style: const TextStyle(
                    color: AppTheme.emberGold,
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 10),

        // --- Mode Switcher: 1v1 Duels vs Tournaments -----------------------
        Row(
          children: [
            Expanded(
              child: PixelButton(
                key: const Key('arena_tab_duels'),
                label: l10n.arenaTabDuels,
                variant: !showTournamentsTab
                    ? PixelButtonVariant.primary
                    : PixelButtonVariant.secondary,
                onPressed: () => onSelectTab(false),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PixelButton(
                key: const Key('arena_tab_tournaments'),
                label: l10n.arenaTabTournaments,
                variant: showTournamentsTab
                    ? PixelButtonVariant.primary
                    : PixelButtonVariant.secondary,
                onPressed: () => onSelectTab(true),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (!showTournamentsTab)
          for (final npc in ArenaCatalog.opponents) ...[
            _OpponentCard(
              npc: npc,
              victories: arena.victoriesByOpponent[npc.id] ?? 0,
              canChallenge: hasTokens && !busy,
              game: game,
              onChallenge: () => onChallenge(npc),
            ),
            const SizedBox(height: 10),
          ]
        else
          for (final t in TournamentCatalog.tournaments) ...[
            _TournamentCard(
              tournament: t,
              victories: arena.victoriesByOpponent[t.id] ?? 0,
              canEnter: hasTokens && !busy,
              game: game,
              onEnter: () => onEnterTournament(t),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }
}

class _OpponentCard extends StatelessWidget {
  const _OpponentCard({
    required this.npc,
    required this.victories,
    required this.canChallenge,
    required this.game,
    required this.onChallenge,
  });

  final ArenaOpponent npc;
  final int victories;
  final bool canChallenge;
  final GameText game;
  final VoidCallback onChallenge;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final defeated = victories > 0;

    return PixelFrame(
      highlight: defeated,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.arenaNpcName(npc.id),
                      style: display.style(
                        24,
                        color: defeated ? AppTheme.emberGold : AppTheme.ashWhite,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      game.arenaNpcLore(npc.id),
                      style: const TextStyle(
                        color: AppTheme.dullSilver,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PixelTag(
                    text: l10n.arenaRecommendedLevel(npc.recommendedLevel),
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(height: 4),
                  PixelTag(
                    text: l10n.arenaVictoriesCount(victories),
                    color: defeated
                        ? AppTheme.attributeColor(Attribute.constitution)
                        : AppTheme.darkAsh,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${l10n.combatHpLabel} ${npc.maxHp} · ATQ ${npc.attack} · DEF ${npc.defense}',
            style: const TextStyle(color: AppTheme.darkAsh, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.arenaRewardLabel(
              game.combatTitle(npc.reward.titleId),
              game.combatCosmetic(npc.reward.cosmeticId),
            ),
            style: const TextStyle(
              color: AppTheme.emberGold,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          PixelButton(
            key: Key('arena_challenge_${npc.id}'),
            label: l10n.arenaChallengeButton,
            variant: defeated
                ? PixelButtonVariant.secondary
                : PixelButtonVariant.primary,
            onPressed: canChallenge ? onChallenge : null,
          ),
        ],
      ),
    );
  }
}

class _TournamentCard extends StatelessWidget {
  const _TournamentCard({
    required this.tournament,
    required this.victories,
    required this.canEnter,
    required this.game,
    required this.onEnter,
  });

  final TournamentDefinition tournament;
  final int victories;
  final bool canEnter;
  final GameText game;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final won = victories > 0;
    final rosterLine = tournament.opponentIds
        .map(game.arenaNpcName)
        .join(' → ');

    return PixelFrame(
      highlight: won,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      game.tournamentName(tournament.id),
                      style: display.style(
                        24,
                        color: won ? AppTheme.emberGold : AppTheme.ashWhite,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      game.tournamentLore(tournament.id),
                      style: const TextStyle(
                        color: AppTheme.dullSilver,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  PixelTag(
                    text: l10n.arenaRecommendedLevel(
                      tournament.recommendedLevel,
                    ),
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(height: 4),
                  PixelTag(
                    text: l10n.tournamentRoundsBadge(
                      tournament.opponentIds.length,
                    ),
                    color: AppTheme.dullSilver,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            rosterLine,
            style: const TextStyle(color: AppTheme.darkAsh, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.arenaRewardLabel(
              game.combatTitle(tournament.reward.titleId),
              game.combatCosmetic(tournament.reward.cosmeticId),
            ),
            style: const TextStyle(
              color: AppTheme.emberGold,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          PixelButton(
            key: Key('tournament_enter_${tournament.id}'),
            label: l10n.tournamentEnterButton,
            variant: won
                ? PixelButtonVariant.secondary
                : PixelButtonVariant.primary,
            onPressed: canEnter ? onEnter : null,
          ),
        ],
      ),
    );
  }
}

class _ActiveCombatView extends StatelessWidget {
  const _ActiveCombatView({
    required this.encounter,
    required this.tournamentRun,
    required this.heroName,
    required this.firstUnlock,
    required this.busy,
    required this.onAction,
    required this.onNextTournamentRound,
    required this.onEquipReward,
    required this.onBackToRoster,
  });

  final CombatEncounter encounter;
  final TournamentRun? tournamentRun;
  final String heroName;
  final bool firstUnlock;
  final bool busy;
  final ValueChanged<CombatAction> onAction;
  final VoidCallback onNextTournamentRound;
  final VoidCallback onEquipReward;
  final VoidCallback onBackToRoster;

  String _intentText(BuildContext context, EnemyIntent intent) {
    final l10n = context.l10n;
    return switch (intent) {
      EnemyIntent.strike => l10n.combatIntentStrike,
      EnemyIntent.heavyBlow => l10n.combatIntentHeavy,
      EnemyIntent.guard => l10n.combatIntentGuard,
    };
  }

  String _formatLog(BuildContext context, CombatLogEntry entry) {
    final l10n = context.l10n;
    final game = context.game;
    final critSuffix = entry.isCritical ? ' (CRIT!)' : '';
    final skillLabel =
        entry.skillId != null ? game.skillName(entry.skillId!) : '';

    return switch (entry.kind) {
      CombatLogKind.heroBasicStrike =>
        l10n.combatLogHeroBasic(entry.turn, entry.damage, critSuffix),
      CombatLogKind.heroClassSkill => entry.heal > 0
          ? l10n.combatLogHeroSkillHeal(
              entry.turn,
              skillLabel,
              entry.damage,
              entry.heal,
            )
          : l10n.combatLogHeroSkill(
              entry.turn,
              skillLabel,
              entry.damage,
              critSuffix,
            ),
      CombatLogKind.heroDefend =>
        l10n.combatLogHeroDefend(entry.turn, entry.heal),
      CombatLogKind.heroInspirationStrike =>
        l10n.combatLogHeroInspiration(entry.turn, entry.damage),
      CombatLogKind.enemyStrike =>
        l10n.combatLogEnemyStrike(entry.turn, entry.damage),
      CombatLogKind.enemyHeavyBlow =>
        l10n.combatLogEnemyHeavy(entry.turn, entry.damage),
      CombatLogKind.enemyGuard =>
        l10n.combatLogEnemyGuard(entry.turn, entry.heal),
      CombatLogKind.enemyStunned => l10n.combatLogEnemyStunned(entry.turn),
      CombatLogKind.enemyDodged => l10n.combatLogEnemyDodged(entry.turn),
      CombatLogKind.heroDodged => l10n.combatLogHeroDodged(entry.turn),
      CombatLogKind.victory => l10n.combatVictoryTitle,
      CombatLogKind.defeat => l10n.combatDefeatTitle,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final npc = encounter.opponent;
    final skill = encounter.skill;
    final ongoing = encounter.status == CombatStatus.ongoing;
    final isRoundVictory = tournamentRun != null && tournamentRun!.isRoundVictory;

    final skillLabel = encounter.heroSkillCooldown > 0
        ? l10n.combatActionSkillCooldown(
            game.skillName(skill.id),
            encounter.heroSkillCooldown,
          )
        : l10n.combatActionSkill(game.skillName(skill.id), skill.focusCost);

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // --- Opponent Panel -------------------------------------------------
        PixelFrame(
          highlight: encounter.enemyIntent == EnemyIntent.heavyBlow,
          color: encounter.enemyIntent == EnemyIntent.heavyBlow
              ? AppTheme.darkBlood
              : AppTheme.castIron,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      game.arenaNpcName(npc.id),
                      style: display.style(26, color: AppTheme.emberGold),
                    ),
                  ),
                  if (tournamentRun != null) ...[
                    PixelTag(
                      text: l10n.tournamentRoundProgress(
                        tournamentRun!.currentRoundNumber,
                        tournamentRun!.totalRounds,
                      ),
                      color: AppTheme.emberGold,
                    ),
                    const SizedBox(width: 6),
                  ],
                  PixelTag(
                    text: l10n.combatTurnLabel(encounter.turn),
                    color: AppTheme.dullSilver,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.combatHpLabel,
                    style: const TextStyle(
                      color: AppTheme.dullSilver,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${encounter.enemyHp}/${npc.maxHp}',
                    style: display.style(18, color: AppTheme.bloodCrimson),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SegmentedBar(
                value: npc.maxHp > 0 ? encounter.enemyHp / npc.maxHp : 0,
                segments: 20,
                color: AppTheme.bloodCrimson,
              ),
              const SizedBox(height: 8),
              Text(
                _intentText(context, encounter.enemyIntent),
                style: TextStyle(
                  color: encounter.enemyIntent == EnemyIntent.heavyBlow
                      ? AppTheme.emberGold
                      : AppTheme.dullSilver,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // --- Hero Panel -----------------------------------------------------
        PixelFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PixelSprite(
                    rows: HeroSprites.idle,
                    palette: HeroSprites.palette,
                    pixelSize: 3,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(heroName, style: display.style(24)),
                        Text(
                          '${game.className(encounter.hero.characterClass)} · ${l10n.characterLevel(encounter.hero.level)}',
                          style: const TextStyle(
                            color: AppTheme.dullSilver,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.combatHpLabel,
                    style: const TextStyle(
                      color: AppTheme.dullSilver,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${encounter.heroHp}/${encounter.hero.maxHp}',
                    style: display.style(
                      18,
                      color: AppTheme.attributeColor(Attribute.constitution),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SegmentedBar(
                value: encounter.hero.maxHp > 0
                    ? encounter.heroHp / encounter.hero.maxHp
                    : 0,
                segments: 20,
                color: AppTheme.attributeColor(Attribute.constitution),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.combatFocusLabel,
                    style: const TextStyle(
                      color: AppTheme.dullSilver,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${encounter.heroFocus}/${encounter.hero.maxFocus}',
                    style: display.style(
                      18,
                      color: AppTheme.attributeColor(Attribute.intelligence),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SegmentedBar(
                value: encounter.hero.maxFocus > 0
                    ? encounter.heroFocus / encounter.hero.maxFocus
                    : 0,
                segments: 16,
                color: AppTheme.attributeColor(Attribute.intelligence),
                height: 8,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // --- Actions or Outcome Banner -------------------------------------
        if (ongoing) ...[
          PixelButton(
            key: const Key('combat_action_basic'),
            label: l10n.combatActionBasic,
            onPressed: busy ? null : () => onAction(CombatAction.basicStrike),
          ),
          const SizedBox(height: 8),
          Tooltip(
            message: game.skillDescription(skill.id),
            child: PixelButton(
              key: const Key('combat_action_skill'),
              label: skillLabel,
              variant: PixelButtonVariant.secondary,
              onPressed: (!busy && encounter.canUseClassSkill)
                  ? () => onAction(CombatAction.classSkill)
                  : null,
            ),
          ),
          const SizedBox(height: 8),
          PixelButton(
            key: const Key('combat_action_defend'),
            label: l10n.combatActionDefend,
            variant: PixelButtonVariant.secondary,
            onPressed: busy ? null : () => onAction(CombatAction.defend),
          ),
          const SizedBox(height: 8),
          PixelButton(
            key: const Key('combat_action_inspiration'),
            label: l10n.combatActionInspiration(encounter.availableInspiration),
            variant: PixelButtonVariant.secondary,
            onPressed: (!busy && encounter.canUseInspiration)
                ? () => onAction(CombatAction.heroicInspiration)
                : null,
          ),
        ] else if (isRoundVictory) ...[
          PixelFrame(
            highlight: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tournamentNextRoundTitle(
                    tournamentRun!.currentRoundNumber,
                  ),
                  style: display.style(28, color: AppTheme.emberGold),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.tournamentNextRoundBody,
                  style: const TextStyle(
                    color: AppTheme.ashWhite,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                PixelButton(
                  key: const Key('tournament_next_round_btn'),
                  label: l10n.tournamentNextRoundButton(
                    tournamentRun!.currentRoundNumber + 1,
                  ),
                  onPressed: busy ? null : onNextTournamentRound,
                ),
              ],
            ),
          ),
        ] else if (encounter.status == CombatStatus.victory) ...[
          PixelFrame(
            highlight: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tournamentRun != null
                      ? l10n.tournamentVictoryTitle
                      : l10n.combatVictoryTitle,
                  style: display.style(30, color: AppTheme.emberGold),
                ),
                const SizedBox(height: 4),
                Text(
                  firstUnlock
                      ? l10n.combatUnlockedReward
                      : l10n.combatAlreadyUnlocked,
                  style: const TextStyle(
                    color: AppTheme.dullSilver,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    PixelTag(
                      text: game.combatTitle(npc.reward.titleId),
                      color: AppTheme.emberGold,
                    ),
                    PixelTag(
                      text: game.combatCosmetic(npc.reward.cosmeticId),
                      color: AppTheme.attributeColor(Attribute.charisma),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                PixelButton(
                  key: const Key('combat_equip_reward_btn'),
                  label: l10n.combatEquipNow,
                  onPressed: busy ? null : onEquipReward,
                ),
                const SizedBox(height: 8),
                PixelButton(
                  key: const Key('combat_back_to_arena_btn'),
                  label: l10n.combatBackToArena,
                  variant: PixelButtonVariant.secondary,
                  onPressed: busy ? null : onBackToRoster,
                ),
              ],
            ),
          ),
        ] else ...[
          PixelFrame(
            color: AppTheme.darkBlood,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.combatDefeatTitle,
                  style: display.style(28, color: AppTheme.emberGold),
                ),
                const SizedBox(height: 6),
                Text(
                  l10n.combatDefeatBody,
                  style: const TextStyle(
                    color: AppTheme.ashWhite,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 12),
                PixelButton(
                  key: const Key('combat_back_to_arena_btn'),
                  label: l10n.combatBackToArena,
                  onPressed: busy ? null : onBackToRoster,
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 12),

        // --- Battle Log -----------------------------------------------------
        if (encounter.log.isNotEmpty)
          PixelFrame(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.combatLogTitle,
                  style: display.style(20, color: AppTheme.emberGold),
                ),
                const SizedBox(height: 6),
                for (final entry in encounter.log.reversed.take(10))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      _formatLog(context, entry),
                      style: const TextStyle(
                        color: AppTheme.dullSilver,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
