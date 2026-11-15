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

  @override
  String get routinesTemplates => 'Starter templates';

  @override
  String get routinesMine => 'My Routines';

  @override
  String get routinesNew => 'New routine';

  @override
  String get routinesEmpty =>
      'You haven\'t created routines yet. Build one from the app\'s exercises, or copy a template.';

  @override
  String routineExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercises',
      one: '1 exercise',
    );
    return '$_temp0';
  }

  @override
  String get routineStart => 'Start workout';

  @override
  String get routineEdit => 'Edit';

  @override
  String get routineDuplicate => 'Copy to my routines';

  @override
  String routineCopyName(String name) {
    return '$name (copy)';
  }

  @override
  String get commonDelete => 'Delete';

  @override
  String routineDeleteConfirm(String name) {
    return 'Delete the routine \"$name\"?';
  }

  @override
  String get editorTitleNew => 'New Routine';

  @override
  String get editorTitleEdit => 'Edit Routine';

  @override
  String get editorNameLabel => 'Routine name';

  @override
  String get editorNameRequired => 'Give the routine a name.';

  @override
  String get editorNoExercises => 'Add at least one exercise.';

  @override
  String get editorSave => 'Save routine';

  @override
  String get editorSets => 'Sets';

  @override
  String get editorRepsMin => 'Min reps';

  @override
  String get editorRepsMax => 'Max reps';

  @override
  String get editorDuration => 'Time';

  @override
  String get editorRest => 'Rest';

  @override
  String get editorToFailure => 'To failure';

  @override
  String get editorRemove => 'Remove';

  @override
  String get editorReorderHint => 'Hold and drag to reorder.';

  @override
  String targetReps(int sets, int min, int max) {
    return '$sets × $min–$max reps';
  }

  @override
  String targetRepsFixed(int sets, int reps) {
    return '$sets × $reps reps';
  }

  @override
  String targetFailure(int sets) {
    return '$sets × to failure';
  }

  @override
  String targetDuration(int sets, String time) {
    return '$sets × $time';
  }

  @override
  String targetSetsOnly(int sets) {
    String _temp0 = intl.Intl.pluralLogic(
      sets,
      locale: localeName,
      other: '$sets sets',
      one: '1 set',
    );
    return '$_temp0';
  }

  @override
  String targetRest(String time) {
    return 'rest $time';
  }

  @override
  String get colPrevious => 'PREVIOUS';

  @override
  String get colTime => 'TIME';

  @override
  String get timeHint => 'm:ss';

  @override
  String get workoutDiscard => 'Discard workout';

  @override
  String get workoutDiscardTitle => 'Discard this workout?';

  @override
  String get workoutDiscardBody =>
      'Sets won\'t be saved and no XP will be granted.';

  @override
  String get workoutKeepGoing => 'Keep training';

  @override
  String get workoutNeedOneSet => 'Check at least one set as done to finish.';

  @override
  String get workoutRecordsTitle => 'Personal Records';

  @override
  String workoutRecordLine(String name, String weight, int reps) {
    return '$name: $weight kg × $reps';
  }

  @override
  String get workoutBaseline => 'first mark';

  @override
  String workoutSetsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sets done',
      one: '1 set done',
    );
    return '$_temp0';
  }

  @override
  String get exerciseRemove => 'Remove exercise';

  @override
  String get setRemove => 'Remove set';

  @override
  String get onbCustomOriginName => 'Your origin\'s name';

  @override
  String get onbCustomOriginNameHint => 'E.g.: Mountain Hunter';

  @override
  String get onbCustomOriginStory => 'Your story (optional)';

  @override
  String get onbCustomOriginStoryHint =>
      'Where do you come from? What brought you to the forge?';

  @override
  String get setComplete => 'Complete set';

  @override
  String rewardsSetsLine(int count) {
    return 'Working sets ($count)';
  }

  @override
  String rewardsRecordLine(String name, String weight) {
    return 'Personal Record · $name $weight kg';
  }

  @override
  String rewardsQuestLine(String title) {
    return 'Quest: $title';
  }

  @override
  String bonusGoalMet(int day, int goal) {
    return 'Weekly goal met ($day/$goal)';
  }

  @override
  String bonusBeyondDuty(int day) {
    return 'Beyond Duty · training day $day';
  }

  @override
  String bonusFlame(int weeks) {
    return 'Flame of Constancy · $weeks weeks';
  }

  @override
  String bonusFlameReason(int percent) {
    return '+$percent% on this week\'s bonuses';
  }

  @override
  String get bonusWeekLabel => 'Week';

  @override
  String get rewardsTotal => 'Total';

  @override
  String rewardsLevelUp(int level) {
    return 'Level $level reached!';
  }

  @override
  String rewardsAttributeUp(String attribute, int score) {
    return '$attribute rose to $score!';
  }

  @override
  String rewardsWeekProgress(int day, int goal) {
    return '$day/$goal training days this week';
  }

  @override
  String get rewardsWeekDone => 'Weekly goal smashed!';

  @override
  String get rewardsNoWeeklyBonus =>
      'You already trained today: weekly bonuses count one workout per day.';

  @override
  String get commonContinueShort => 'Continue';

  @override
  String get streakTitle => 'Flame of Constancy';

  @override
  String streakWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count weeks',
      one: '1 week',
      zero: '0 weeks',
    );
    return '$_temp0';
  }

  @override
  String streakWeekStatus(int done, int goal) {
    return '$done/$goal this week';
  }

  @override
  String streakGoalHit(int done, int goal) {
    return '$done/$goal · goal hit!';
  }

  @override
  String get weekdayLetters => 'M,T,W,T,F,S,S';

  @override
  String get historyTitle => 'History';

  @override
  String get historyOpen => 'History & Records';

  @override
  String get historyOpenSubtitle => 'Past workouts, calendar and load progress';

  @override
  String get historyTabWorkouts => 'Workouts';

  @override
  String get historyTabCalendar => 'Calendar';

  @override
  String get historyTabRecords => 'Records';

  @override
  String get historyEmpty => 'No finished workouts yet. The forge awaits.';

  @override
  String get recordsEmpty =>
      'No records yet. Finish a weighted workout to set your marks.';

  @override
  String historyVolume(String volume) {
    return '$volume kg';
  }

  @override
  String historyRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count records',
      one: '1 record',
    );
    return '$_temp0';
  }

  @override
  String calendarMonthDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count training days',
      one: '1 training day',
      zero: 'No training days',
    );
    return '$_temp0';
  }

  @override
  String recordBest(String weight, int reps) {
    return 'Best: $weight kg × $reps';
  }

  @override
  String recordE1rm(String value) {
    return 'Estimated 1RM: $value kg';
  }

  @override
  String get progressTitle => 'Progress';

  @override
  String get progressChartE1rm => 'Estimated 1RM per workout (kg)';

  @override
  String get progressChartDuration => 'Best time per workout';

  @override
  String get progressChartReps => 'Most reps per workout';

  @override
  String get progressEmpty => 'No data yet.';

  @override
  String get progressSessions => 'Workouts with this exercise';

  @override
  String get settingsTraining => 'Training';

  @override
  String get settingsWeeklyGoal => 'Weekly goal';

  @override
  String get settingsWeeklyGoalHint =>
      'Training days per week. Hitting the goal grants a bonus; each day beyond it grants more.';

  @override
  String settingsWeeklyGoalValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days',
      one: '1 day',
    );
    return '$_temp0';
  }

  @override
  String get settingsWaterGoal => 'Daily water goal';

  @override
  String get settingsWaterGoalHint =>
      '250 ml cups per day. Every cup up to the goal grants Constitution XP, plus a bonus when you hit the goal.';

  @override
  String settingsWaterGoalValue(int cups, int ml) {
    return '$cups cups ($ml ml)';
  }

  @override
  String get hydrationTitle => 'Daily Hydration';

  @override
  String get hydrationSubtitle =>
      'Each cup (250 ml) up to your goal builds Constitution.';

  @override
  String hydrationProgress(int cups, int goal, int ml) {
    return '$cups/$goal cups · $ml ml';
  }

  @override
  String get hydrationAddCup => '+1 cup (250 ml)';

  @override
  String get hydrationGoalMetBadge => 'Water goal met today!';

  @override
  String get hydrationBonusLine => 'Daily hydration goal met';

  @override
  String get dietTitle => 'Nutrition & Diet';

  @override
  String get dietSubtitle =>
      'Daily food consistency check-in (no neurotic calorie counting).';

  @override
  String get dietOnTrackButton => 'On track';

  @override
  String get dietPartialButton => 'Partial / Balanced';

  @override
  String get dietDoneOnTrack => 'Today\'s check-in: Nutrition plan on track';

  @override
  String get dietDonePartial =>
      'Today\'s check-in: Partial / balanced nutrition';

  @override
  String sleepLoggedToday(String hours) {
    return 'Last logged today: $hours h';
  }

  @override
  String get activitiesCatalogSection => 'Habit & Practice Catalog';

  @override
  String get activitiesCustomButton => 'Log another activity';

  @override
  String get customActivityTitle => 'Log Activity';

  @override
  String get customActivityNameLabel => 'What did you practice?';

  @override
  String get customActivityNameHint =>
      'e.g. Guitar practice, catching up with a friend, hike...';

  @override
  String get customActivityDefaultName => 'Focused practice';

  @override
  String get customActivityAttributeLabel => 'Trained attribute';

  @override
  String get customActivityDurationLabel => 'Duration (minutes)';

  @override
  String get customActivityIntensityLabel => 'Intensity';

  @override
  String get intensityLightLabel => 'Light';

  @override
  String get intensityModerateLabel => 'Moderate';

  @override
  String get intensityHardLabel => 'Hard';

  @override
  String get customActivitySubmit => 'Complete & claim XP';

  @override
  String get activityRewardTitle => 'Activity Complete!';

  @override
  String activityRewardBaseLine(String name, int minutes) {
    return '$name ($minutes min)';
  }

  @override
  String get exerciseGuideTooltip => 'How to perform';

  @override
  String get exerciseGuideTitle => 'Execution Guide';

  @override
  String get exerciseGuideStepsTitle => 'Step-by-step & Form';

  @override
  String get exerciseGuideSpriteNote =>
      'Pixel-art movement illustration coming soon.';

  @override
  String get dailyCurveNote =>
      'Daily Stamina: part of today\'s effort entered this attribute\'s recovery curve. Your records, quests and bonuses still count 100%!';

  @override
  String get arenaBannerTitle => 'Forge Arena';

  @override
  String get arenaBannerSubtitle =>
      'Challenge NPC champions to unlock titles and cosmetics (no XP granted)';

  @override
  String arenaTokensBadge(int remaining, int total) {
    return 'Tokens today: $remaining/$total';
  }

  @override
  String arenaChampionsBadge(int defeated, int total) {
    return 'Champions: $defeated/$total';
  }

  @override
  String get heroCustomizeButton => 'Titles & Cosmetics';

  @override
  String get heroTitlesSection => 'Combat Titles';

  @override
  String get heroCosmeticsSection => 'Hero Cosmetics';

  @override
  String get heroUnequip => 'None (unequip)';

  @override
  String heroLockedHint(String npc) {
    return 'Defeat $npc in the Arena to unlock';
  }

  @override
  String get arenaScreenTitle => 'Forge Arena';

  @override
  String get arenaTokensExplain =>
      '2 free entries/day + 1 per workout + 1 per daily quest + 1 per health habit.';

  @override
  String get arenaNoTokens =>
      'No Arena tokens left today. Complete a workout, quest, or health habit to earn more!';

  @override
  String arenaRecommendedLevel(int level) {
    return 'Rec. Lv. $level';
  }

  @override
  String get arenaChallengeButton => 'Challenge (1 token)';

  @override
  String arenaVictoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count victories',
      one: '1 victory',
      zero: 'Not defeated yet',
    );
    return '$_temp0';
  }

  @override
  String arenaRewardLabel(String title, String cosmetic) {
    return 'Reward: $title · $cosmetic';
  }

  @override
  String combatTurnLabel(int turn) {
    return 'Turn $turn';
  }

  @override
  String get combatHpLabel => 'HP';

  @override
  String get combatFocusLabel => 'FOCUS';

  @override
  String get combatIntentStrike => 'Intent: Direct Strike';

  @override
  String get combatIntentHeavy => 'Intent: Heavy Blow (defend or stun!)';

  @override
  String get combatIntentGuard => 'Intent: Defensive Guard';

  @override
  String get combatActionBasic => 'Basic Strike (+3 Focus)';

  @override
  String combatActionSkill(String name, int cost) {
    return '$name ($cost Focus)';
  }

  @override
  String combatActionSkillCooldown(String name, int turns) {
    return '$name (${turns}t)';
  }

  @override
  String get combatActionDefend => 'Defend (-50% dmg, +Focus/+HP)';

  @override
  String combatActionInspiration(int count) {
    return 'Heroic Inspiration (Crit · $count)';
  }

  @override
  String get combatLogTitle => 'Battle Log';

  @override
  String combatLogHeroBasic(int turn, int dmg, String crit) {
    return 'T$turn: Your strike dealt $dmg damage$crit.';
  }

  @override
  String combatLogHeroSkill(int turn, String skill, int dmg, String crit) {
    return 'T$turn: $skill dealt $dmg damage$crit!';
  }

  @override
  String combatLogHeroSkillHeal(int turn, String skill, int dmg, int heal) {
    return 'T$turn: $skill dealt $dmg damage and healed $heal HP!';
  }

  @override
  String combatLogHeroDefend(int turn, int heal) {
    return 'T$turn: Defensive stance (+$heal HP, +Focus).';
  }

  @override
  String combatLogHeroInspiration(int turn, int dmg) {
    return 'T$turn: Heroic Inspiration! Devastating critical for $dmg damage!';
  }

  @override
  String combatLogEnemyStrike(int turn, int dmg) {
    return 'T$turn: Opponent struck for $dmg damage.';
  }

  @override
  String combatLogEnemyHeavy(int turn, int dmg) {
    return 'T$turn: Opponent\'s Heavy Blow dealt $dmg damage!';
  }

  @override
  String combatLogEnemyGuard(int turn, int heal) {
    return 'T$turn: Opponent guarded and recovered $heal HP.';
  }

  @override
  String combatLogEnemyStunned(int turn) {
    return 'T$turn: Opponent is stunned and lost their turn!';
  }

  @override
  String combatLogEnemyDodged(int turn) {
    return 'T$turn: Opponent dodged your attack!';
  }

  @override
  String combatLogHeroDodged(int turn) {
    return 'T$turn: You dodged the enemy attack!';
  }

  @override
  String get combatVictoryTitle => 'Arena Victory!';

  @override
  String get combatDefeatTitle => 'Arena Defeat';

  @override
  String get combatDefeatBody =>
      'The opponent prevailed this time. Strengthen your attributes with real-world workouts and habits and return stronger!';

  @override
  String get combatUnlockedReward => 'Rewards Unlocked!';

  @override
  String get combatAlreadyUnlocked =>
      'This champion\'s rewards are already in your collection.';

  @override
  String get combatEquipNow => 'Equip now';

  @override
  String get combatBackToArena => 'Back to Arena';

  @override
  String get heroClassSection => 'Hero Class';

  @override
  String heroClassAuto(String className) {
    return 'Automatic (Emergent: $className)';
  }

  @override
  String heroClassUnlockedHint(String skill) {
    return 'Skill: $skill';
  }

  @override
  String heroClassLockedHint(String attr1, String attr2, int score) {
    return 'Requires $attr1 ≥ $score and $attr2 ≥ $score';
  }

  @override
  String heroTournamentLockedHint(String tournament) {
    return 'Win $tournament to unlock';
  }

  @override
  String get arenaTabDuels => '1v1 Duels';

  @override
  String get arenaTabTournaments => 'Tournaments';

  @override
  String tournamentRoundsBadge(int rounds) {
    return '$rounds rounds';
  }

  @override
  String tournamentRoundProgress(int current, int total) {
    return 'Round $current/$total';
  }

  @override
  String get tournamentEnterButton => 'Enter Tournament (1 token)';

  @override
  String tournamentNextRoundTitle(int round) {
    return 'Round $round Cleared!';
  }

  @override
  String get tournamentNextRoundBody =>
      'You recover +35% HP and +50% Focus before the next challenger.';

  @override
  String tournamentNextRoundButton(int next) {
    return 'Advance to Round $next';
  }

  @override
  String get tournamentVictoryTitle => 'Tournament Champion!';

  @override
  String get navCombat => 'Combat';

  @override
  String get combatHubTitle => 'Combat Hub';

  @override
  String get combatHubSubtitle =>
      'Put your real-world attributes to the test in duels, tournaments, and dungeons (zero XP — prestige rewards).';

  @override
  String get combatBackToHub => 'Back to Modes';

  @override
  String get combatModeStoryTitle => 'Story Mode · Forge Chronicles';

  @override
  String get combatModeStoryBadge => 'COMING SOON · PHASE 2';

  @override
  String get combatModeStoryDescription =>
      'Dark narrative campaign guided by the Game Master. Your choices, your origin, and the real level of your 6 attributes will unlock unique paths, dialogues, and trials.';

  @override
  String get combatModeDuelsTitle => 'Duel Arena (1v1)';

  @override
  String get combatModeDuelsDescription =>
      'Tactical turn-based 1v1 duels against Forge champions. Roll d20 + your primary attribute against the enemy\'s Armor Class (AC), unleash your class skill, and claim exclusive titles and cosmetics.';

  @override
  String get combatModeDuelsButton => 'Enter 1v1 Arena';

  @override
  String get combatModeTournamentsTitle => 'Forge Tournaments (Gauntlet)';

  @override
  String combatModeTournamentsBadge(int won, int total) {
    return 'Tournaments: $won/$total';
  }

  @override
  String get combatModeTournamentsDescription =>
      'Multi-round elimination brackets fought sequentially. Opponents scale in power with each league and your hero recovers only part of their HP (+35%) and Focus (+50%) between fights.';

  @override
  String get combatModeTournamentsButton => 'View Tournament Brackets';

  @override
  String get combatModeDungeonsTitle => 'Deep Dungeons';

  @override
  String combatModeDungeonsBadge(int completed, int total) {
    return 'Dungeons: $completed/$total';
  }

  @override
  String get combatModeDungeonsDescription =>
      'Explore hazardous chambers filled with traps, arcane riddles, and trials that test all 6 attributes on the d20 before facing the Dungeon Boss.';

  @override
  String get combatModeDungeonsButton => 'Explore Dungeons';

  @override
  String combatArmorClassLabel(int ac) {
    return 'AC $ac';
  }

  @override
  String get combatD20CritTitle => 'NATURAL 20! CRITICAL HIT (2× DAMAGE)!';

  @override
  String get combatD20FumbleTitle => 'NATURAL 1! CRITICAL FUMBLE!';

  @override
  String combatD20HitTitle(int total, int ac) {
    return 'HIT! (Total $total vs AC $ac)';
  }

  @override
  String combatD20MissTitle(int total, int ac) {
    return 'MISS! (Total $total vs AC $ac)';
  }

  @override
  String combatD20Formula(
    int roll,
    String attr,
    String mod,
    int prof,
    int total,
    String targetLabel,
    int target,
  ) {
    return 'd20 ($roll) + $attr ($mod) + Prof (+$prof) = $total vs $targetLabel $target';
  }

  @override
  String combatLogHeroFumble(int turn, int dmg) {
    return 'T$turn: CRITICAL FUMBLE (Nat 1)! You left your guard open and took $dmg damage!';
  }

  @override
  String get dungeonEnterButton => 'Explore Dungeon (1 token)';

  @override
  String dungeonRoomsBadge(int rooms) {
    return '$rooms rooms + Boss';
  }

  @override
  String dungeonRoomProgress(int current, int total) {
    return 'Room $current/$total';
  }

  @override
  String dungeonDifficultyLabel(int dc) {
    return 'DC $dc';
  }

  @override
  String dungeonRoomCheckButton(String attr, int dc) {
    return 'Roll d20 + $attr (DC $dc)';
  }

  @override
  String get dungeonRoomBypassButton => 'Cautious Bypass (-5% HP, -3 Focus)';

  @override
  String get dungeonRoomBlessingTitle => 'Trial Overcome!';

  @override
  String dungeonRoomBlessingBody(String attr, int hp) {
    return 'Your mastery of $attr cleared the way! You recovered +$hp HP, +Focus, and gained +1 Blessing for the Boss.';
  }

  @override
  String get dungeonRoomTrapTitle => 'Trap Triggered!';

  @override
  String dungeonRoomTrapBody(int dmg) {
    return 'The trial took its toll: you suffered $dmg damage crossing the chamber.';
  }

  @override
  String get dungeonRoomBypassTitle => 'Cautious Passage';

  @override
  String dungeonRoomBypassBody(int dmg) {
    return 'You bypassed the hazard via the long route, spending $dmg HP and 3 Focus.';
  }

  @override
  String dungeonNextRoomButton(int next) {
    return 'Advance to Room $next';
  }

  @override
  String get dungeonEnterBossButton => 'Face the Dungeon Boss';

  @override
  String get dungeonVictoryTitle => 'Dungeon Conquered!';

  @override
  String heroDungeonLockedHint(String dungeon) {
    return 'Conquer $dungeon to unlock';
  }

  @override
  String get testerButtonLabel => 'Tester Mode';

  @override
  String get testerActiveBadge => 'TESTER ACTIVE';

  @override
  String get testerSheetTitle => 'Tester Panel (Sandbox)';

  @override
  String get testerSheetSubtitle =>
      'Edit attributes, tokens, and the d20 roll in memory to test combat and classes without altering your real XP history.';

  @override
  String get testerEnableSwitch => 'Enable Tester attribute override';

  @override
  String get testerInfiniteTokens => 'Infinite Combat Tokens';

  @override
  String get testerInspirationLabel => 'Heroic Inspiration';

  @override
  String get testerDiceModeTitle => 'd20 Roll Mode';

  @override
  String get testerDiceRandom => 'Random (1d20)';

  @override
  String get testerDiceForce20 => 'Force 20 (Critical)';

  @override
  String get testerDiceForce1 => 'Force 1 (Fumble)';

  @override
  String get testerPresetNovice => 'Novice (10)';

  @override
  String get testerPresetBalanced => 'Veteran (16)';

  @override
  String get testerPresetLegend => 'Legend (22)';

  @override
  String get testerResetButton => 'Restore Real Attributes';
}
