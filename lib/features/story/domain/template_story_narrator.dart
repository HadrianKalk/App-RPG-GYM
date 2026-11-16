import '../../../core/game/attributes.dart';
import '../../../core/game/combat.dart';
import '../../../core/game/story.dart';
import '../../../l10n/game_text.dart';
import 'story_narrator.dart';

/// Offline-first Game Master implementing [StoryNarrator] with localized
/// Dark Fantasy templates and full [StoryEngine] trigger support (`narrative`,
/// `skillCheck`, `combatTrigger`).
class TemplateStoryNarrator implements StoryNarrator {
  const TemplateStoryNarrator();

  bool _isPt(String code) => code.toLowerCase().startsWith('pt');

  @override
  Future<StorySceneResponse> advanceScene(StoryNarrationContext context) async {
    final pt = _isPt(context.languageCode);
    final game = GameText(context.languageCode);
    final boss = context.arc.weeklyBoss;
    final bossName = game.legendaryBossName(boss.id);
    final className = game.className(context.effectiveClass);
    final seals = context.arc.weaknessStacks;
    final trainedToday = context.habits.trainedAttributesToday;

    // 1. If the player tapped a preset option with an explicit trigger, honor it.
    final choice = context.selectedChoice;
    if (choice != null) {
      if (choice.triggerType == StoryTriggerType.combatTrigger) {
        final tier = choice.combatTier ?? StoryCombatTier.normal;
        final opponentId = choice.opponentId ??
            (tier == StoryCombatTier.legendary
                ? boss.id
                : 'npc_ash_recruit');
        return StorySceneResponse(
          narration: pt
              ? '${context.heroProfile.name} avança sem hesitar. A neblina da Forja se rompe e o aço canta — o confronto é inevitável!'
              : '${context.heroProfile.name} steps forward without hesitation. The Forge mist parts and steel sings — combat is inevitable!',
          locationName: pt ? 'Arena das Cinzas' : 'Ashen Crossing',
          triggerType: StoryTriggerType.combatTrigger,
          combatTrigger: StoryCombatSpec(
            tier: tier,
            opponentId: opponentId,
            weaknessStacks: seals,
            reason: choice.label,
          ),
          choices: _defaultChoices(pt, bossName, boss.id),
          placeVisited: pt ? 'Arena das Cinzas' : 'Ashen Crossing',
          memorySummary: pt
              ? 'Entrou em combate (${choice.label}).'
              : 'Entered combat (${choice.label}).',
        );
      }

      if (choice.triggerType == StoryTriggerType.skillCheck &&
          choice.attribute != null) {
        final difficulty = choice.difficulty ?? StoryCheckDifficulty.medium;
        final dc = StoryEngine.computeDifficultyClass(
          context.heroLevel,
          difficulty,
        );
        final attrName = game.attributeName(choice.attribute!);
        return StorySceneResponse(
          narration: pt
              ? 'O destino prende a respiração. Você põe seu $attrName à prova diante do desafio.'
              : 'Fate holds its breath. You put your $attrName to the test before the obstacle.',
          locationName: pt ? 'Encruzilhada da Forja' : 'Forge Crossroads',
          triggerType: StoryTriggerType.skillCheck,
          skillCheck: StorySkillCheckSpec(
            attribute: choice.attribute!,
            difficulty: difficulty,
            difficultyClass: dc,
            reason: choice.label,
          ),
          choices: _defaultChoices(pt, bossName, boss.id),
        );
      }
    }

    // 2. Interpret free-text action typed by the player.
    final input = (context.playerInput ?? '').trim().toLowerCase();
    if (input.isNotEmpty) {
      if (_matchesAny(input, const [
        'boss',
        'chefe',
        'lendario',
        'lendário',
        'legendary',
        'desafiar',
        'challenge',
      ])) {
        return StorySceneResponse(
          narration: pt
              ? 'No topo do Altar Negro aguarda $bossName. Seus $seals/7 Selos da Semana vibram em seu sangue antes do primeiro golpe!'
              : 'Atop the Black Altar waits $bossName. Your $seals/7 Weekly Habit Seals hum in your veins before the first strike!',
          locationName: pt ? 'Altar do Soberano' : 'Sovereign Altar',
          triggerType: StoryTriggerType.combatTrigger,
          combatTrigger: StoryCombatSpec(
            tier: StoryCombatTier.legendary,
            opponentId: boss.id,
            weaknessStacks: seals,
            reason: pt ? 'Confronto Semanal Lendário' : 'Weekly Legendary Clash',
          ),
          choices: _defaultChoices(pt, bossName, boss.id),
          placeVisited: pt ? 'Altar do Soberano' : 'Sovereign Altar',
        );
      }

      if (_matchesAny(input, const [
        'atacar',
        'lutar',
        'espada',
        'golpear',
        'attack',
        'fight',
        'strike',
        'slash',
      ])) {
        return StorySceneResponse(
          narration: pt
              ? 'Um vigia corrompido emerge da fumaça tentando barrar sua passagem. Sua lâmina responde em reflexo!'
              : 'A corrupted sentinel steps out of the smoke to block your path. Your weapon answers by instinct!',
          locationName: pt ? 'Ponte de Escória' : 'Slag Bridge',
          triggerType: StoryTriggerType.combatTrigger,
          combatTrigger: StoryCombatSpec(
            tier: StoryCombatTier.normal,
            opponentId: _pickNormalOpponent(context.heroLevel),
            weaknessStacks: seals,
            reason: pt ? 'Emboscada na Ponte' : 'Bridge Ambush',
          ),
          choices: _defaultChoices(pt, bossName, boss.id),
        );
      }

      final detectedAttr = _inferAttributeFromText(input);
      if (detectedAttr != null) {
        final dc = StoryEngine.computeDifficultyClass(
          context.heroLevel,
          StoryCheckDifficulty.medium,
        );
        return StorySceneResponse(
          narration: pt
              ? 'Sua iniciativa exige precisão sob a névoa de Grindheim. Role 1d20 + ${game.attributeCode(detectedAttr)} contra CD $dc!'
              : 'Your bold move demands precision under the mist. Roll 1d20 + ${game.attributeCode(detectedAttr)} against DC $dc!',
          locationName: pt ? 'Ruínas da Bigorna' : 'Anvil Ruins',
          triggerType: StoryTriggerType.skillCheck,
          skillCheck: StorySkillCheckSpec(
            attribute: detectedAttr,
            difficulty: StoryCheckDifficulty.medium,
            difficultyClass: dc,
            reason: context.playerInput!.trim(),
          ),
          choices: _defaultChoices(pt, bossName, boss.id),
        );
      }

      // Free-form exploration beat advancing campaign memory.
      return StorySceneResponse(
        narration: pt
            ? 'Entre as brasas apagadas, você nota marcas recentes que levam ao domínio de $bossName. Um ferreiro sobrevivente sussurra que seus atos reais enfraquecem a aura do tirano ($seals/7 selos).'
            : 'Among dying embers, you spot fresh tracks leading toward $bossName\'s domain. A surviving smith whispers that your real-world discipline weakens the tyrant\'s aura ($seals/7 seals).',
        locationName: pt ? 'Acampamento dos Cinzentos' : 'Ashen Camp',
        triggerType: StoryTriggerType.narrative,
        choices: _defaultChoices(pt, bossName, boss.id),
        placeVisited: pt ? 'Acampamento dos Cinzentos' : 'Ashen Camp',
        npcUpdate: StoryNpcMemory(
          id: 'npc_smith_eldon',
          name: pt ? 'Eldon, Ferreiro das Cinzas' : 'Eldon, Ashen Smith',
          attitude: 'ally',
          lastNote: pt ? 'Deu pistas sobre o Chefe da Semana.' : 'Shared clues on the Weekly Boss.',
        ),
        memorySummary: pt
            ? 'Explorou as pistas rumo a $bossName.'
            : 'Followed clues leading toward $bossName.',
      );
    }

    // 3. Opening scene reacting to the hero's real-world habits today.
    final habitLinePt = trainedToday.isNotEmpty
        ? 'O vapor do seu treino de hoje (${trainedToday.map(game.attributeCode).join(", ")}) ainda pulsa em sua armadura.'
        : 'A fornalha desperta em silêncio — cada treino ou hábito registrado hoje fortalecerá seu caminho.';
    final habitLineEn = trainedToday.isNotEmpty
        ? 'Heat from today\'s training (${trainedToday.map(game.attributeCode).join(", ")}) still surges through your armor.'
        : 'The furnace wakes in silence — every workout or habit logged today sharpens your edge.';

    return StorySceneResponse(
      narration: pt
          ? '${context.heroProfile.name} ($className · Nv ${context.heroLevel}) cruza o Portão de Obsidiana sob chuva de cinzas. $habitLinePt\n\nEsta semana, a sombra de $bossName paira sobre o reino ($seals/7 Selos de Enfraquecimento ativos).'
          : '${context.heroProfile.name} ($className · Lv ${context.heroLevel}) crosses the Obsidian Gate beneath falling ash. $habitLineEn\n\nThis week, $bossName\'s shadow looms over the realm ($seals/7 Weakness Seals active).',
      locationName: pt ? 'Portão de Obsidiana' : 'Obsidian Gate',
      triggerType: StoryTriggerType.narrative,
      choices: _defaultChoices(pt, bossName, boss.id),
      placeVisited: pt ? 'Portão de Obsidiana' : 'Obsidian Gate',
    );
  }

