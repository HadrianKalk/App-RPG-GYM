import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/game_app_bar.dart';
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
import '../../settings/presentation/tester_panel_sheet.dart';
import 'd20_roller_widget.dart';

/// Sub-modes selectable from the Combat Hub.
enum CombatHubMode { duels, tournaments, dungeons }

/// Dedicated Combat Tab: Combat Hub with Mode Selection rectangles (Story Mode
/// locked at top, 1v1 Duels, Tournaments, and Dungeons), animated D20 combat,
/// and quick access to the Tester Mode sandbox.
class ArenaScreen extends ConsumerStatefulWidget {
  const ArenaScreen({super.key});

  @override
  ConsumerState<ArenaScreen> createState() => _ArenaScreenState();
}

class _ArenaScreenState extends ConsumerState<ArenaScreen> {
  CombatHubMode? _selectedMode;
  CombatEncounter? _encounter;
  TournamentRun? _tournamentRun;
  DungeonRun? _dungeonRun;
  bool _firstUnlockOnLastVictory = false;
  bool _busy = false;
  int _rollAnimationCounter = 0;

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

  Future<bool> _tryConsumeToken() async {
    final tester = ref.read(testerModeProvider);
    if (tester.enabled && tester.infiniteCombatTokens) {
      return true;
    }
    return ref.read(combatRepositoryProvider).consumeDailyEntry();
  }

