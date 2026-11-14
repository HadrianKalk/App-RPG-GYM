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
  String get routinesTitle => 'Rotinas Populares';

  @override
  String get routinePushTitle => 'Push · Peito, Ombro e Tríceps';

  @override
  String get routinePushSubtitle =>
      'Supino, Militar, Elevação Lateral, Paralelas';

  @override
  String get routinePullTitle => 'Pull · Costas e Bíceps';

  @override
  String get routinePullSubtitle => 'Barra Fixa, Remada, Face Pull, Rosca';

  @override
  String get routineLegsTitle => 'Legs · Pernas e Glúteos';

  @override
  String get routineLegsSubtitle =>
      'Agachamento, Stiff, Leg Press, Panturrilha';

  @override
  String get routineCardioTitle => 'Cardio & Mobilidade';

  @override
  String get routineCardioSubtitle => 'Corrida, Corda, Prancha, Alongamento';

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
}