  @override
  Future<StorySceneResponse> narrateSkillCheckOutcome({
    required StoryNarrationContext context,
    required StorySkillCheckSpec check,
    required D20RollResult roll,
    required bool usedInspirationReroll,
  }) async {
    final pt = _isPt(context.languageCode);
    final game = GameText(context.languageCode);
    final boss = context.arc.weeklyBoss;
    final bossName = game.legendaryBossName(boss.id);
    final rerollNotePt = usedInspirationReroll ? ' (com Inspiração Heroica!) ' : ' ';
    final rerollNoteEn = usedInspirationReroll ? ' (with Heroic Inspiration!) ' : ' ';

    if (roll.isCriticalHit) {
      return StorySceneResponse(
        narration: pt
            ? 'CRÍTICO NATURAL (20)$rerollNotePt— ${check.reason}! Um brilho dourado corta a névoa: você domina a situação com perfeição e descobre uma brecha na guarda de $bossName.'
            : 'NATURAL 20$rerollNoteEn— ${check.reason}! Golden light cleaves the mist: you seize complete control and uncover a flaw in $bossName\'s stance.',
        locationName: pt ? 'Santuário Oculto' : 'Hidden Sanctum',
        triggerType: StoryTriggerType.narrative,
        choices: _defaultChoices(pt, bossName, boss.id),
        memorySummary: pt
            ? 'Sucesso crítico em ${game.attributeCode(check.attribute)}.'
            : 'Critical success on ${game.attributeCode(check.attribute)}.',
      );
    }

    if (roll.isHit) {
      return StorySceneResponse(
        narration: pt
            ? 'Sucesso (${roll.totalRoll} vs CD ${roll.targetNumber})$rerollNotePt— você supera a provação com firmeza e abre caminho pelas sombras.'
            : 'Success (${roll.totalRoll} vs DC ${roll.targetNumber})$rerollNoteEn— you overcome the trial cleanly and carve a path through the dark.',
        locationName: pt ? 'Corredor das Runas' : 'Runed Corridor',
        triggerType: StoryTriggerType.narrative,
        choices: _defaultChoices(pt, bossName, boss.id),
      );
    }

    if (roll.isCriticalFumble) {
      return StorySceneResponse(
        narration: pt
            ? 'FALHA CRÍTICA (1) — A sorte vira as costas e o estrondo ecoa pelas pedras, atraindo um guardião hostil direto para você!'
            : 'CRITICAL FUMBLE (1) — Fortune turns cold and echoes ring off the stone, drawing a hostile guardian straight to you!',
        locationName: pt ? 'Fosso das Cinzas' : 'Ashen Pit',
        triggerType: StoryTriggerType.combatTrigger,
        combatTrigger: StoryCombatSpec(
          tier: StoryCombatTier.normal,
          opponentId: _pickNormalOpponent(context.heroLevel),
          weaknessStacks: context.arc.weaknessStacks,
          reason: pt ? 'Consequência da Falha Crítica' : 'Critical Fumble Ambush',
        ),
        choices: _defaultChoices(pt, bossName, boss.id),
      );
    }

    return StorySceneResponse(
      narration: pt
          ? 'Falha (${roll.totalRoll} vs CD ${roll.targetNumber}) — O obstáculo resiste ao seu avanço, obrigando um recuo tático para encontrar outra brecha.'
          : 'Failed (${roll.totalRoll} vs DC ${roll.targetNumber}) — The obstacle holds firm, forcing a tactical step back to seek another angle.',
      locationName: pt ? 'Pátio da Forja' : 'Forge Courtyard',
      triggerType: StoryTriggerType.narrative,
      choices: _defaultChoices(pt, bossName, boss.id),
    );
  }

