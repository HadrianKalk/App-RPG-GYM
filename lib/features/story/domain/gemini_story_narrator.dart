import 'dart:convert';

import '../../../core/game/attributes.dart';
import '../../../core/game/combat.dart';
import '../../../core/game/legendary_bosses.dart';
import '../../../core/game/story.dart';
import '../data/ai_http_stub.dart'
    if (dart.library.io) '../data/ai_http_io.dart'
    if (dart.library.js_interop) '../data/ai_http_web.dart';
import 'story_narrator.dart';
import 'template_story_narrator.dart';
import 'world_lore_prompt.dart';

/// Injectable HTTP JSON POST signature used by [GeminiStoryNarrator] (e.g. for tests).
typedef AiJsonPoster = Future<String> Function({
  required Uri url,
  required Map<String, dynamic> body,
  Duration timeout,
});

/// Live Gemini Game Master implementing [StoryNarrator] behind BYOK
/// configuration, strict JSON validation, and automatic offline fallback.
class GeminiStoryNarrator implements StoryNarrator {
  GeminiStoryNarrator({
    required this.apiKey,
    this.model = defaultModel,
    this.fallback = const TemplateStoryNarrator(),
    AiJsonPoster? poster,
  }) : _poster = poster ?? postJsonPayload;

  static const String defaultModel = 'gemini-3.8-flash';

  /// Ordered fallback models tried automatically on transient HTTP 503/429/404.
  static const List<String> fallbackModels = [
    'gemini-3.8-flash',
    'gemini-3.5-flash-lite',
    'gemini-2.5-flash-lite',
    'gemini-2.5-flash',
  ];

  final String apiKey;
  final String model;
  final StoryNarrator fallback;
  final AiJsonPoster _poster;

  @override
  Future<StorySceneResponse> advanceScene(StoryNarrationContext context) {
    return _requestWithFallback(
      context: context,
      extraEventLine: null,
      onFallback: () => fallback.advanceScene(context),
    );
  }

  @override
  Future<StorySceneResponse> narrateSkillCheckOutcome({
    required StoryNarrationContext context,
    required StorySkillCheckSpec check,
    required D20RollResult roll,
    required bool usedInspirationReroll,
  }) {
    final outcomeSummary =
        'D20 Skill Check on ${check.attribute.name} ("${check.reason}"): '
        'natural=${roll.naturalRoll}, mod=${roll.attributeModifier}, '
        'prof=${roll.proficiencyBonus}, total=${roll.totalRoll} vs DC ${roll.targetNumber} '
        '=> outcome=${roll.outcome.name}, usedInspirationReroll=$usedInspirationReroll.';
    return _requestWithFallback(
      context: context,
      extraEventLine: outcomeSummary,
      onFallback: () => fallback.narrateSkillCheckOutcome(
        context: context,
        check: check,
        roll: roll,
        usedInspirationReroll: usedInspirationReroll,
      ),
    );
  }

  @override
  Future<StorySceneResponse> narrateCombatOutcome({
    required StoryNarrationContext context,
    required StoryCombatSpec combat,
    required CombatEncounter finishedEncounter,
  }) {
    final combatSummary =
        'Live Combat Outcome against ${finishedEncounter.opponent.id} '
        '(tier=${combat.tier.name}): status=${finishedEncounter.status.name}, '
        'turns=${finishedEncounter.turn}, '
        'heroHpRemaining=${finishedEncounter.heroHp}/${finishedEncounter.hero.maxHp}. '
        'Narrate this exact battle aftermath.';
    return _requestWithFallback(
      context: context,
      extraEventLine: combatSummary,
      onFallback: () => fallback.narrateCombatOutcome(
        context: context,
        combat: combat,
        finishedEncounter: finishedEncounter,
      ),
    );
  }

  Future<StorySceneResponse> _requestWithFallback({
    required StoryNarrationContext context,
    required String? extraEventLine,
    required Future<StorySceneResponse> Function() onFallback,
  }) async {
    final cleanKey = apiKey.trim();
    if (cleanKey.isEmpty) {
      return onFallback();
    }

    try {
      final body = <String, dynamic>{
        'system_instruction': {
          'parts': [
            {'text': WorldLorePrompt.buildSystemPrompt(context.languageCode)},
          ],
        },
        'contents': [
          {
            'role': 'user',
            'parts': [
              {
                'text': WorldLorePrompt.buildTurnPrompt(
                  context,
                  extraEventLine: extraEventLine,
                ),
              },
            ],
          },
        ],
        'generationConfig': {
          'responseMimeType': 'application/json',
          'temperature': 0.85,
          'maxOutputTokens': 900,
        },
      };

      final result = await _postWithModelFallback(
        cleanKey: cleanKey,
        body: body,
        timeout: const Duration(seconds: 18),
      );
      return _parseGeminiResponse(result.rawBody, context);
    } catch (error) {
      final fallbackResponse = await onFallback();
      return fallbackResponse.withFallbackReason(
        sanitizeError(error, apiKey: cleanKey),
      );
    }
  }

