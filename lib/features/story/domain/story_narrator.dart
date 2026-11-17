import '../../../core/game/class_resolver.dart';
import '../../../core/game/combat.dart';
import '../../../core/game/hero_profile.dart';
import '../../../core/game/story.dart';

/// Read-only context handed to any [StoryNarrator] (offline or AI).
///
/// The narrator must never invent XP, attribute scores, DCs, or combat HP;
/// those are derived solely by the game engine.
final class StoryNarrationContext {
  const StoryNarrationContext({
    required this.languageCode,
    required this.heroProfile,
    required this.heroLevel,
    required this.effectiveClass,
    required this.heroStats,
    required this.arc,
    required this.habits,
    this.playerInput,
    this.selectedChoice,
  });

  final String languageCode;
  final HeroProfile heroProfile;
  final int heroLevel;
  final CharacterClass effectiveClass;
  final CombatStats heroStats;
  final StoryArcState arc;
  final StoryHabitDigest habits;

  /// Free-text action typed by the player (e.g. "I confront the hooded figure").
  final String? playerInput;

  /// Choice button tapped by the player, if they chose a preset option.
  final StoryChoiceOption? selectedChoice;
}

/// Structured output returned by a [StoryNarrator] for a scene turn.
final class StorySceneResponse {
  const StorySceneResponse({
    required this.narration,
    required this.locationName,
    required this.triggerType,
    required this.choices,
    this.skillCheck,
    this.combatTrigger,
    this.placeVisited,
    this.npcUpdate,
    this.memorySummary,
    this.isAiGenerated = false,
    this.fallbackReason,
  });

  final String narration;
  final String locationName;
  final StoryTriggerType triggerType;
  final List<StoryChoiceOption> choices;
  final StorySkillCheckSpec? skillCheck;
  final StoryCombatSpec? combatTrigger;
  final String? placeVisited;
  final StoryNpcMemory? npcUpdate;
  final String? memorySummary;

  /// True when authored by the live AI Game Master; false for offline templates.
  final bool isAiGenerated;

  /// Sanitized diagnostic note when AI narration failed and fell back to offline.
  final String? fallbackReason;

  /// Returns a copy carrying [reason] (used when annotating offline fallbacks).
  StorySceneResponse withFallbackReason(String reason) => StorySceneResponse(
        narration: narration,
        locationName: locationName,
        triggerType: triggerType,
        choices: choices,
        skillCheck: skillCheck,
        combatTrigger: combatTrigger,
        placeVisited: placeVisited,
        npcUpdate: npcUpdate,
        memorySummary: memorySummary,
        isAiGenerated: isAiGenerated,
        fallbackReason: reason,
      );
}

/// Swappable narrator contract (Offline Template or Remote AI Game Master).
abstract interface class StoryNarrator {
  /// Generates the opening scene or responds to the player's action/choice.
  Future<StorySceneResponse> advanceScene(StoryNarrationContext context);

  /// Narrates the aftermath of an interactive D20 skill check result.
  Future<StorySceneResponse> narrateSkillCheckOutcome({
    required StoryNarrationContext context,
    required StorySkillCheckSpec check,
    required D20RollResult roll,
    required bool usedInspirationReroll,
  });

  /// Narrates the aftermath of a live 16-bit combat encounter triggered in Story.
  Future<StorySceneResponse> narrateCombatOutcome({
    required StoryNarrationContext context,
    required StoryCombatSpec combat,
    required CombatEncounter finishedEncounter,
  });
}