  @override
  Future<StorySceneResponse> narrateCombatOutcome({
    required StoryNarrationContext context,
    required StoryCombatSpec combat,
    required CombatEncounter finishedEncounter,
  }) async {
    final pt = _isPt(context.languageCode);
    final game = GameText(context.languageCode);
    final boss = context.arc.weeklyBoss;
    final bossName = game.legendaryBossName(boss.id);
    final won = finishedEncounter.status == CombatStatus.victory;
    final enemyName = finishedEncounter.isLegendary
        ? game.legendaryBossName(finishedEncounter.opponent.id)
        : game.arenaNpcName(finishedEncounter.opponent.id);

    if (won) {
      return StorySceneResponse(
        narration: pt
            ? 'Vitória em ${finishedEncounter.turn} turnos! $enemyName cai de joelhos diante de ${context.heroProfile.name} (PV restante: ${finishedEncounter.heroHp}/${finishedEncounter.hero.maxHp}). As cinzas se assentam e um novo capítulo da crônica se abre.'
            : 'Victory in ${finishedEncounter.turn} turns! $enemyName falls to one knee before ${context.heroProfile.name} (HP remaining: ${finishedEncounter.heroHp}/${finishedEncounter.hero.maxHp}). The ash settles as a new road opens.',
        locationName: pt ? 'Campo Conquistado' : 'Conquered Ground',
        triggerType: StoryTriggerType.chapterComplete,
        choices: _defaultChoices(pt, bossName, boss.id),
        memorySummary: pt
            ? 'Derrotou $enemyName em combate real (${finishedEncounter.turn} turnos).'
            : 'Defeated $enemyName in live combat (${finishedEncounter.turn} turns).',
      );
    }

    return StorySceneResponse(
      narration: pt
          ? '$enemyName prevaleceu desta vez, mas você escapa pela neblina antes do golpe final. Retorne mais forte com seus treinos reais e desafie novamente quando estiver pronto.'
          : '$enemyName prevailed this time, yet you slip into the mist before the final blow. Return stronger from real-world training and strike back when ready.',
      locationName: pt ? 'Refúgio da Fogueira' : 'Bonfire Refuge',
      triggerType: StoryTriggerType.narrative,
      choices: _defaultChoices(pt, bossName, boss.id),
      memorySummary: pt
          ? 'Recuou taticamente após enfrentar $enemyName.'
          : 'Retreated tactically after facing $enemyName.',
    );
  }