  /// Sends a lightweight probe to Gemini `generateContent` to verify that the
  /// configured API key, model, and browser/device network path are working.
  Future<({bool ok, String? error, String? usedModel})> testConnection() async {
    final cleanKey = apiKey.trim();
    if (cleanKey.isEmpty) {
      return (ok: false, error: 'Missing API key.', usedModel: null);
    }
    try {
      final body = <String, dynamic>{
        'contents': [
          {
            'role': 'user',
            'parts': [
              {'text': 'Reply with OK.'},
            ],
          },
        ],
        'generationConfig': {
          'temperature': 0.0,
          'maxOutputTokens': 16,
        },
      };
      final result = await _postWithModelFallback(
        cleanKey: cleanKey,
        body: body,
        timeout: const Duration(seconds: 15),
      );
      final decoded = jsonDecode(result.rawBody) as Map<String, dynamic>;
      final candidates = decoded['candidates'] as List<dynamic>?;
      if (candidates == null || candidates.isEmpty) {
        return (
          ok: false,
          error: 'Gemini returned no response candidates.',
          usedModel: result.usedModel,
        );
      }
      return (ok: true, error: null, usedModel: result.usedModel);
    } catch (error) {
      return (
        ok: false,
        error: sanitizeError(error, apiKey: cleanKey),
        usedModel: null,
      );
    }
  }

