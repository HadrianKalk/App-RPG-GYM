import '../../../core/game/attributes.dart';
import '../../../core/game/combat.dart';
import '../../../core/game/hero_profile.dart';
import '../../../l10n/game_text.dart';
import 'story_narrator.dart';

/// Builds the canonical Dark Fantasy World Bible + strict D&D 5e Game Master
/// system prompt and compact turn payloads for [GeminiStoryNarrator].
///
/// The AI receives only read-only facts owned by the engine and must respond
/// in strict JSON with engine triggers (`narrative`, `skillCheck`,
/// `combatTrigger`, `chapterComplete`) without ever inventing numbers.
abstract final class WorldLorePrompt {
  /// Builds the fixed Dark Fantasy setting, rules, and JSON schema contract.
  static String buildSystemPrompt(String languageCode) {
    final isPt = languageCode.toLowerCase().startsWith('pt');
    final langName = isPt ? 'Portuguese (pt-BR)' : 'English';

    return '''
You are the Dark Fantasy Game Master of **Grindheim** (in the brutal spirit of Berserk and Dark Souls blended with D&D 5e tabletop structure).

### 1. THE WORLD OF GRINDHEIM
- Grindheim is a realm of ash-choked iron forts, dying bonfires, drowned crypts, and ancient anvils where stagnation turns warriors into hollow slag.
- Only real-world effort — forged iron, endurance, study, discipline, and meditation — feeds the hero's Inner Ember. NPCs recognize the physical and mental toll of the hero's real habits.
- Iconic recurring landmarks you may weave together:
  - *Obsidian Gate / Portão de Obsidiana* (border bastion & campfire haven)
  - *Ashen Camp / Acampamento dos Cinzentos* (home of Eldon, Ashen Smith, and weary travelers)
  - *Sunken Crypt / Cripta Submersa*, *Runed Sanctum / Santuário das Runas*, *Slag Bridge / Ponte de Escória*
  - *Sovereign Altar / Altar dos Soberanos* (throne of the Weekly Legendary Boss)

### 2. IRON RULES OF THE TABLETOP ENGINE (NEVER VIOLATE)
1. **Language:** Write ALL player-facing strings (`narration`, `locationName`, choice labels/prompts, NPC notes, `memorySummary`) strictly in **$langName**.
2. **Respect Grammatical Form:** Address the hero consistently using their `heroForm` (`masculine`, `feminine`, or `neutral`).
3. **You ONLY narrate and propose triggers — NEVER invent numbers:**
   - Never roll dice, grant XP, invent HP/damage values, invent custom Difficulty Classes, or declare victory/defeat yourself.
   - When an action carries risk (persuading, climbing, sneaking, deciphering, resisting poison, reading intent), return `triggerType: "skillCheck"` with one of:
     - `attribute`: `strength | dexterity | constitution | intelligence | wisdom | charisma`
     - `difficulty`: `easy | medium | hard | legendary`
   - When negotiation fails, an ambush erupts, or the hero confronts an enemy or the Weekly Legendary Boss, return `triggerType: "combatTrigger"` with:
     - `tier`: `normal | elite | legendary`
     - `opponentId`: use the exact `weeklyBossId` for `legendary`, or one of the Arena archetypes (`npc_ash_recruit`, `npc_iron_sentinel`, `npc_shadow_duelist`, `npc_blood_inquisitor`, `npc_hollow_archmage`, `npc_forge_colossus`) for `normal`/`elite`.
4. **Prose Style:** Atmospheric, visceral Dark Fantasy (2–3 crisp paragraphs max per turn). React explicitly to the hero's real-world habits logged today and their weekly Weakness Seals against the current Legendary Boss.
5. **Valid Output:** Respond ONLY with a valid JSON object matching this exact schema (no markdown fences, no extra prose outside JSON):
{
  "narration": "string (2-3 atmospheric paragraphs)",
  "locationName": "string (short landmark name)",
  "triggerType": "narrative | skillCheck | combatTrigger | chapterComplete",
  "skillCheck": {
    "attribute": "strength | dexterity | constitution | intelligence | wisdom | charisma",
    "difficulty": "easy | medium | hard | legendary",
    "reason": "short label of the risk"
  },
  "combatTrigger": {
    "tier": "normal | elite | legendary",
    "opponentId": "valid id from context",
    "reason": "short combat reason"
  },
  "choices": [
    {
      "id": "c1",
      "label": "Short tactical button text (max 48 chars)",
      "actionPrompt": "What the hero says/does",
      "triggerType": "narrative | skillCheck | combatTrigger",
      "attribute": "optional attribute if skillCheck",
      "difficulty": "easy | medium | hard | legendary",
      "combatTier": "optional normal | elite | legendary",
      "opponentId": "optional valid opponent id"
    }
  ],
  "placeVisited": "short place name",
  "npcUpdate": {
    "id": "stable_npc_id",
    "name": "NPC Name",
    "attitude": "ally | neutral | hostile",
    "lastNote": "short status"
  },
  "memorySummary": "1 short sentence summarizing this beat for future turns"
}
Provide `skillCheck` ONLY when `triggerType == "skillCheck"` (otherwise `null`).
Provide `combatTrigger` ONLY when `triggerType == "combatTrigger"` (otherwise `null`).
Always provide 3–4 distinct `choices` (unless `combatTrigger` fires immediately).
''';
  }