  Future<void> _startChallenge(
    ArenaOpponent opponent,
    CharacterState char,
  ) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final consumed = await _tryConsumeToken();
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
          _dungeonRun = null;
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
      final consumed = await _tryConsumeToken();
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
          _dungeonRun = null;
          _tournamentRun = run;
          _encounter = run.encounter;
          _firstUnlockOnLastVictory = false;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _startDungeon(
    DungeonDefinition dungeon,
    CharacterState char,
  ) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final consumed = await _tryConsumeToken();
      if (!consumed) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.arenaNoTokens)),
          );
        }
        return;
      }

      final run = CombatEngine.startDungeon(
        hero: _buildHeroStats(char),
        dungeon: dungeon,
        availableInspiration: char.inspirationCount,
      );

      if (mounted) {
        setState(() {
          _tournamentRun = null;
          _encounter = null;
          _dungeonRun = run;
          _firstUnlockOnLastVictory = false;
        });
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _rollDungeonRoomCheck() {
    final run = _dungeonRun;
    if (run == null || run.inBossPhase || run.roomResolved || _busy) return;
    final forced = ref.read(testerModeProvider).forcedD20;
    final updated = CombatEngine.resolveDungeonRoom(run, forcedD20: forced);
    setState(() {
      _rollAnimationCounter++;
      _dungeonRun = updated;
    });
  }

  void _bypassDungeonRoom() {
    final run = _dungeonRun;
    if (run == null || run.inBossPhase || run.roomResolved || _busy) return;
    final updated = CombatEngine.bypassDungeonRoom(run);
    setState(() {
      _dungeonRun = updated;
    });
  }

  void _advanceDungeon() {
    final run = _dungeonRun;
    if (run == null || !run.roomResolved || run.inBossPhase || _busy) return;
    final nextRun = CombatEngine.advanceDungeon(run);
    setState(() {
      _dungeonRun = nextRun;
      if (nextRun.inBossPhase) {
        _encounter = nextRun.bossEncounter;
      }
    });
  }

  Future<void> _executeAction(CombatAction action) async {
    final current = _encounter;
    if (current == null ||
        current.status != CombatStatus.ongoing ||
        _busy) {
      return;
    }

    final forcedD20 = ref.read(testerModeProvider).forcedD20;
    final next = CombatEngine.executeTurn(
      current,
      action,
      forcedD20: forcedD20,
    );
    final activeTournament = _tournamentRun;
    final activeDungeon = _dungeonRun;

    if (activeTournament != null) {
      final updatedRun = TournamentRun(
        tournament: activeTournament.tournament,
        rounds: activeTournament.rounds,
        roundIndex: activeTournament.roundIndex,
        encounter: next,
      );
      setState(() {
        _rollAnimationCounter++;
        _tournamentRun = updatedRun;
        _encounter = next;
      });

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

    if (activeDungeon != null) {
      final updatedDungeon = DungeonRun(
        dungeon: activeDungeon.dungeon,
        hero: activeDungeon.hero,
        roomIndex: activeDungeon.roomIndex,
        heroHp: next.heroHp,
        heroFocus: next.heroFocus,
        blessingsEarned: activeDungeon.blessingsEarned,
        availableInspiration: next.availableInspiration,
        roomResolved: true,
        bossEncounter: next,
      );
      setState(() {
        _rollAnimationCounter++;
        _dungeonRun = updatedDungeon;
        _encounter = next;
      });

      if (next.status != CombatStatus.ongoing) {
        setState(() => _busy = true);
        try {
          final firstUnlock = await ref
              .read(combatRepositoryProvider)
              .finishDungeon(
                dungeon: updatedDungeon.dungeon,
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
      return;
    }

    setState(() {
      _rollAnimationCounter++;
      _encounter = next;
    });

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
        _dungeonRun = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final charAsync = ref.watch(characterStreamProvider);
    final arenaAsync = ref.watch(arenaStateStreamProvider);
    final hero = ref.watch(heroStreamProvider).valueOrNull;
    final tester = ref.watch(testerModeProvider);

    return Scaffold(
      appBar: GameAppBar(title: l10n.combatHubTitle),
      body: charAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.loadError('$e'))),
        data: (char) => arenaAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.loadError('$e'))),
          data: (arena) {
            if (_dungeonRun != null && !_dungeonRun!.inBossPhase) {
              return _ActiveDungeonRoomView(
                run: _dungeonRun!,
                rollSeed: _rollAnimationCounter,
                busy: _busy,
                onRollCheck: _rollDungeonRoomCheck,
                onBypass: _bypassDungeonRoom,
                onAdvance: _advanceDungeon,
                onBackToRoster: () => setState(() {
                  _dungeonRun = null;
                  _encounter = null;
                }),
              );
            }

            if (_encounter != null) {
              return _ActiveCombatView(
                encounter: _encounter!,
                tournamentRun: _tournamentRun,
                dungeonRun: _dungeonRun,
                heroName: hero?.name ?? l10n.navHero,
                firstUnlock: _firstUnlockOnLastVictory,
                rollSeed: _rollAnimationCounter,
                busy: _busy,
                onAction: _executeAction,
                onNextTournamentRound: _advanceTournamentRound,
                onEquipReward: () => _equipReward(_encounter!.opponent.reward),
                onBackToRoster: () => setState(() {
                  _encounter = null;
                  _tournamentRun = null;
                  _dungeonRun = null;
                }),
              );
            }

            if (_selectedMode == null) {
              return _CombatHubView(
                arena: arena,
                testerEnabled: tester.enabled,
                onOpenTester: () => showTesterPanelSheet(context),
                onSelectMode: (mode) => setState(() => _selectedMode = mode),
              );
            }

            return _ArenaRosterView(
              arena: arena,
              char: char,
              busy: _busy,
              testerEnabled: tester.enabled,
              selectedMode: _selectedMode!,
              onSelectMode: (mode) => setState(() => _selectedMode = mode),
              onBackToHub: () => setState(() => _selectedMode = null),
              onOpenTester: () => showTesterPanelSheet(context),
              onChallenge: (npc) => _startChallenge(npc, char),
              onEnterTournament: (t) => _startTournament(t, char),
              onEnterDungeon: (d) => _startDungeon(d, char),
            );
          },
        ),
      ),
    );
  }
}

/// Top-level Combat Hub presenting the 4 Mode Selection rectangles:
/// 1. Story Mode (top, emphasized, locked — coming in Phase 2)
/// 2. 1v1 Duel Arena
/// 3. Forge Tournaments (Gauntlet)
/// 4. Deep Dungeons
class _CombatHubView extends StatelessWidget {
  const _CombatHubView({
    required this.arena,
    required this.testerEnabled,
    required this.onOpenTester,
    required this.onSelectMode,
  });