  Future<({String rawBody, String usedModel})> _postWithModelFallback({
    required String cleanKey,
    required Map<String, dynamic> body,
    required Duration timeout,
  }) async {
    final candidates = _candidateModels(model);
    Object? firstError;

    for (var i = 0; i < candidates.length; i++) {
      final candidateModel = candidates[i];
      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/'
        '$candidateModel:generateContent?key=${Uri.encodeQueryComponent(cleanKey)}',
      );
      try {
        final rawBody = await _poster(url: url, body: body, timeout: timeout);
        return (rawBody: rawBody, usedModel: candidateModel);
      } catch (error) {
        firstError ??= error;
        final isLast = i == candidates.length - 1;
        if (isLast || !_isModelRecoverableError(error)) {
          rethrow;
        }
      }
    }
    throw firstError!;
  }

  static List<String> _candidateModels(String preferred) {
    final cleanPreferred = preferred.trim().isEmpty ? defaultModel : preferred.trim();
    final seen = <String>{cleanPreferred};
    final list = <String>[cleanPreferred];
    for (final alt in fallbackModels) {
      if (seen.add(alt)) list.add(alt);
    }
    return list;
  }

  static bool _isModelRecoverableError(Object error) {
    final msg = error.toString();
    return msg.contains('AI HTTP 404') ||
        msg.contains('AI HTTP 429') ||
        msg.contains('AI HTTP 500') ||
        msg.contains('AI HTTP 502') ||
        msg.contains('AI HTTP 503') ||
        msg.contains('AI HTTP 504');
  }

  /// Strips secret API keys and extracts readable Gemini HTTP errors.
  static String sanitizeError(Object error, {String? apiKey}) {
    var msg = error.toString().trim();
    final cleanKey = apiKey?.trim();
    if (cleanKey != null && cleanKey.isNotEmpty) {
      msg = msg.replaceAll(cleanKey, '***');
      msg = msg.replaceAll(Uri.encodeQueryComponent(cleanKey), '***');
    }
    msg = msg.replaceAll(RegExp(r'key=[^&\s)]+'), 'key=***');

    // Extract clean message when `postJsonPayload` throws `AI HTTP <status>: <json>`.
    final httpMatch = RegExp(r'AI HTTP (\d+):\s*(.+)', dotAll: true).firstMatch(msg);
    if (httpMatch != null) {
      final code = httpMatch.group(1);
      final rawJson = httpMatch.group(2) ?? '';
      try {
        final decoded = jsonDecode(rawJson);
        if (decoded is Map<String, dynamic>) {
          final err = decoded['error'];
          if (err is Map<String, dynamic> && err['message'] is String) {
            final apiMsg = (err['message'] as String).trim();
            return _truncate('HTTP $code: $apiMsg', 180);
          }
        }
      } catch (_) {
        // Ignore JSON parse error and fall through to generic message truncation.
      }
      return _truncate('HTTP $code: $rawJson', 180);
    }
    return _truncate(msg, 180);
  }

  static String _truncate(String value, int maxLen) {
    final compact = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (compact.length <= maxLen) return compact;
    return '${compact.substring(0, maxLen - 3)}...';
  }

  StorySceneResponse _parseGeminiResponse(
    String rawBody,
    StoryNarrationContext context,
  ) {
    final decoded = jsonDecode(rawBody) as Map<String, dynamic>;
    final candidates = decoded['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw const FormatException('Missing Gemini candidates.');
    }
    final first = candidates.first as Map<String, dynamic>;
    final content = first['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    final text = parts?.isNotEmpty == true
        ? (parts!.first as Map<String, dynamic>)['text'] as String?
        : null;
    if (text == null || text.trim().isEmpty) {
      throw const FormatException('Empty Gemini candidate text.');
    }

    final cleanJson = _stripMarkdownFences(text);
    final payload = jsonDecode(cleanJson) as Map<String, dynamic>;
    final narration = (payload['narration'] as String?)?.trim() ?? '';
    if (narration.isEmpty) {
      throw const FormatException('Empty narration field.');
    }

    final pt = context.languageCode.toLowerCase().startsWith('pt');
    final location = (payload['locationName'] as String?)?.trim();
    final safeLocation = (location == null || location.isEmpty)
        ? (pt ? 'Grindheim' : 'Grindheim')
        : location;

    var trigger = _parseEnum(
      StoryTriggerType.values,
      payload['triggerType'] as String?,
      StoryTriggerType.narrative,
    );

    StorySkillCheckSpec? skillCheck;
    if (trigger == StoryTriggerType.skillCheck &&
        payload['skillCheck'] is Map<String, dynamic>) {
      final sc = payload['skillCheck'] as Map<String, dynamic>;
      final attr = _parseEnum(
        Attribute.values,
        sc['attribute'] as String?,
        Attribute.wisdom,
      );
      final diff = _parseEnum(
        StoryCheckDifficulty.values,
        sc['difficulty'] as String?,
        StoryCheckDifficulty.medium,
      );
      final reason = (sc['reason'] as String?)?.trim();
      skillCheck = StorySkillCheckSpec(
        attribute: attr,
        difficulty: diff,
        // Difficulty Class is ALWAYS computed by the pure game engine.
        difficultyClass: StoryEngine.computeDifficultyClass(
          context.heroLevel,
          diff,
        ),
        reason: (reason == null || reason.isEmpty)
            ? (pt ? 'Provação da Forja' : 'Forge Trial')
            : reason,
      );
    } else if (trigger == StoryTriggerType.skillCheck) {
      trigger = StoryTriggerType.narrative;
    }

    StoryCombatSpec? combatTrigger;
    if (trigger == StoryTriggerType.combatTrigger &&
        payload['combatTrigger'] is Map<String, dynamic>) {
      final ct = payload['combatTrigger'] as Map<String, dynamic>;
      final tier = _parseEnum(
        StoryCombatTier.values,
        ct['tier'] as String?,
        StoryCombatTier.normal,
      );
      final safeOpponent = _sanitizeOpponentId(
        rawId: ct['opponentId'] as String?,
        tier: tier,
        weeklyBossId: context.arc.weeklyBossId,
      );
      final reason = (ct['reason'] as String?)?.trim();
      combatTrigger = StoryCombatSpec(
        tier: tier,
        opponentId: safeOpponent,
        weaknessStacks: context.arc.weaknessStacks,
        reason: (reason == null || reason.isEmpty)
            ? (pt ? 'Confronto na Névoa' : 'Clash in the Mist')
            : reason,
      );
    } else if (trigger == StoryTriggerType.combatTrigger) {
      trigger = StoryTriggerType.narrative;
    }

    final rawChoices = payload['choices'] as List<dynamic>? ?? const [];
    final choices = <StoryChoiceOption>[];
    for (var i = 0; i < rawChoices.length && choices.length < 4; i++) {
      final item = rawChoices[i];
      if (item is! Map<String, dynamic>) continue;
      final label = (item['label'] as String?)?.trim() ?? '';
      if (label.isEmpty) continue;
      final prompt = (item['actionPrompt'] as String?)?.trim();
      final optTrigger = _parseEnum(
        StoryTriggerType.values,
        item['triggerType'] as String?,
        StoryTriggerType.narrative,
      );
      final attr = item['attribute'] is String
          ? _parseNullableEnum(Attribute.values, item['attribute'] as String)
          : null;
      final diff = item['difficulty'] is String
          ? _parseEnum(
              StoryCheckDifficulty.values,
              item['difficulty'] as String,
              StoryCheckDifficulty.medium,
            )
          : StoryCheckDifficulty.medium;
      final combatTier = item['combatTier'] is String
          ? _parseNullableEnum(
              StoryCombatTier.values,
              item['combatTier'] as String,
            )
          : null;
      final optOpp = optTrigger == StoryTriggerType.combatTrigger
          ? _sanitizeOpponentId(
              rawId: item['opponentId'] as String?,
              tier: combatTier ?? StoryCombatTier.normal,
              weeklyBossId: context.arc.weeklyBossId,
            )
          : null;

      choices.add(
        StoryChoiceOption(
          id: (item['id'] as String?)?.trim().isNotEmpty == true
              ? (item['id'] as String).trim()
              : 'ai_choice_$i',
          label: label,
          actionPrompt: (prompt != null && prompt.isNotEmpty) ? prompt : label,
          triggerType: optTrigger == StoryTriggerType.chapterComplete
              ? StoryTriggerType.narrative
              : optTrigger,
          attribute: attr ??
              (optTrigger == StoryTriggerType.skillCheck
                  ? Attribute.wisdom
                  : null),
          difficulty: diff,
          combatTier: combatTier,
          opponentId: optOpp,
        ),
      );
    }

    if (choices.isEmpty) {
      choices.add(
        StoryChoiceOption(
          id: 'ai_continue',
          label: pt ? 'Seguir pelas cinzas' : 'Press through the ash',
          actionPrompt: pt
              ? 'Avanço com cautela pelo próximo corredor.'
              : 'I advance carefully into the next passage.',
          triggerType: StoryTriggerType.narrative,
        ),
      );
    }

    StoryNpcMemory? npcUpdate;
    if (payload['npcUpdate'] is Map<String, dynamic>) {
      final npc = StoryNpcMemory.fromJson(
        payload['npcUpdate'] as Map<String, dynamic>,
      );
      if (npc.id.isNotEmpty && npc.name.isNotEmpty) {
        npcUpdate = npc;
      }
    }

    return StorySceneResponse(
      narration: narration,
      locationName: safeLocation,
      triggerType: trigger,
      choices: choices,
      skillCheck: skillCheck,
      combatTrigger: combatTrigger,
      placeVisited: (payload['placeVisited'] as String?)?.trim(),
      npcUpdate: npcUpdate,
      memorySummary: (payload['memorySummary'] as String?)?.trim(),
      isAiGenerated: true,
    );
  }

  static String _stripMarkdownFences(String raw) {
    var trimmed = raw.trim();
    if (trimmed.startsWith('```')) {
      final firstNewline = trimmed.indexOf('\n');
      if (firstNewline >= 0) {
        trimmed = trimmed.substring(firstNewline + 1);
      }
      if (trimmed.endsWith('```')) {
        trimmed = trimmed.substring(0, trimmed.length - 3);
      }
    }
    return trimmed.trim();
  }

  static String _sanitizeOpponentId({
    required String? rawId,
    required StoryCombatTier tier,
    required String weeklyBossId,
  }) {
    final clean = (rawId ?? '').trim();
    if (tier == StoryCombatTier.legendary) {
      return LegendaryBossCatalog.byId(clean)?.id ?? weeklyBossId;
    }
    if (ArenaCatalog.byId(clean) != null) return clean;
    if (LegendaryBossCatalog.byId(clean) != null) return clean;
    return ArenaCatalog.opponents.first.id;
  }

  static T _parseEnum<T extends Enum>(
    List<T> values,
    String? raw,
    T fallbackValue,
  ) =>
      _parseNullableEnum(values, raw) ?? fallbackValue;

  static T? _parseNullableEnum<T extends Enum>(List<T> values, String? raw) {
    if (raw == null) return null;
    final norm = raw.trim().toLowerCase();
    for (final v in values) {
      if (v.name.toLowerCase() == norm) return v;
    }
    return null;
  }
}
