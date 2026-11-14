// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get brandSubtitle => 'The Heroes\' Forge';

  @override
  String get commonContinue => 'Continue';

  @override
  String get commonBack => 'Back';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonGreat => 'Great';

  @override
  String get commonGo => 'Go';

  @override
  String get commonSettings => 'Settings';

  @override
  String xpGain(String xp) {
    return '+$xp XP';
  }

  @override
  String minutesShort(int minutes) {
    return '$minutes min';
  }

  @override
  String plusMinutes(int minutes) {
    return '+$minutes min';
  }

  @override
  String loadError(String error) {
    return 'Failed to load: $error';
  }

  @override
  String get navHero => 'Hero';

  @override
  String get navWorkout => 'Workout';

  @override
  String get navActivities => 'Activities';

  @override
  String get navQuests => 'Quests';

  @override
  String get characterExperience => 'Experience';

  @override
  String characterXpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String characterLevel(int level) {
    return 'Level $level';
  }

  @override
  String get characterAttributes => 'Attributes';

  @override
  String characterNextPoint(int percent) {
    return '$percent% to +1';
  }

  @override
  String get inspirationTooltip =>
      'Inspiration: earn it by completing daily quests';

  @override
  String get onbBegin => 'Begin the Journey';

  @override
  String get onbForge => 'Forge Hero';

  @override
  String get onbPrologue =>
      'In the grey lands, heroes are not chosen by the gods. They are forged — rep after rep, night after night, through pain and discipline.';

  @override
  String get onbLoreTraining =>
      'Real workouts forge Strength, Dexterity and Constitution.';

  @override
  String get onbLoreMind => 'Study sharpens Intelligence; meditation, Wisdom.';

  @override
  String get onbLoreClass =>
      'Your class is not chosen: it emerges from your habits.';

  @override
  String get onbNameTitle => 'Who are you?';

  @override
  String get onbNameSubtitle =>
      'The name the bards will sing — or the crows will forget.';

  @override
  String get onbNameLabel => 'Hero name';

  @override
  String get onbFormQuestion => 'How should the narrator refer to you?';

  @override
  String get onbOriginTitle => 'Where do you come from?';

  @override
  String get onbOriginSubtitle =>
      'Your origin is only story: it does not change your attributes. Your effort decides your numbers.';

  @override
  String get onbOathTitle => 'Your oath';

  @override
  String get onbOathSubtitle =>
      'Why do you train? The narrator will remember it in hard times. (Optional)';

  @override
  String get onbOathHint =>
      'E.g.: Get strong enough to carry my kids without back pain.';

  @override
  String onbSummaryLine(String title, String origin) {
    return '$title · $origin · Level 1';
  }

  @override
  String get onbSummaryNote =>
      'Every attribute starts at 10. From now on, every workout, every page studied and every good night of sleep counts.';

  @override
  String onbForgeError(String error) {
    return 'Could not forge the hero: $error';
  }

  @override
  String get nameErrorEmpty => 'Every hero needs a name.';

  @override
  String get nameErrorTooShort => 'Name too short.';

  @override
  String nameErrorTooLong(int max) {
    return 'Maximum of $max characters.';
  }

  @override
  String get workoutTitle => 'Workout';

  @override
  String get workoutForgeTitle => 'Forge the Body';

  @override
  String get workoutForgeBody =>
      'Every set feeds Strength, Dexterity and Constitution. Personal Records grant instant bonus XP.';

  @override
  String get workoutStartEmpty => 'Start empty workout';

  @override
  String get workoutDefaultTitle => 'Free Workout';

  @override
  String get routinesTitle => 'Popular Routines';

  @override
  String get routinePushTitle => 'Push · Chest, Shoulders & Triceps';

  @override
  String get routinePushSubtitle =>
      'Bench, Overhead Press, Lateral Raise, Dips';

  @override
  String get routinePullTitle => 'Pull · Back & Biceps';

  @override
  String get routinePullSubtitle => 'Pull-Up, Rows, Face Pull, Curls';

  @override
  String get routineLegsTitle => 'Legs · Legs & Glutes';

  @override
  String get routineLegsSubtitle => 'Squat, RDL, Leg Press, Calves';

  @override
  String get routineCardioTitle => 'Cardio & Mobility';

  @override
  String get routineCardioSubtitle => 'Running, Jump Rope, Plank, Stretching';

  @override
  String get activeEmpty => 'No exercises added yet.';

  @override
  String get addExercise => 'Add exercise';

  @override
  String get exerciseShort => 'Exercise';

  @override
  String get finishWorkout => 'Finish';

  @override
  String get restLabel => 'Rest';

  @override
  String get restSkip => 'Skip';

  @override
  String get colSet => 'SET';

  @override
  String get colKg => 'KG';

  @override
  String get colReps => 'REPS';

  @override
  String get addSet => 'Add set';

  @override
  String get workoutDoneTitle => 'Workout Complete!';

  @override
  String workoutDuration(String duration) {
    return 'Duration: $duration';
  }

  @override
  String get workoutDoneFlavor => 'The iron yields. You don\'t.';

  @override
  String get workoutDoneButton => 'Back to the Forge';

  @override
  String get pickerSearchHint => 'Search exercise...';

  @override
  String get pickerAll => 'All';

  @override
  String get pickerEmpty => 'No exercise found.';

  @override
  String get activitiesTitle => 'Activities';

  @override
  String get pomodoroTitle => 'Pomodoro Focus';

  @override
  String get pomodoroSubjectHint => 'What are you studying?';

  @override
  String get pomodoroDefaultSubject => 'Focused study';

  @override
  String get timerStart => 'Start';

  @override
  String get timerPause => 'Pause';

  @override
  String get timerFinishNow => 'Finish now';

  @override
  String get healthSection => 'Rest & Health';

  @override
  String get sleepTitle => 'Restful Sleep';

  @override
  String hoursValue(String hours) {
    return '$hours h';
  }

  @override
  String get sleepLog => 'Log last night\'s sleep';

  @override
  String get wisdomSection => 'Wisdom & Presence';

  @override
  String get meditationTitle => 'Meditation & Journal';

  @override
  String get meditationSubtitle => 'Mental stillness and presence';

  @override
  String get rewardIntTitle => 'Mind Forged!';

  @override
  String rewardIntMessage(int minutes) {
    return '$minutes minutes of focus logged.';
  }

  @override
  String get rewardConTitle => 'Body Restored!';

  @override
  String rewardConMessage(String hours) {
    return '$hours hours of rest logged.';
  }

  @override
  String get rewardWisTitle => 'Inner Stillness';

  @override
  String rewardWisMessage(int minutes) {
    return '$minutes minutes of presence and reflection.';
  }

  @override
  String get questsTitle => 'Daily Quests';

  @override
  String get questsBanner =>
      'Quests strengthen your weak points and advance on their own from what you log. Every completed quest grants ✦ Inspiration.';

  @override
  String get questsToday => 'Today\'s Objectives';

  @override
  String questProgress(int current, int target, String unit) {
    return '$current / $target $unit';
  }

  @override
  String get questHintStrength => 'Advances when you finish a workout.';

  @override
  String get questHintDexterity =>
      'Advances with mobility exercises in a workout.';

  @override
  String get questHintConstitution =>
      'Advances with cardio in a workout or 8h+ of sleep.';

  @override
  String get questHintIntelligence => 'Advances with Pomodoro sessions.';

  @override
  String get questHintWisdom => 'Advances by logging meditation.';

  @override
  String get questHintCharisma => 'Charisma logging is coming soon.';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get languageSystem => 'Device default';

  @override
  String get settingsFont => 'Font style';

  @override
  String get fontPixel => 'Pixel';

  @override
  String get fontClassic => 'Classic';

  @override
  String get fontPreview => 'Level 7 · Strength 14';

  @override
  String get settingsAbout => 'About';

  @override
  String get creditsTitle => 'Credits';

  @override
  String get creditsSubtitle => 'Those who help forge this world';

  @override
  String get creditsIntro =>
      'This game exists thanks to those who believed in it from the first spark.';

  @override
  String get creditsPeople => 'Forge Companions';

  @override
  String get creditRoleSupport => 'Support & ideas';

  @override
  String get creditsFonts => 'Fonts';

  @override
  String get creditsFontsBody =>
      'Jersey 10, Inter and Cinzel — SIL Open Font License.';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }
}