  List<StoryChoiceOption> _defaultChoices(
    bool pt,
    String bossName,
    String bossId,
  ) {
    return [
      StoryChoiceOption(
        id: 'choice_investigate',
        label: pt ? 'Decifrar glifos antigos (INT)' : 'Decipher ancient glyphs (INT)',
        actionPrompt: pt
            ? 'Examino os glifos na pedra para achar fraquezas ocultas.'
            : 'I inspect the carved glyphs to uncover hidden weaknesses.',
        triggerType: StoryTriggerType.skillCheck,
        attribute: Attribute.intelligence,
        difficulty: StoryCheckDifficulty.medium,
      ),
      StoryChoiceOption(
        id: 'choice_persuade',
        label: pt ? 'Impor respeito ao vigia (CAR)' : 'Command the watchman (CHA)',
        actionPrompt: pt
            ? 'Uso minha presença para dobrar a guarda e arrancar informações.'
            : 'I press my presence to bend the watchman and extract secrets.',
        triggerType: StoryTriggerType.skillCheck,
        attribute: Attribute.charisma,
        difficulty: StoryCheckDifficulty.medium,
      ),
      StoryChoiceOption(
        id: 'choice_ambush',
        label: pt ? 'Enfrentar patrulha da Forja' : 'Engage Forge patrol',
        actionPrompt: pt
            ? 'Avanço contra a patrulha inimiga!'
            : 'I charge into the enemy patrol!',
        triggerType: StoryTriggerType.combatTrigger,
        combatTier: StoryCombatTier.normal,
      ),
      StoryChoiceOption(
        id: 'choice_boss',
        label: pt
            ? 'Desafiar Chefe Semanal: $bossName'
            : 'Challenge Weekly Boss: $bossName',
        actionPrompt: pt
            ? 'Marcho direto para desafiar $bossName.'
            : 'I march straight to challenge $bossName.',
        triggerType: StoryTriggerType.combatTrigger,
        combatTier: StoryCombatTier.legendary,
        opponentId: bossId,
      ),
    ];
  }

