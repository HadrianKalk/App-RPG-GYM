import 'dart:convert';

import 'package:app/core/game/attributes.dart';
import 'package:app/core/game/class_resolver.dart';
import 'package:app/core/game/combat.dart';
import 'package:app/core/game/hero_profile.dart';
import 'package:app/core/game/story.dart';
import 'package:app/features/settings/data/settings_repository.dart';
import 'package:app/features/settings/domain/app_settings.dart';
import 'package:app/features/story/domain/gemini_story_narrator.dart';
import 'package:app/features/story/domain/story_narrator.dart';
import 'package:app/features/story/domain/world_lore_prompt.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  CombatStats sampleStats() => CombatStats.fromHero(
        level: 8,
        characterClass: CharacterClass.paladin,
        attributeScores: {for (final a in Attribute.values) a: 15},
      );

  HeroProfile customHero() => HeroProfile(
        name: 'Seraphina',
        form: HeroForm.feminine,
        origin: HeroOrigin.custom,
        customOriginName: 'Guardiã das Cinzas',
        customOriginStory: 'Sobrevivente do cerco à cidadela.',
        createdAt: DateTime(2026, 11, 1),
      );

  StoryNarrationContext sampleContext({String? input}) {
    const habits = StoryHabitDigest(
      workoutsToday: 1,
      workoutsThisWeek: 4,
      questsCompletedThisWeek: 4,
      trainedAttributesToday: [Attribute.strength, Attribute.constitution],
      waterCupsToday: 6,
      lastSleepHours: 8.0,
    );
    final arc = StoryEngine.startOrResumeWeeklyArc(
      now: DateTime(2026, 11, 16),
      habits: habits,
    );
    return StoryNarrationContext(
      languageCode: 'pt',
      heroProfile: customHero(),
      heroLevel: 8,
      effectiveClass: CharacterClass.paladin,
      heroStats: sampleStats(),
      arc: arc,
      habits: habits,
      playerInput: input,
    );
  }

  test('WorldLorePrompt includes World Bible, custom origin, habits, and Weekly Boss', () {
    final ctx = sampleContext(input: 'Inspeciono o altar antigo.');
    final sys = WorldLorePrompt.buildSystemPrompt('pt');
    final turn = WorldLorePrompt.buildTurnPrompt(ctx);

    expect(sys, contains('Grindheim'));
    expect(sys, contains('Portuguese (pt-BR)'));
    expect(sys, contains('NEVER invent numbers'));
    expect(turn, contains('Seraphina'));
    expect(turn, contains('feminine'));
    expect(turn, contains('Guardiã das Cinzas'));
    expect(turn, contains('Sobrevivente do cerco à cidadela.'));
    expect(turn, contains(ctx.arc.weeklyBossId));
    expect(turn, contains('${ctx.arc.weaknessStacks}/7'));
  });

  test('GeminiStoryNarrator uses offline fallback when API key is blank', () async {
    var calledNetwork = false;
    final narrator = GeminiStoryNarrator(
      apiKey: '   ',
      poster: ({required url, required body, timeout = const Duration(seconds: 18)}) async {
        calledNetwork = true;
        return '{}';
      },
    );

    final res = await narrator.advanceScene(sampleContext(input: 'Olho ao redor'));
    expect(calledNetwork, isFalse);
    expect(res.isAiGenerated, isFalse);
    expect(res.choices, isNotEmpty);
  });

  test('GeminiStoryNarrator parses strict JSON skillCheck and computes DC via engine', () async {
    final aiPayload = {
      'narration': 'A névoa se abre diante de Seraphina revelando runas pulsantes.',
      'locationName': 'Santuário das Runas',
      'triggerType': 'skillCheck',
      'skillCheck': {
        'attribute': 'intelligence',
        'difficulty': 'hard',
        'reason': 'Decifrar o selo rúnico',
      },
      'combatTrigger': null,
      'choices': [
        {
          'id': 'c1',
          'label': 'Forçar o portão (FOR)',
          'actionPrompt': 'Uso minha força no portão.',
          'triggerType': 'skillCheck',
          'attribute': 'strength',
          'difficulty': 'medium',
        },
      ],
      'placeVisited': 'Santuário das Runas',
      'npcUpdate': {
        'id': 'eldon',
        'name': 'Eldon',
        'attitude': 'ally',
        'lastNote': 'Ajudou na decifração.',
      },
      'memorySummary': 'Encontrou o Santuário das Runas.',
    };

    final geminiEnvelope = jsonEncode({
      'candidates': [
        {
          'content': {
            'parts': [
              {'text': '```json\n${jsonEncode(aiPayload)}\n```'},
            ],
          },
        },
      ],
    });

    final narrator = GeminiStoryNarrator(
      apiKey: 'AIza-test-key',
      poster: ({required url, required body, timeout = const Duration(seconds: 18)}) async {
        expect(url.toString(), contains('generateContent'));
        expect(url.queryParameters['key'], 'AIza-test-key');
        return geminiEnvelope;
      },
    );

    final ctx = sampleContext(input: 'Tento ler o selo antigo');
    final res = await narrator.advanceScene(ctx);

    expect(res.isAiGenerated, isTrue);
    expect(res.triggerType, StoryTriggerType.skillCheck);
    expect(res.skillCheck?.attribute, Attribute.intelligence);
    expect(
      res.skillCheck?.difficultyClass,
      StoryEngine.computeDifficultyClass(8, StoryCheckDifficulty.hard),
    );
    expect(res.npcUpdate?.id, 'eldon');
    expect(res.choices.single.attribute, Attribute.strength);
  });

  test('GeminiStoryNarrator sanitizes hallucinated legendary opponentId and falls back on errors', () async {
    final hallucinatedEnvelope = jsonEncode({
      'candidates': [
        {
          'content': {
            'parts': [
              {
                'text': jsonEncode({
                  'narration': 'O chefe aparece na neblina!',
                  'locationName': 'Altar',
                  'triggerType': 'combatTrigger',
                  'combatTrigger': {
                    'tier': 'legendary',
                    'opponentId': 'invented_boss_999',
                    'reason': 'Confronto direto',
                  },
                  'choices': [],
                }),
              },
            ],
          },
        },
      ],
    });

    final narrator = GeminiStoryNarrator(
      apiKey: 'AIza-test-key',
      poster: ({required url, required body, timeout = const Duration(seconds: 18)}) async =>
          hallucinatedEnvelope,
    );

    final ctx = sampleContext(input: 'Desafiar chefe!');
    final res = await narrator.advanceScene(ctx);
    expect(res.isAiGenerated, isTrue);
    expect(res.triggerType, StoryTriggerType.combatTrigger);
    expect(res.combatTrigger?.opponentId, ctx.arc.weeklyBossId);
    expect(res.choices, isNotEmpty);

    // Network/JSON failure falls back to offline TemplateStoryNarrator with sanitized reason.
    final brokenNarrator = GeminiStoryNarrator(
      apiKey: 'AIza-secret-test-key',
      poster: ({required url, required body, timeout = const Duration(seconds: 18)}) async =>
          throw StateError(
            'AI HTTP 400 at $url: {"error":{"code":400,"message":"API key not valid."}}',
          ),
    );
    final fallbackRes = await brokenNarrator.advanceScene(ctx);
    expect(fallbackRes.isAiGenerated, isFalse);
    expect(fallbackRes.fallbackReason, isNotNull);
    expect(fallbackRes.fallbackReason, isNot(contains('AIza-secret-test-key')));
  });

  test('GeminiStoryNarrator testConnection reports success and sanitizes HTTP errors', () async {
    final okNarrator = GeminiStoryNarrator(
      apiKey: 'AIza-secret-ok',
      poster: ({required url, required body, timeout = const Duration(seconds: 18)}) async =>
          jsonEncode({
        'candidates': [
          {
            'content': {
              'parts': [
                {'text': 'OK'},
              ],
            },
          },
        ],
      }),
    );
    final ok = await okNarrator.testConnection();
    expect(ok.ok, isTrue);
    expect(ok.error, isNull);

    final badKeyNarrator = GeminiStoryNarrator(
      apiKey: 'AIza-secret-bad',
      poster: ({required url, required body, timeout = const Duration(seconds: 18)}) async =>
          throw StateError(
            'AI HTTP 400: {"error":{"code":400,"message":"Key AIza-secret-bad not valid. key=AIza-secret-bad"}}',
          ),
    );
    final bad = await badKeyNarrator.testConnection();
    expect(bad.ok, isFalse);
    expect(bad.error, contains('HTTP 400'));
    expect(bad.error, isNot(contains('AIza-secret-bad')));
  });

  test('SettingsRepository persists local Gemini BYOK key and model cleanly', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repo = SettingsRepository(prefs);

    await repo.save(
      const AppSettings(
        languageCode: 'pt',
        geminiApiKey: 'AIza-local-secret',
        geminiModel: 'gemini-2.5-pro',
      ),
    );
    final loaded = repo.load();
    expect(loaded.hasGeminiKey, isTrue);
    expect(loaded.geminiApiKey, 'AIza-local-secret');
    expect(loaded.geminiModel, 'gemini-2.5-pro');
  });
}