  /// Builds the dynamic per-turn user prompt containing hero identity, real-world
  /// habits, compact campaign memory, Weekly Legendary Boss threat, and player input.
  static String buildTurnPrompt(
    StoryNarrationContext ctx, {
    String? extraEventLine,
  }) {
    final game = GameText(ctx.languageCode);
    final boss = ctx.arc.weeklyBoss;
    final bossName = game.legendaryBossName(boss.id);
    final bossClass = game.legendaryBossClass(boss.id);
    final bossLore = game.legendaryBossLore(boss.id);
    final originLabel = game.heroOriginName(ctx.heroProfile);
    final customStory = ctx.heroProfile.origin == HeroOrigin.custom
        ? (ctx.heroProfile.customOriginStory ?? '')
        : '';

    final mods = [
      for (final a in Attribute.values)
        '${game.attributeCode(a)}:${ctx.heroStats.scores[a]}(${_signed(ctx.heroStats.attackModifierFor(a))})',
    ].join(', ');

    final trainedToday = ctx.habits.trainedAttributesToday
        .map(game.attributeCode)
        .join(', ');

    final buf = StringBuffer()
      ..writeln('### HERO SHEET (READ-ONLY)')
      ..writeln('- Name: ${ctx.heroProfile.name}')
      ..writeln('- Form: ${ctx.heroProfile.form.name}')
      ..writeln('- Origin: $originLabel${customStory.isNotEmpty ? " ($customStory)" : ""}')
      ..writeln('- Class: ${game.className(ctx.effectiveClass)} (Lv ${ctx.heroLevel})')
      ..writeln('- Attributes: $mods')
      ..writeln()
      ..writeln('### REAL-WORLD EFFORT TODAY & THIS WEEK')
      ..writeln('- Workouts today: ${ctx.habits.workoutsToday} (attributes trained today: ${trainedToday.isEmpty ? "none yet" : trainedToday})')
      ..writeln('- Water cups today: ${ctx.habits.waterCupsToday}, Last sleep: ${ctx.habits.lastSleepHours?.toStringAsFixed(1) ?? "unknown"}h')
      ..writeln('- Weekly discipline Weakness Seals on the Boss: ${ctx.arc.weaknessStacks}/7')
      ..writeln()
      ..writeln('### WEEKLY LEGENDARY BOSS (${ctx.arc.weekKey})')
      ..writeln('- Boss ID: ${boss.id}')
      ..writeln('- Name & Class: $bossName ($bossClass)')
      ..writeln('- Lore & Mechanics: $bossLore')
      ..writeln('- Already defeated this week: ${ctx.arc.bossDefeated}')
      ..writeln('- Valid non-boss opponentIds: ${ArenaCatalog.opponents.map((o) => o.id).join(", ")}')
      ..writeln()
      ..writeln('### COMPACT CAMPAIGN MEMORY')
      ..writeln(ctx.arc.memory.encode());

    if (extraEventLine != null && extraEventLine.trim().isNotEmpty) {
      buf
        ..writeln()
        ..writeln('### ENGINE RESOLUTION EVENT (IMMUTABLE FACT)')
        ..writeln(extraEventLine.trim());
    }

    final action = (ctx.playerInput ?? ctx.selectedChoice?.actionPrompt ?? '')
        .trim();
    buf
      ..writeln()
      ..writeln('### PLAYER INPUT')
      ..writeln(
        action.isEmpty
            ? 'Opening scene: introduce or continue the hero\'s expedition reacting to their real-world status and the looming Weekly Boss.'
            : action,
      );

    return buf.toString();
  }

  static String _signed(int n) => n >= 0 ? '+$n' : '$n';
}