  bool _matchesAny(String text, List<String> keywords) =>
      keywords.any(text.contains);

  Attribute? _inferAttributeFromText(String text) {
    if (_matchesAny(text, const [
      'empurrar',
      'arrombar',
      'força',
      'forca',
      'escalar',
      'break',
      'push',
      'climb',
      'force',
    ])) {
      return Attribute.strength;
    }
    if (_matchesAny(text, const [
      'furtiv',
      'esconder',
      'saltar',
      'pular',
      'desviar',
      'sneak',
      'dodge',
      'leap',
      'stealth',
    ])) {
      return Attribute.dexterity;
    }
    if (_matchesAny(text, const [
      'resistir',
      'veneno',
      'frio',
      'aguentar',
      'endure',
      'resist',
      'poison',
    ])) {
      return Attribute.constitution;
    }
    if (_matchesAny(text, const [
      'ler',
      'decifrar',
      'investigar',
      'runa',
      'estudar',
      'inspect',
      'decipher',
      'rune',
      'investigate',
    ])) {
      return Attribute.intelligence;
    }
    if (_matchesAny(text, const [
      'sentir',
      'perceber',
      'meditar',
      'ouvir',
      'sense',
      'perceive',
      'listen',
      'focus',
    ])) {
      return Attribute.wisdom;
    }
    if (_matchesAny(text, const [
      'persuadir',
      'convencer',
      'intimidar',
      'negociar',
      'blefar',
      'falar',
      'persuade',
      'intimidate',
      'negotiate',
      'talk',
    ])) {
      return Attribute.charisma;
    }
    return null;
  }

  String _pickNormalOpponent(int heroLevel) {
    final eligible = ArenaCatalog.opponents
        .where((o) => o.recommendedLevel <= heroLevel + 2)
        .toList();
    return (eligible.isNotEmpty ? eligible.last : ArenaCatalog.opponents.first)
        .id;
  }
}
