// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get brandSubtitle => 'A Forja dos Heróis';

  @override
  String get commonContinue => 'Continuar';

  @override
  String get commonBack => 'Voltar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonGreat => 'Ótimo';

  @override
  String get commonGo => 'Ir';

  @override
  String get commonSettings => 'Configurações';

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
    return 'Erro ao carregar: $error';
  }

  @override
  String get navHero => 'Herói';

  @override
  String get navWorkout => 'Treino';

  @override
  String get navActivities => 'Atividades';

  @override
  String get navQuests => 'Missões';

  @override
  String get characterExperience => 'Experiência';

  @override
  String characterXpProgress(int current, int next) {
    return '$current / $next XP';
  }

  @override
  String characterLevel(int level) {
    return 'Nível $level';
  }

  @override
  String get characterAttributes => 'Atributos';

  @override
  String characterNextPoint(int percent) {
    return '$percent% para +1';
  }

  @override
  String get inspirationTooltip =>
      'Inspiração: ganhe completando missões diárias';

  @override
  String get onbBegin => 'Iniciar a Jornada';

  @override
  String get onbForge => 'Forjar Herói';

  @override
  String get onbPrologue =>
      'Nas terras cinzentas, heróis não nascem escolhidos pelos deuses. Eles se forjam — repetição após repetição, noite após noite, na dor e na disciplina.';

  @override
  String get onbLoreTraining =>
      'Treinos reais forjam Força, Destreza e Constituição.';

  @override
  String get onbLoreMind =>
      'Estudo afia a Inteligência; meditação, a Sabedoria.';

  @override
  String get onbLoreClass =>
      'Sua classe não é escolhida: ela emerge dos seus hábitos.';

  @override
  String get onbNameTitle => 'Quem é você?';

  @override
  String get onbNameSubtitle =>
      'O nome que os bardos cantarão — ou que os corvos esquecerão.';

  @override
  String get onbNameLabel => 'Nome do herói';

  @override
  String get onbFormQuestion => 'Como o narrador deve se referir a você?';

  @override
  String get onbOriginTitle => 'De onde você veio?';

  @override
  String get onbOriginSubtitle =>
      'Sua origem é apenas história: ela não muda seus atributos. Quem decide seus números é o seu esforço.';

  @override
  String get onbOathTitle => 'Seu juramento';

  @override
  String get onbOathSubtitle =>
      'Por que você treina? O narrador lembrará disso nos momentos difíceis. (Opcional)';

  @override
  String get onbOathHint =>
      'Ex.: Ficar forte o bastante para carregar meus filhos sem dor nas costas.';

  @override
  String onbSummaryLine(String title, String origin) {
    return '$title · $origin · Nível 1';
  }

  @override
  String get onbSummaryNote =>
      'Todos os atributos começam em 10. A partir de agora, cada treino, cada página estudada e cada noite bem dormida conta.';

  @override
  String onbForgeError(String error) {
    return 'Não foi possível forjar o herói: $error';
  }

  @override
  String get nameErrorEmpty => 'Todo herói precisa de um nome.';

  @override
  String get nameErrorTooShort => 'Nome muito curto.';

  @override
  String nameErrorTooLong(int max) {
    return 'Máximo de $max caracteres.';
  }

  @override
  String get workoutTitle => 'Treino';

  @override
  String get workoutForgeTitle => 'Forjar o Corpo';

  @override
  String get workoutForgeBody =>
      'Cada série alimenta Força, Destreza e Constituição. Recordes Pessoais dão XP bônus na hora.';

  @override
  String get workoutStartEmpty => 'Iniciar treino vazio';

  @override
  String get workoutDefaultTitle => 'Treino Livre';

  @override
  String get activeEmpty => 'Nenhum exercício adicionado ainda.';

  @override
  String get addExercise => 'Adicionar exercício';

  @override
  String get exerciseShort => 'Exercício';

  @override
  String get finishWorkout => 'Finalizar';

  @override
  String get restLabel => 'Descanso';

  @override
  String get restSkip => 'Pular';

  @override
  String get colSet => 'SÉRIE';

  @override
  String get colKg => 'KG';

  @override
  String get colReps => 'REPS';

  @override
  String get addSet => 'Adicionar série';

  @override
  String get workoutDoneTitle => 'Treino Concluído!';

  @override
  String workoutDuration(String duration) {
    return 'Duração: $duration';
  }

  @override
  String get workoutDoneFlavor => 'O ferro cede, e você não.';

  @override
  String get workoutDoneButton => 'Retornar à Forja';

  @override
  String get pickerSearchHint => 'Buscar exercício...';

  @override
  String get pickerAll => 'Todos';

  @override
  String get pickerEmpty => 'Nenhum exercício encontrado.';

  @override
  String get activitiesTitle => 'Atividades';

  @override
  String get pomodoroTitle => 'Foco Pomodoro';

  @override
  String get pomodoroSubjectHint => 'O que você está estudando?';

  @override
  String get pomodoroDefaultSubject => 'Estudo focado';

  @override
  String get timerStart => 'Iniciar';

  @override
  String get timerPause => 'Pausar';

  @override
  String get timerFinishNow => 'Concluir agora';

  @override
  String get healthSection => 'Descanso & Saúde';

  @override
  String get sleepTitle => 'Sono Reparador';

  @override
  String hoursValue(String hours) {
    return '$hours h';
  }

  @override
  String get sleepLog => 'Registrar sono de ontem';

  @override
  String get wisdomSection => 'Sabedoria & Presença';

  @override
  String get meditationTitle => 'Meditação & Diário';

  @override
  String get meditationSubtitle => 'Quietude mental e presença';

  @override
  String get rewardIntTitle => 'Mente Forjada!';

  @override
  String rewardIntMessage(int minutes) {
    return '$minutes minutos de foco registrados.';
  }

  @override
  String get rewardConTitle => 'Corpo Recuperado!';

  @override
  String rewardConMessage(String hours) {
    return '$hours horas de descanso registradas.';
  }

  @override
  String get rewardWisTitle => 'Quietude Interior';

  @override
  String rewardWisMessage(int minutes) {
    return '$minutes minutos de presença e reflexão.';
  }

  @override
  String get questsTitle => 'Missões Diárias';

  @override
  String get questsBanner =>
      'Missões fortalecem seus pontos fracos e avançam sozinhas com o que você registra. Cada missão cumprida vale ✦ Inspiração.';

  @override
  String get questsToday => 'Objetivos de Hoje';

  @override
  String questProgress(int current, int target, String unit) {
    return '$current / $target $unit';
  }

  @override
  String get questHintStrength => 'Avança ao finalizar um treino.';

  @override
  String get questHintDexterity =>
      'Avança com exercícios de mobilidade no treino.';

  @override
  String get questHintConstitution =>
      'Avança com cardio no treino ou 8h+ de sono.';

  @override
  String get questHintIntelligence => 'Avança com sessões de Pomodoro.';

  @override
  String get questHintWisdom => 'Avança registrando meditação.';

  @override
  String get questHintCharisma => 'Registro de Carisma chega em breve.';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get languageSystem => 'Padrão do aparelho';

  @override
  String get settingsFont => 'Estilo da fonte';

  @override
  String get fontPixel => 'Pixel';

  @override
  String get fontClassic => 'Clássica';

  @override
  String get fontPreview => 'Nível 7 · Força 14';

  @override
  String get settingsAbout => 'Sobre';

  @override
  String get creditsTitle => 'Créditos';

  @override
  String get creditsSubtitle => 'Quem ajuda a forjar este mundo';

  @override
  String get creditsIntro =>
      'Este jogo existe graças a quem acreditou nele desde a primeira faísca.';

  @override
  String get creditsPeople => 'Companheiros de Forja';

  @override
  String get creditRoleSupport => 'Apoio e ideias';

  @override
  String get creditsFonts => 'Fontes';

  @override
  String get creditsFontsBody =>
      'Jersey 10, Inter e Cinzel — SIL Open Font License.';

  @override
  String appVersion(String version) {
    return 'Versão $version';
  }

  @override
  String get routinesTemplates => 'Modelos para começar';

  @override
  String get routinesMine => 'Minhas Rotinas';

  @override
  String get routinesNew => 'Nova rotina';

  @override
  String get routinesEmpty =>
      'Você ainda não criou rotinas. Monte a sua com os exercícios do app, ou copie um modelo.';

  @override
  String routineExerciseCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count exercícios',
      one: '1 exercício',
    );
    return '$_temp0';
  }

  @override
  String get routineStart => 'Iniciar treino';

  @override
  String get routineEdit => 'Editar';

  @override
  String get routineDuplicate => 'Copiar para minhas rotinas';

  @override
  String routineCopyName(String name) {
    return '$name (cópia)';
  }

  @override
  String get commonDelete => 'Excluir';

  @override
  String routineDeleteConfirm(String name) {
    return 'Excluir a rotina \"$name\"?';
  }

  @override
  String get editorTitleNew => 'Nova Rotina';

  @override
  String get editorTitleEdit => 'Editar Rotina';

  @override
  String get editorNameLabel => 'Nome da rotina';

  @override
  String get editorNameRequired => 'Dê um nome à rotina.';

  @override
  String get editorNoExercises => 'Adicione pelo menos um exercício.';

  @override
  String get editorSave => 'Salvar rotina';

  @override
  String get editorSets => 'Séries';

  @override
  String get editorRepsMin => 'Reps mín.';

  @override
  String get editorRepsMax => 'Reps máx.';

  @override
  String get editorDuration => 'Tempo';

  @override
  String get editorRest => 'Descanso';

  @override
  String get editorToFailure => 'Até a falha';

  @override
  String get editorRemove => 'Remover';

  @override
  String get editorReorderHint => 'Segure e arraste para reordenar.';

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
    return '$sets × até a falha';
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
      other: '$sets séries',
      one: '1 série',
    );
    return '$_temp0';
  }

  @override
  String targetRest(String time) {
    return 'descanso $time';
  }

  @override
  String get colPrevious => 'ANTERIOR';

  @override
  String get colTime => 'TEMPO';

  @override
  String get timeHint => 'm:ss';

  @override
  String get workoutDiscard => 'Descartar treino';

  @override
  String get workoutDiscardTitle => 'Descartar este treino?';

  @override
  String get workoutDiscardBody =>
      'As séries não serão salvas e nenhum XP será concedido.';

  @override
  String get workoutKeepGoing => 'Continuar treinando';

  @override
  String get workoutNeedOneSet =>
      'Marque pelo menos uma série como concluída para finalizar.';

  @override
  String get workoutRecordsTitle => 'Recordes Pessoais';

  @override
  String workoutRecordLine(String name, String weight, int reps) {
    return '$name: $weight kg × $reps';
  }

  @override
  String get workoutBaseline => 'primeira marca';

  @override
  String workoutSetsDone(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count séries concluídas',
      one: '1 série concluída',
    );
    return '$_temp0';
  }

  @override
  String get exerciseRemove => 'Remover exercício';

  @override
  String get setRemove => 'Remover série';

  @override
  String get onbCustomOriginName => 'Nome da sua origem';

  @override
  String get onbCustomOriginNameHint => 'Ex.: Caçador das Montanhas';

  @override
  String get onbCustomOriginStory => 'Sua história (opcional)';

  @override
  String get onbCustomOriginStoryHint =>
      'De onde você veio? O que te trouxe até a forja?';

  @override
  String get setComplete => 'Concluir série';

  @override
  String rewardsSetsLine(int count) {
    return 'Séries efetivas ($count)';
  }

  @override
  String rewardsRecordLine(String name, String weight) {
    return 'Recorde Pessoal · $name $weight kg';
  }

  @override
  String rewardsQuestLine(String title) {
    return 'Missão: $title';
  }

  @override
  String bonusGoalMet(int day, int goal) {
    return 'Meta da semana cumprida ($day/$goal)';
  }

  @override
  String bonusBeyondDuty(int day) {
    return 'Além do Dever · $dayº dia de treino';
  }

  @override
  String bonusFlame(int weeks) {
    return 'Chama da Constância · $weeks semanas';
  }

  @override
  String bonusFlameReason(int percent) {
    return '+$percent% sobre os bônus da semana';
  }

  @override
  String get bonusWeekLabel => 'Semana';

  @override
  String get rewardsTotal => 'Total';

  @override
  String rewardsLevelUp(int level) {
    return 'Nível $level alcançado!';
  }

  @override
  String rewardsAttributeUp(String attribute, int score) {
    return '$attribute subiu para $score!';
  }

  @override
  String rewardsWeekProgress(int day, int goal) {
    return '$day/$goal dias de treino nesta semana';
  }

  @override
  String get rewardsWeekDone => 'Meta semanal batida!';

  @override
  String get rewardsNoWeeklyBonus =>
      'Você já treinou hoje: bônus semanais contam um treino por dia.';

  @override
  String get commonContinueShort => 'Continuar';

  @override
  String get streakTitle => 'Chama da Constância';

  @override
  String streakWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count semanas',
      one: '1 semana',
      zero: '0 semanas',
    );
    return '$_temp0';
  }

  @override
  String streakWeekStatus(int done, int goal) {
    return '$done/$goal nesta semana';
  }

  @override
  String streakGoalHit(int done, int goal) {
    return '$done/$goal · meta batida!';
  }

  @override
  String get weekdayLetters => 'S,T,Q,Q,S,S,D';

  @override
  String get historyTitle => 'Histórico';

  @override
  String get historyOpen => 'Histórico & Recordes';

  @override
  String get historyOpenSubtitle =>
      'Treinos passados, calendário e evolução de carga';

  @override
  String get historyTabWorkouts => 'Treinos';

  @override
  String get historyTabCalendar => 'Calendário';

  @override
  String get historyTabRecords => 'Recordes';

  @override
  String get historyEmpty => 'Nenhum treino finalizado ainda. A forja espera.';

  @override
  String get recordsEmpty =>
      'Nenhum recorde ainda. Termine um treino com carga para registrar suas marcas.';

  @override
  String historyVolume(String volume) {
    return '$volume kg';
  }

  @override
  String historyRecords(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count recordes',
      one: '1 recorde',
    );
    return '$_temp0';
  }

  @override
  String calendarMonthDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias de treino',
      one: '1 dia de treino',
      zero: 'Nenhum dia de treino',
    );
    return '$_temp0';
  }

  @override
  String recordBest(String weight, int reps) {
    return 'Melhor: $weight kg × $reps';
  }

  @override
  String recordE1rm(String value) {
    return '1RM estimado: $value kg';
  }

  @override
  String get progressTitle => 'Evolução';

  @override
  String get progressChartE1rm => '1RM estimado por treino (kg)';

  @override
  String get progressChartDuration => 'Melhor tempo por treino';

  @override
  String get progressChartReps => 'Mais repetições por treino';

  @override
  String get progressEmpty => 'Sem dados ainda.';

  @override
  String get progressSessions => 'Treinos com este exercício';

  @override
  String get settingsTraining => 'Treino';

  @override
  String get settingsWeeklyGoal => 'Meta semanal';

  @override
  String get settingsWeeklyGoalHint =>
      'Dias de treino por semana. Bater a meta dá bônus; cada dia acima dela dá ainda mais.';

  @override
  String settingsWeeklyGoalValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count dias',
      one: '1 dia',
    );
    return '$_temp0';
  }

  @override
  String get settingsWaterGoal => 'Meta diária de água';

  @override
  String get settingsWaterGoalHint =>
      'Copos de 250 ml por dia. Cada copo até a meta concede XP de Constituição, com bônus ao atingir a meta.';

  @override
  String settingsWaterGoalValue(int cups, int ml) {
    return '$cups copos ($ml ml)';
  }

  @override
  String get hydrationTitle => 'Hidratação Diária';

  @override
  String get hydrationSubtitle =>
      'Cada copo (250 ml) até a meta fortalece Constituição.';

  @override
  String hydrationProgress(int cups, int goal, int ml) {
    return '$cups/$goal copos · $ml ml';
  }

  @override
  String get hydrationAddCup => '+1 copo (250 ml)';

  @override
  String get hydrationGoalMetBadge => 'Meta de água batida hoje!';

  @override
  String get hydrationBonusLine => 'Meta diária de hidratação batida';

  @override
  String get dietTitle => 'Nutrição & Dieta';

  @override
  String get dietSubtitle =>
      'Check-in diário de consistência alimentar (sem contagem neurótica).';

  @override
  String get dietOnTrackButton => 'Plano cumprido';

  @override
  String get dietPartialButton => 'Parcial / Equilibrado';

  @override
  String get dietDoneOnTrack => 'Check-in de hoje: Plano alimentar cumprido';

  @override
  String get dietDonePartial =>
      'Check-in de hoje: Alimentação parcial / equilibrada';

  @override
  String sleepLoggedToday(String hours) {
    return 'Último registro hoje: $hours h';
  }

  @override
  String get activitiesCatalogSection => 'Catálogo de Hábitos & Práticas';

  @override
  String get activitiesCustomButton => 'Registrar outra atividade';

  @override
  String get customActivityTitle => 'Nova Atividade';

  @override
  String get customActivityNameLabel => 'O que você praticou?';

  @override
  String get customActivityNameHint =>
      'Ex.: Aula de violão, conversa com amigo, trilha...';

  @override
  String get customActivityDefaultName => 'Prática focada';

  @override
  String get customActivityAttributeLabel => 'Atributo trabalhado';

  @override
  String get customActivityDurationLabel => 'Duração (minutos)';

  @override
  String get customActivityIntensityLabel => 'Intensidade';

  @override
  String get intensityLightLabel => 'Leve';

  @override
  String get intensityModerateLabel => 'Moderada';

  @override
  String get intensityHardLabel => 'Intensa';

  @override
  String get customActivitySubmit => 'Concluir e receber XP';

  @override
  String get activityRewardTitle => 'Atividade Concluída!';

  @override
  String activityRewardBaseLine(String name, int minutes) {
    return '$name ($minutes min)';
  }

  @override
  String get exerciseGuideTooltip => 'Como executar';

  @override
  String get exerciseGuideTitle => 'Guia de Execução';

  @override
  String get exerciseGuideStepsTitle => 'Passo a passo & Postura';

  @override
  String get exerciseGuideSpriteNote =>
      'Ilustração em pixel art do movimento em breve.';

  @override
  String get dailyCurveNote =>
      'Fôlego do Dia: parte do esforço entrou na curva diária de recuperação deste atributo. Seus recordes, missões e bônus continuam valendo 100%!';

  @override
  String get arenaBannerTitle => 'Arena da Forja';

  @override
  String get arenaBannerSubtitle =>
      'Desafie campeões NPC para conquistar títulos e cosméticos (sem ganho de XP)';

  @override
  String arenaTokensBadge(int remaining, int total) {
    return 'Fichas hoje: $remaining/$total';
  }

  @override
  String arenaChampionsBadge(int defeated, int total) {
    return 'Campeões: $defeated/$total';
  }

  @override
  String get heroCustomizeButton => 'Títulos & Cosméticos';

  @override
  String get heroTitlesSection => 'Títulos de Combate';

  @override
  String get heroCosmeticsSection => 'Cosméticos de Herói';

  @override
  String get heroUnequip => 'Nenhum (desequipar)';

  @override
  String heroLockedHint(String npc) {
    return 'Derrote $npc na Arena para desbloquear';
  }

  @override
  String get arenaScreenTitle => 'Arena da Forja';

  @override
  String get arenaTokensExplain =>
      '2 entradas grátis/dia + 1 por treino + 1 por missão diária + 1 por hábito de saúde.';

  @override
  String get arenaNoTokens =>
      'Sem fichas de Arena disponíveis hoje. Conclua um treino, missão ou meta de saúde para ganhar mais!';

  @override
  String arenaRecommendedLevel(int level) {
    return 'Nv. rec. $level';
  }

  @override
  String get arenaChallengeButton => 'Desafiar (1 ficha)';

  @override
  String arenaVictoriesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vitórias',
      one: '1 vitória',
      zero: 'Ainda não derrotado',
    );
    return '$_temp0';
  }

  @override
  String arenaRewardLabel(String title, String cosmetic) {
    return 'Recompensa: $title · $cosmetic';
  }

  @override
  String combatTurnLabel(int turn) {
    return 'Turno $turn';
  }

  @override
  String get combatHpLabel => 'PV';

  @override
  String get combatFocusLabel => 'FOCO';

  @override
  String get combatIntentStrike => 'Intenção: Ataque Direto';

  @override
  String get combatIntentHeavy =>
      'Intenção: Golpe Pesado (defenda ou atordoe!)';

  @override
  String get combatIntentGuard => 'Intenção: Postura Defensiva';

  @override
  String get combatActionBasic => 'Golpe Básico (+3 Foco)';

  @override
  String combatActionSkill(String name, int cost) {
    return '$name ($cost Foco)';
  }

  @override
  String combatActionSkillCooldown(String name, int turns) {
    return '$name (${turns}t)';
  }

  @override
  String get combatActionDefend => 'Defender (-50% dano, +Foco/+PV)';

  @override
  String combatActionInspiration(int count) {
    return 'Inspiração Heroica (Crítico · $count)';
  }

  @override
  String get combatLogTitle => 'Registro de Batalha';

  @override
  String combatLogHeroBasic(int turn, int dmg, String crit) {
    return 'T$turn: Seu golpe causou $dmg de dano$crit.';
  }

  @override
  String combatLogHeroSkill(int turn, String skill, int dmg, String crit) {
    return 'T$turn: $skill causou $dmg de dano$crit!';
  }

  @override
  String combatLogHeroSkillHeal(int turn, String skill, int dmg, int heal) {
    return 'T$turn: $skill causou $dmg de dano e curou $heal PV!';
  }

  @override
  String combatLogHeroDefend(int turn, int heal) {
    return 'T$turn: Postura defensiva (+$heal PV, +Foco).';
  }

  @override
  String combatLogHeroInspiration(int turn, int dmg) {
    return 'T$turn: Inspiração Heroica! Crítico devastador de $dmg de dano!';
  }

  @override
  String combatLogEnemyStrike(int turn, int dmg) {
    return 'T$turn: O oponente atacou causando $dmg de dano.';
  }

  @override
  String combatLogEnemyHeavy(int turn, int dmg) {
    return 'T$turn: Golpe Pesado do oponente causou $dmg de dano!';
  }

  @override
  String combatLogEnemyGuard(int turn, int heal) {
    return 'T$turn: O oponente ergueu guarda e recuperou $heal PV.';
  }

  @override
  String combatLogEnemyStunned(int turn) {
    return 'T$turn: O oponente está atordoado e perdeu o turno!';
  }

  @override
  String combatLogEnemyDodged(int turn) {
    return 'T$turn: O oponente esquivou do seu ataque!';
  }

  @override
  String combatLogHeroDodged(int turn) {
    return 'T$turn: Você esquivou do ataque inimigo!';
  }

  @override
  String get combatVictoryTitle => 'Vitória na Arena!';

  @override
  String get combatDefeatTitle => 'Derrota na Arena';

  @override
  String get combatDefeatBody =>
      'O oponente prevaleceu desta vez. Fortaleça seus atributos com treinos e hábitos reais e volte mais forte!';

  @override
  String get combatUnlockedReward => 'Recompensas Desbloqueadas!';

  @override
  String get combatAlreadyUnlocked =>
      'Recompensas deste campeão já estão na sua coleção.';

  @override
  String get combatEquipNow => 'Equipar agora';

  @override
  String get combatBackToArena => 'Voltar à Arena';
}