  final ArenaState arena;
  final bool testerEnabled;
  final VoidCallback onOpenTester;
  final ValueChanged<CombatHubMode> onSelectMode;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final hasTokens = arena.entriesRemainingToday > 0;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // --- Header & Daily Combat Tokens + Tester Mode Button -------------
        PixelFrame(
          color: AppTheme.castIron,
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
                    child: Text(l10n.combatHubTitle, style: display.style(28)),
                  ),
                  InkWell(
                    key: const Key('open_tester_panel_btn'),
                    onTap: onOpenTester,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: testerEnabled
                            ? AppTheme.darkBlood
                            : AppTheme.obsidianBlack,
                        border: Border.all(
                          color: testerEnabled
                              ? AppTheme.emberGold
                              : AppTheme.ironBorder,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const PixelIcon(
                            PixelIcons.gear,
                            size: 14,
                            color: AppTheme.emberGold,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            testerEnabled
                                ? l10n.testerActiveBadge
                                : l10n.testerButtonLabel,
                            style: display.style(16, color: AppTheme.emberGold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.combatHubSubtitle,
                style: const TextStyle(color: AppTheme.ashWhite, fontSize: 12),
              ),
              const SizedBox(height: 8),
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
                  PixelTag(
                    text: l10n.combatModeTournamentsBadge(
                      arena.tournamentsWonCount,
                      TournamentCatalog.tournaments.length,
                    ),
                    color: AppTheme.dullSilver,
                  ),
                  PixelTag(
                    text: l10n.combatModeDungeonsBadge(
                      arena.dungeonsCompletedCount,
                      DungeonCatalog.dungeons.length,
                    ),
                    color: AppTheme.dullSilver,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // --- 1. STORY MODE (Top, Emphasized, Locked) -----------------------
        PixelFrame(
          key: const Key('combat_mode_story_card'),
          highlight: true,
          color: AppTheme.darkBlood,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const PixelIcon(
                    PixelIcons.scroll,
                    size: 26,
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.combatModeStoryTitle,
                      style: display.style(26, color: AppTheme.emberGold),
                    ),
                  ),
                  const SizedBox(width: 6),
                  PixelTag(
                    text: l10n.combatModeStoryBadge,
                    color: AppTheme.emberGold,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                l10n.combatModeStoryDescription,
                style: const TextStyle(
                  color: AppTheme.ashWhite,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // --- 2. DUEL ARENA (1v1) -------------------------------------------
        PixelFrame(
          key: const Key('combat_mode_duels_card'),
          onTap: () => onSelectMode(CombatHubMode.duels),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PixelIcon(
                    PixelIcons.swords,
                    size: 24,
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.combatModeDuelsTitle,
                      style: display.style(24, color: AppTheme.ashWhite),
                    ),
                  ),
                  PixelTag(
                    text: l10n.arenaChampionsBadge(
                      arena.defeatedChampionsCount,
                      ArenaCatalog.opponents.length,
                    ),
                    color: AppTheme.emberGold,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.combatModeDuelsDescription,
                style: const TextStyle(
                  color: AppTheme.dullSilver,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              PixelButton(
                key: const Key('combat_mode_duels_btn'),
                label: l10n.combatModeDuelsButton,
                onPressed: () => onSelectMode(CombatHubMode.duels),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // --- 3. FORGE TOURNAMENTS (Gauntlet) -------------------------------
        PixelFrame(
          key: const Key('combat_mode_tournaments_card'),
          onTap: () => onSelectMode(CombatHubMode.tournaments),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PixelIcon(
                    PixelIcons.trophy,
                    size: 24,
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.combatModeTournamentsTitle,
                      style: display.style(24, color: AppTheme.ashWhite),
                    ),
                  ),
                  PixelTag(
                    text: l10n.combatModeTournamentsBadge(
                      arena.tournamentsWonCount,
                      TournamentCatalog.tournaments.length,
                    ),
                    color: AppTheme.emberGold,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.combatModeTournamentsDescription,
                style: const TextStyle(
                  color: AppTheme.dullSilver,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              PixelButton(
                key: const Key('combat_mode_tournaments_btn'),
                label: l10n.combatModeTournamentsButton,
                variant: PixelButtonVariant.secondary,
                onPressed: () => onSelectMode(CombatHubMode.tournaments),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // --- 4. DEEP DUNGEONS (Exploration + 6-Attribute D20 Checks) -------
        PixelFrame(
          key: const Key('combat_mode_dungeons_card'),
          onTap: () => onSelectMode(CombatHubMode.dungeons),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const PixelIcon(
                    PixelIcons.flame,
                    size: 24,
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      l10n.combatModeDungeonsTitle,
                      style: display.style(24, color: AppTheme.ashWhite),
                    ),
                  ),
                  PixelTag(
                    text: l10n.combatModeDungeonsBadge(
                      arena.dungeonsCompletedCount,
                      DungeonCatalog.dungeons.length,
                    ),
                    color: AppTheme.emberGold,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.combatModeDungeonsDescription,
                style: const TextStyle(
                  color: AppTheme.dullSilver,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              PixelButton(
                key: const Key('combat_mode_dungeons_btn'),
                label: l10n.combatModeDungeonsButton,
                variant: PixelButtonVariant.secondary,
                onPressed: () => onSelectMode(CombatHubMode.dungeons),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ArenaRosterView extends StatelessWidget {
  const _ArenaRosterView({
    required this.arena,
    required this.char,
    required this.busy,
    required this.testerEnabled,
    required this.selectedMode,
    required this.onSelectMode,
    required this.onBackToHub,
    required this.onOpenTester,
    required this.onChallenge,
    required this.onEnterTournament,
    required this.onEnterDungeon,
  });

  final ArenaState arena;
  final CharacterState char;
  final bool busy;
  final bool testerEnabled;
  final CombatHubMode selectedMode;
  final ValueChanged<CombatHubMode> onSelectMode;
  final VoidCallback onBackToHub;
  final VoidCallback onOpenTester;
  final ValueChanged<ArenaOpponent> onChallenge;
  final ValueChanged<TournamentDefinition> onEnterTournament;
  final ValueChanged<DungeonDefinition> onEnterDungeon;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final hasTokens = arena.entriesRemainingToday > 0;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // --- Top Bar: Back to Hub + Tokens + Tester Button -----------------
        Row(
          children: [
            InkWell(
              key: const Key('combat_back_to_hub_btn'),
              onTap: onBackToHub,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.castIron,
                  border: Border.all(color: AppTheme.ironBorder, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PixelIcon(
                      PixelIcons.back,
                      size: 16,
                      color: AppTheme.emberGold,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      l10n.combatBackToHub,
                      style: display.style(16, color: AppTheme.emberGold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: PixelTag(
                text: l10n.arenaTokensBadge(
                  arena.entriesRemainingToday,
                  arena.totalEntriesToday,
                ),
                color: hasTokens ? AppTheme.emberGold : AppTheme.bloodCrimson,
              ),
            ),
            const SizedBox(width: 8),
            InkWell(
              key: const Key('roster_open_tester_btn'),
              onTap: onOpenTester,
              child: PixelTag(
                text: testerEnabled
                    ? l10n.testerActiveBadge
                    : l10n.testerButtonLabel,
                color: AppTheme.emberGold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        // --- Mode Switcher: 1v1 Duels | Tournaments | Dungeons ------------
        Row(
          children: [
            Expanded(
              child: PixelButton(
                key: const Key('arena_tab_duels'),
                label: l10n.arenaTabDuels,
                variant: selectedMode == CombatHubMode.duels
                    ? PixelButtonVariant.primary
                    : PixelButtonVariant.secondary,
                onPressed: () => onSelectMode(CombatHubMode.duels),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: PixelButton(
                key: const Key('arena_tab_tournaments'),
                label: l10n.arenaTabTournaments,
                variant: selectedMode == CombatHubMode.tournaments
                    ? PixelButtonVariant.primary
                    : PixelButtonVariant.secondary,
                onPressed: () => onSelectMode(CombatHubMode.tournaments),
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: PixelButton(
                key: const Key('arena_tab_dungeons'),
                label: 'Dungeons',
                variant: selectedMode == CombatHubMode.dungeons
                    ? PixelButtonVariant.primary
                    : PixelButtonVariant.secondary,
                onPressed: () => onSelectMode(CombatHubMode.dungeons),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (selectedMode == CombatHubMode.duels)
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
        else if (selectedMode == CombatHubMode.tournaments)
          for (final t in TournamentCatalog.tournaments) ...[
            _TournamentCard(
              tournament: t,
              victories: arena.victoriesByOpponent[t.id] ?? 0,
              canEnter: hasTokens && !busy,
              game: game,
              onEnter: () => onEnterTournament(t),
            ),
            const SizedBox(height: 10),
          ]
        else
          for (final d in DungeonCatalog.dungeons) ...[
            _DungeonCard(
              dungeon: d,
              victories: arena.victoriesByOpponent[d.id] ?? 0,
              canEnter: hasTokens && !busy,
              game: game,
              onEnter: () => onEnterDungeon(d),
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
            '${l10n.combatHpLabel} ${npc.maxHp} · ${l10n.combatArmorClassLabel(npc.armorClass)} · ATQ ${npc.attack} · DEF ${npc.defense}',
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

class _DungeonCard extends StatelessWidget {
  const _DungeonCard({
    required this.dungeon,
    required this.victories,
    required this.canEnter,
    required this.game,
    required this.onEnter,
  });

  final DungeonDefinition dungeon;
  final int victories;
  final bool canEnter;
  final GameText game;
  final VoidCallback onEnter;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final display = DisplayFont.from(context);
    final won = victories > 0;
    final attrsLine = dungeon.rooms
        .map((r) => '${game.attributeCode(r.attribute)} (${l10n.dungeonDifficultyLabel(r.difficultyClass)})')
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
                      game.dungeonName(dungeon.id),
                      style: display.style(
                        24,
                        color: won ? AppTheme.emberGold : AppTheme.ashWhite,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      game.dungeonLore(dungeon.id),
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
                    text: l10n.arenaRecommendedLevel(dungeon.recommendedLevel),
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(height: 4),
                  PixelTag(
                    text: l10n.dungeonRoomsBadge(dungeon.rooms.length),
                    color: AppTheme.dullSilver,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$attrsLine → ${game.arenaNpcName(dungeon.bossId)}',
            style: const TextStyle(color: AppTheme.darkAsh, fontSize: 11),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.arenaRewardLabel(
              game.combatTitle(dungeon.reward.titleId),
              game.combatCosmetic(dungeon.reward.cosmeticId),
            ),
            style: const TextStyle(
              color: AppTheme.emberGold,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          PixelButton(
            key: Key('dungeon_enter_${dungeon.id}'),
            label: l10n.dungeonEnterButton,
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

/// Interactive view for a Dungeon room attribute check (`1d20 + Attribute vs DC`).
class _ActiveDungeonRoomView extends StatelessWidget {
  const _ActiveDungeonRoomView({
    required this.run,
    required this.rollSeed,
    required this.busy,
    required this.onRollCheck,
    required this.onBypass,
    required this.onAdvance,
    required this.onBackToRoster,
  });

  final DungeonRun run;
  final int rollSeed;
  final bool busy;
  final VoidCallback onRollCheck;
  final VoidCallback onBypass;
  final VoidCallback onAdvance;
  final VoidCallback onBackToRoster;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final game = context.game;
    final display = DisplayFont.from(context);
    final room = run.currentRoom;
    final attrColor = AppTheme.attributeColor(room.attribute);
    final hasNextRoom = run.roomIndex + 1 < run.totalRooms;

    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        // --- Dungeon Room Header --------------------------------------------
        PixelFrame(
          highlight: true,
          color: AppTheme.castIron,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      game.dungeonName(run.dungeon.id),
                      style: display.style(22, color: AppTheme.dullSilver),
                    ),
                  ),
                  PixelTag(
                    text: l10n.dungeonRoomProgress(
                      run.currentRoomNumber,
                      run.totalRooms,
                    ),
                    color: AppTheme.emberGold,
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                game.dungeonRoomName(room.id),
                style: display.style(28, color: AppTheme.emberGold),
              ),
              const SizedBox(height: 4),
              Text(
                game.dungeonRoomDescription(room.id),
                style: const TextStyle(color: AppTheme.ashWhite, fontSize: 13),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  PixelTag(
                    text: '${game.attributeName(room.attribute)} (${game.attributeCode(room.attribute)})',
                    color: attrColor,
                  ),
                  PixelTag(
                    text: l10n.dungeonDifficultyLabel(room.difficultyClass),
                    color: AppTheme.emberGold,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),

        // --- Animated D20 Banner (after rolling the room check) -------------
        if (run.lastRoomRoll != null) ...[
          D20RollerBanner(
            roll: run.lastRoomRoll!,
            animationSeed: 'dungeon_${run.roomIndex}_$rollSeed',
            isDifficultyClass: true,
          ),
          const SizedBox(height: 10),
        ],

        // --- Hero Status Bar ------------------------------------------------
        PixelFrame(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                    '${run.heroHp}/${run.hero.maxHp}',
                    style: display.style(
                      18,
                      color: AppTheme.attributeColor(Attribute.constitution),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SegmentedBar(
                value: run.hero.maxHp > 0 ? run.heroHp / run.hero.maxHp : 0,
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
                    '${run.heroFocus}/${run.hero.maxFocus}',
                    style: display.style(
                      18,
                      color: AppTheme.attributeColor(Attribute.intelligence),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              SegmentedBar(
                value: run.hero.maxFocus > 0
                    ? run.heroFocus / run.hero.maxFocus
                    : 0,
                segments: 16,
                color: AppTheme.attributeColor(Attribute.intelligence),
                height: 8,
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // --- Room Actions or Resolution Banner ------------------------------
        if (!run.roomResolved) ...[
          PixelButton(
            key: const Key('dungeon_roll_check_btn'),
            label: l10n.dungeonRoomCheckButton(
              game.attributeCode(room.attribute),
              room.difficultyClass,
            ),
            onPressed: busy ? null : onRollCheck,
          ),
          const SizedBox(height: 8),
          PixelButton(
            key: const Key('dungeon_bypass_btn'),
            label: l10n.dungeonRoomBypassButton,
            variant: PixelButtonVariant.secondary,
            onPressed: busy ? null : onBypass,
          ),
        ] else ...[
          PixelFrame(
            highlight: run.lastRoomRoll?.isHit ?? false,
            color: (run.lastRoomRoll?.isHit ?? false)
                ? AppTheme.castIron
                : AppTheme.darkBlood,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  run.lastRoomBypassed
                      ? l10n.dungeonRoomBypassTitle
                      : (run.lastRoomRoll!.isHit
                          ? l10n.dungeonRoomBlessingTitle
                          : l10n.dungeonRoomTrapTitle),
                  style: display.style(26, color: AppTheme.emberGold),
                ),
                const SizedBox(height: 4),
                Text(
                  run.lastRoomBypassed
                      ? l10n.dungeonRoomBypassBody(run.lastRoomDeltaHp.abs())
                      : (run.lastRoomRoll!.isHit
                          ? l10n.dungeonRoomBlessingBody(
                              game.attributeName(room.attribute),
                              run.lastRoomDeltaHp,
                            )
                          : l10n.dungeonRoomTrapBody(run.lastRoomDeltaHp.abs())),
                  style: const TextStyle(color: AppTheme.ashWhite, fontSize: 12),
                ),
                const SizedBox(height: 12),
                PixelButton(
                  key: const Key('dungeon_advance_btn'),
                  label: hasNextRoom
                      ? l10n.dungeonNextRoomButton(run.currentRoomNumber + 1)
                      : l10n.dungeonEnterBossButton,
                  onPressed: busy ? null : onAdvance,
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 8),
        PixelButton(
          key: const Key('dungeon_abandon_btn'),
          label: l10n.combatBackToArena,
          variant: PixelButtonVariant.secondary,
          onPressed: busy ? null : onBackToRoster,
        ),
      ],
    );
  }
}

class _ActiveCombatView extends StatelessWidget {
  const _ActiveCombatView({
    required this.encounter,
    required this.tournamentRun,
    required this.dungeonRun,
    required this.heroName,
    required this.firstUnlock,
    required this.rollSeed,
    required this.busy,
    required this.onAction,
    required this.onNextTournamentRound,
    required this.onEquipReward,
    required this.onBackToRoster,
  });

  final CombatEncounter encounter;
  final TournamentRun? tournamentRun;
  final DungeonRun? dungeonRun;
  final String heroName;
  final bool firstUnlock;
  final int rollSeed;
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
    final critSuffix = entry.isCritical ? ' (CRIT 20!)' : '';
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
      CombatLogKind.heroCriticalFumble =>
        l10n.combatLogHeroFumble(entry.turn, entry.damage),
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
    final isRoundVictory =
        tournamentRun != null && tournamentRun!.isRoundVictory;

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
                    text: l10n.combatArmorClassLabel(npc.armorClass),
                    color: AppTheme.emberGold,
                  ),
                  const SizedBox(width: 6),
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

        // --- Animated D20 Roll Banner ---------------------------------------
        if (encounter.lastRoll != null) ...[
          D20RollerBanner(
            roll: encounter.lastRoll!,
            animationSeed: 'combat_${encounter.turn}_$rollSeed',
          ),
          const SizedBox(height: 10),
        ],

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
                  PixelTag(
                    text: l10n.combatArmorClassLabel(encounter.hero.armorClass),
                    color: AppTheme.dullSilver,
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
                  dungeonRun != null
                      ? l10n.dungeonVictoryTitle
                      : (tournamentRun != null
                          ? l10n.tournamentVictoryTitle
                          : l10n.combatVictoryTitle),
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
