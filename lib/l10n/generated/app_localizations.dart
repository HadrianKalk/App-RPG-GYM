import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt'),
  ];

  /// No description provided for @brandSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'A Forja dos Heróis'**
  String get brandSubtitle;

  /// No description provided for @commonContinue.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get commonContinue;

  /// No description provided for @commonBack.
  ///
  /// In pt, this message translates to:
  /// **'Voltar'**
  String get commonBack;

  /// No description provided for @commonCancel.
  ///
  /// In pt, this message translates to:
  /// **'Cancelar'**
  String get commonCancel;

  /// No description provided for @commonGreat.
  ///
  /// In pt, this message translates to:
  /// **'Ótimo'**
  String get commonGreat;

  /// No description provided for @commonGo.
  ///
  /// In pt, this message translates to:
  /// **'Ir'**
  String get commonGo;

  /// No description provided for @commonSettings.
  ///
  /// In pt, this message translates to:
  /// **'Configurações'**
  String get commonSettings;

  /// No description provided for @xpGain.
  ///
  /// In pt, this message translates to:
  /// **'+{xp} XP'**
  String xpGain(String xp);

  /// No description provided for @minutesShort.
  ///
  /// In pt, this message translates to:
  /// **'{minutes} min'**
  String minutesShort(int minutes);

  /// No description provided for @plusMinutes.
  ///
  /// In pt, this message translates to:
  /// **'+{minutes} min'**
  String plusMinutes(int minutes);

  /// No description provided for @loadError.
  ///
  /// In pt, this message translates to:
  /// **'Erro ao carregar: {error}'**
  String loadError(String error);

  /// No description provided for @navHero.
  ///
  /// In pt, this message translates to:
  /// **'Herói'**
  String get navHero;

  /// No description provided for @navWorkout.
  ///
  /// In pt, this message translates to:
  /// **'Treino'**
  String get navWorkout;

  /// No description provided for @navActivities.
  ///
  /// In pt, this message translates to:
  /// **'Atividades'**
  String get navActivities;

  /// No description provided for @navQuests.
  ///
  /// In pt, this message translates to:
  /// **'Missões'**
  String get navQuests;

  /// No description provided for @characterExperience.
  ///
  /// In pt, this message translates to:
  /// **'Experiência'**
  String get characterExperience;

  /// No description provided for @characterXpProgress.
  ///
  /// In pt, this message translates to:
  /// **'{current} / {next} XP'**
  String characterXpProgress(int current, int next);

  /// No description provided for @characterLevel.
  ///
  /// In pt, this message translates to:
  /// **'Nível {level}'**
  String characterLevel(int level);

  /// No description provided for @characterAttributes.
  ///
  /// In pt, this message translates to:
  /// **'Atributos'**
  String get characterAttributes;

  /// No description provided for @characterNextPoint.
  ///
  /// In pt, this message translates to:
  /// **'{percent}% para +1'**
  String characterNextPoint(int percent);

  /// No description provided for @inspirationTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Inspiração: ganhe completando missões diárias'**
  String get inspirationTooltip;

  /// No description provided for @onbBegin.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar a Jornada'**
  String get onbBegin;

  /// No description provided for @onbForge.
  ///
  /// In pt, this message translates to:
  /// **'Forjar Herói'**
  String get onbForge;

  /// No description provided for @onbPrologue.
  ///
  /// In pt, this message translates to:
  /// **'Nas terras cinzentas, heróis não nascem escolhidos pelos deuses. Eles se forjam — repetição após repetição, noite após noite, na dor e na disciplina.'**
  String get onbPrologue;

  /// No description provided for @onbLoreTraining.
  ///
  /// In pt, this message translates to:
  /// **'Treinos reais forjam Força, Destreza e Constituição.'**
  String get onbLoreTraining;

  /// No description provided for @onbLoreMind.
  ///
  /// In pt, this message translates to:
  /// **'Estudo afia a Inteligência; meditação, a Sabedoria.'**
  String get onbLoreMind;

  /// No description provided for @onbLoreClass.
  ///
  /// In pt, this message translates to:
  /// **'Sua classe não é escolhida: ela emerge dos seus hábitos.'**
  String get onbLoreClass;

  /// No description provided for @onbNameTitle.
  ///
  /// In pt, this message translates to:
  /// **'Quem é você?'**
  String get onbNameTitle;

  /// No description provided for @onbNameSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'O nome que os bardos cantarão — ou que os corvos esquecerão.'**
  String get onbNameSubtitle;

  /// No description provided for @onbNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome do herói'**
  String get onbNameLabel;

  /// No description provided for @onbFormQuestion.
  ///
  /// In pt, this message translates to:
  /// **'Como o narrador deve se referir a você?'**
  String get onbFormQuestion;

  /// No description provided for @onbOriginTitle.
  ///
  /// In pt, this message translates to:
  /// **'De onde você veio?'**
  String get onbOriginTitle;

  /// No description provided for @onbOriginSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Sua origem é apenas história: ela não muda seus atributos. Quem decide seus números é o seu esforço.'**
  String get onbOriginSubtitle;

  /// No description provided for @onbOathTitle.
  ///
  /// In pt, this message translates to:
  /// **'Seu juramento'**
  String get onbOathTitle;

  /// No description provided for @onbOathSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Por que você treina? O narrador lembrará disso nos momentos difíceis. (Opcional)'**
  String get onbOathSubtitle;

  /// No description provided for @onbOathHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Ficar forte o bastante para carregar meus filhos sem dor nas costas.'**
  String get onbOathHint;

  /// No description provided for @onbSummaryLine.
  ///
  /// In pt, this message translates to:
  /// **'{title} · {origin} · Nível 1'**
  String onbSummaryLine(String title, String origin);

  /// No description provided for @onbSummaryNote.
  ///
  /// In pt, this message translates to:
  /// **'Todos os atributos começam em 10. A partir de agora, cada treino, cada página estudada e cada noite bem dormida conta.'**
  String get onbSummaryNote;

  /// No description provided for @onbForgeError.
  ///
  /// In pt, this message translates to:
  /// **'Não foi possível forjar o herói: {error}'**
  String onbForgeError(String error);

  /// No description provided for @nameErrorEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Todo herói precisa de um nome.'**
  String get nameErrorEmpty;

  /// No description provided for @nameErrorTooShort.
  ///
  /// In pt, this message translates to:
  /// **'Nome muito curto.'**
  String get nameErrorTooShort;

  /// No description provided for @nameErrorTooLong.
  ///
  /// In pt, this message translates to:
  /// **'Máximo de {max} caracteres.'**
  String nameErrorTooLong(int max);

  /// No description provided for @workoutTitle.
  ///
  /// In pt, this message translates to:
  /// **'Treino'**
  String get workoutTitle;

  /// No description provided for @workoutForgeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Forjar o Corpo'**
  String get workoutForgeTitle;

  /// No description provided for @workoutForgeBody.
  ///
  /// In pt, this message translates to:
  /// **'Cada série alimenta Força, Destreza e Constituição. Recordes Pessoais dão XP bônus na hora.'**
  String get workoutForgeBody;

  /// No description provided for @workoutStartEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar treino vazio'**
  String get workoutStartEmpty;

  /// No description provided for @workoutDefaultTitle.
  ///
  /// In pt, this message translates to:
  /// **'Treino Livre'**
  String get workoutDefaultTitle;

  /// No description provided for @activeEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum exercício adicionado ainda.'**
  String get activeEmpty;

  /// No description provided for @addExercise.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar exercício'**
  String get addExercise;

  /// No description provided for @exerciseShort.
  ///
  /// In pt, this message translates to:
  /// **'Exercício'**
  String get exerciseShort;

  /// No description provided for @finishWorkout.
  ///
  /// In pt, this message translates to:
  /// **'Finalizar'**
  String get finishWorkout;

  /// No description provided for @restLabel.
  ///
  /// In pt, this message translates to:
  /// **'Descanso'**
  String get restLabel;

  /// No description provided for @restSkip.
  ///
  /// In pt, this message translates to:
  /// **'Pular'**
  String get restSkip;

  /// No description provided for @colSet.
  ///
  /// In pt, this message translates to:
  /// **'SÉRIE'**
  String get colSet;

  /// No description provided for @colKg.
  ///
  /// In pt, this message translates to:
  /// **'KG'**
  String get colKg;

  /// No description provided for @colReps.
  ///
  /// In pt, this message translates to:
  /// **'REPS'**
  String get colReps;

  /// No description provided for @addSet.
  ///
  /// In pt, this message translates to:
  /// **'Adicionar série'**
  String get addSet;

  /// No description provided for @workoutDoneTitle.
  ///
  /// In pt, this message translates to:
  /// **'Treino Concluído!'**
  String get workoutDoneTitle;

  /// No description provided for @workoutDuration.
  ///
  /// In pt, this message translates to:
  /// **'Duração: {duration}'**
  String workoutDuration(String duration);

  /// No description provided for @workoutDoneFlavor.
  ///
  /// In pt, this message translates to:
  /// **'O ferro cede, e você não.'**
  String get workoutDoneFlavor;

  /// No description provided for @workoutDoneButton.
  ///
  /// In pt, this message translates to:
  /// **'Retornar à Forja'**
  String get workoutDoneButton;

  /// No description provided for @pickerSearchHint.
  ///
  /// In pt, this message translates to:
  /// **'Buscar exercício...'**
  String get pickerSearchHint;

  /// No description provided for @pickerAll.
  ///
  /// In pt, this message translates to:
  /// **'Todos'**
  String get pickerAll;

  /// No description provided for @pickerEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum exercício encontrado.'**
  String get pickerEmpty;

  /// No description provided for @activitiesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Atividades'**
  String get activitiesTitle;

  /// No description provided for @pomodoroTitle.
  ///
  /// In pt, this message translates to:
  /// **'Foco Pomodoro'**
  String get pomodoroTitle;

  /// No description provided for @pomodoroSubjectHint.
  ///
  /// In pt, this message translates to:
  /// **'O que você está estudando?'**
  String get pomodoroSubjectHint;

  /// No description provided for @pomodoroDefaultSubject.
  ///
  /// In pt, this message translates to:
  /// **'Estudo focado'**
  String get pomodoroDefaultSubject;

  /// No description provided for @timerStart.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar'**
  String get timerStart;

  /// No description provided for @timerPause.
  ///
  /// In pt, this message translates to:
  /// **'Pausar'**
  String get timerPause;

  /// No description provided for @timerFinishNow.
  ///
  /// In pt, this message translates to:
  /// **'Concluir agora'**
  String get timerFinishNow;

  /// No description provided for @healthSection.
  ///
  /// In pt, this message translates to:
  /// **'Descanso & Saúde'**
  String get healthSection;

  /// No description provided for @sleepTitle.
  ///
  /// In pt, this message translates to:
  /// **'Sono Reparador'**
  String get sleepTitle;

  /// No description provided for @hoursValue.
  ///
  /// In pt, this message translates to:
  /// **'{hours} h'**
  String hoursValue(String hours);

  /// No description provided for @sleepLog.
  ///
  /// In pt, this message translates to:
  /// **'Registrar sono de ontem'**
  String get sleepLog;

  /// No description provided for @wisdomSection.
  ///
  /// In pt, this message translates to:
  /// **'Sabedoria & Presença'**
  String get wisdomSection;

  /// No description provided for @meditationTitle.
  ///
  /// In pt, this message translates to:
  /// **'Meditação & Diário'**
  String get meditationTitle;

  /// No description provided for @meditationSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Quietude mental e presença'**
  String get meditationSubtitle;

  /// No description provided for @rewardIntTitle.
  ///
  /// In pt, this message translates to:
  /// **'Mente Forjada!'**
  String get rewardIntTitle;

  /// No description provided for @rewardIntMessage.
  ///
  /// In pt, this message translates to:
  /// **'{minutes} minutos de foco registrados.'**
  String rewardIntMessage(int minutes);

  /// No description provided for @rewardConTitle.
  ///
  /// In pt, this message translates to:
  /// **'Corpo Recuperado!'**
  String get rewardConTitle;

  /// No description provided for @rewardConMessage.
  ///
  /// In pt, this message translates to:
  /// **'{hours} horas de descanso registradas.'**
  String rewardConMessage(String hours);

  /// No description provided for @rewardWisTitle.
  ///
  /// In pt, this message translates to:
  /// **'Quietude Interior'**
  String get rewardWisTitle;

  /// No description provided for @rewardWisMessage.
  ///
  /// In pt, this message translates to:
  /// **'{minutes} minutos de presença e reflexão.'**
  String rewardWisMessage(int minutes);

  /// No description provided for @questsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Missões Diárias'**
  String get questsTitle;

  /// No description provided for @questsBanner.
  ///
  /// In pt, this message translates to:
  /// **'Missões fortalecem seus pontos fracos e avançam sozinhas com o que você registra. Cada missão cumprida vale ✦ Inspiração.'**
  String get questsBanner;

  /// No description provided for @questsToday.
  ///
  /// In pt, this message translates to:
  /// **'Objetivos de Hoje'**
  String get questsToday;

  /// No description provided for @questProgress.
  ///
  /// In pt, this message translates to:
  /// **'{current} / {target} {unit}'**
  String questProgress(int current, int target, String unit);

  /// No description provided for @questHintStrength.
  ///
  /// In pt, this message translates to:
  /// **'Avança ao finalizar um treino.'**
  String get questHintStrength;

  /// No description provided for @questHintDexterity.
  ///
  /// In pt, this message translates to:
  /// **'Avança com exercícios de mobilidade no treino.'**
  String get questHintDexterity;

  /// No description provided for @questHintConstitution.
  ///
  /// In pt, this message translates to:
  /// **'Avança com cardio no treino ou 8h+ de sono.'**
  String get questHintConstitution;

  /// No description provided for @questHintIntelligence.
  ///
  /// In pt, this message translates to:
  /// **'Avança com sessões de Pomodoro.'**
  String get questHintIntelligence;

  /// No description provided for @questHintWisdom.
  ///
  /// In pt, this message translates to:
  /// **'Avança registrando meditação.'**
  String get questHintWisdom;

  /// No description provided for @questHintCharisma.
  ///
  /// In pt, this message translates to:
  /// **'Registro de Carisma chega em breve.'**
  String get questHintCharisma;

  /// No description provided for @settingsLanguage.
  ///
  /// In pt, this message translates to:
  /// **'Idioma'**
  String get settingsLanguage;

  /// No description provided for @languageSystem.
  ///
  /// In pt, this message translates to:
  /// **'Padrão do aparelho'**
  String get languageSystem;

  /// No description provided for @settingsFont.
  ///
  /// In pt, this message translates to:
  /// **'Estilo da fonte'**
  String get settingsFont;

  /// No description provided for @fontPixel.
  ///
  /// In pt, this message translates to:
  /// **'Pixel'**
  String get fontPixel;

  /// No description provided for @fontClassic.
  ///
  /// In pt, this message translates to:
  /// **'Clássica'**
  String get fontClassic;

  /// No description provided for @fontPreview.
  ///
  /// In pt, this message translates to:
  /// **'Nível 7 · Força 14'**
  String get fontPreview;

  /// No description provided for @settingsAbout.
  ///
  /// In pt, this message translates to:
  /// **'Sobre'**
  String get settingsAbout;

  /// No description provided for @creditsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Créditos'**
  String get creditsTitle;

  /// No description provided for @creditsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Quem ajuda a forjar este mundo'**
  String get creditsSubtitle;

  /// No description provided for @creditsIntro.
  ///
  /// In pt, this message translates to:
  /// **'Este jogo existe graças a quem acreditou nele desde a primeira faísca.'**
  String get creditsIntro;

  /// No description provided for @creditsPeople.
  ///
  /// In pt, this message translates to:
  /// **'Companheiros de Forja'**
  String get creditsPeople;

  /// No description provided for @creditRoleSupport.
  ///
  /// In pt, this message translates to:
  /// **'Apoio e ideias'**
  String get creditRoleSupport;

  /// No description provided for @creditsFonts.
  ///
  /// In pt, this message translates to:
  /// **'Fontes'**
  String get creditsFonts;

  /// No description provided for @creditsFontsBody.
  ///
  /// In pt, this message translates to:
  /// **'Jersey 10, Inter e Cinzel — SIL Open Font License.'**
  String get creditsFontsBody;

  /// No description provided for @appVersion.
  ///
  /// In pt, this message translates to:
  /// **'Versão {version}'**
  String appVersion(String version);

  /// No description provided for @routinesTemplates.
  ///
  /// In pt, this message translates to:
  /// **'Modelos para começar'**
  String get routinesTemplates;

  /// No description provided for @routinesMine.
  ///
  /// In pt, this message translates to:
  /// **'Minhas Rotinas'**
  String get routinesMine;

  /// No description provided for @routinesNew.
  ///
  /// In pt, this message translates to:
  /// **'Nova rotina'**
  String get routinesNew;

  /// No description provided for @routinesEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Você ainda não criou rotinas. Monte a sua com os exercícios do app, ou copie um modelo.'**
  String get routinesEmpty;

  /// No description provided for @routineExerciseCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 exercício} other{{count} exercícios}}'**
  String routineExerciseCount(int count);

  /// No description provided for @routineStart.
  ///
  /// In pt, this message translates to:
  /// **'Iniciar treino'**
  String get routineStart;

  /// No description provided for @routineEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar'**
  String get routineEdit;

  /// No description provided for @routineDuplicate.
  ///
  /// In pt, this message translates to:
  /// **'Copiar para minhas rotinas'**
  String get routineDuplicate;

  /// No description provided for @routineCopyName.
  ///
  /// In pt, this message translates to:
  /// **'{name} (cópia)'**
  String routineCopyName(String name);

  /// No description provided for @commonDelete.
  ///
  /// In pt, this message translates to:
  /// **'Excluir'**
  String get commonDelete;

  /// No description provided for @routineDeleteConfirm.
  ///
  /// In pt, this message translates to:
  /// **'Excluir a rotina \"{name}\"?'**
  String routineDeleteConfirm(String name);

  /// No description provided for @editorTitleNew.
  ///
  /// In pt, this message translates to:
  /// **'Nova Rotina'**
  String get editorTitleNew;

  /// No description provided for @editorTitleEdit.
  ///
  /// In pt, this message translates to:
  /// **'Editar Rotina'**
  String get editorTitleEdit;

  /// No description provided for @editorNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'Nome da rotina'**
  String get editorNameLabel;

  /// No description provided for @editorNameRequired.
  ///
  /// In pt, this message translates to:
  /// **'Dê um nome à rotina.'**
  String get editorNameRequired;

  /// No description provided for @editorNoExercises.
  ///
  /// In pt, this message translates to:
  /// **'Adicione pelo menos um exercício.'**
  String get editorNoExercises;

  /// No description provided for @editorSave.
  ///
  /// In pt, this message translates to:
  /// **'Salvar rotina'**
  String get editorSave;

  /// No description provided for @editorSets.
  ///
  /// In pt, this message translates to:
  /// **'Séries'**
  String get editorSets;

  /// No description provided for @editorRepsMin.
  ///
  /// In pt, this message translates to:
  /// **'Reps mín.'**
  String get editorRepsMin;

  /// No description provided for @editorRepsMax.
  ///
  /// In pt, this message translates to:
  /// **'Reps máx.'**
  String get editorRepsMax;

  /// No description provided for @editorDuration.
  ///
  /// In pt, this message translates to:
  /// **'Tempo'**
  String get editorDuration;

  /// No description provided for @editorRest.
  ///
  /// In pt, this message translates to:
  /// **'Descanso'**
  String get editorRest;

  /// No description provided for @editorToFailure.
  ///
  /// In pt, this message translates to:
  /// **'Até a falha'**
  String get editorToFailure;

  /// No description provided for @editorRemove.
  ///
  /// In pt, this message translates to:
  /// **'Remover'**
  String get editorRemove;

  /// No description provided for @editorReorderHint.
  ///
  /// In pt, this message translates to:
  /// **'Segure e arraste para reordenar.'**
  String get editorReorderHint;

  /// No description provided for @targetReps.
  ///
  /// In pt, this message translates to:
  /// **'{sets} × {min}–{max} reps'**
  String targetReps(int sets, int min, int max);

  /// No description provided for @targetRepsFixed.
  ///
  /// In pt, this message translates to:
  /// **'{sets} × {reps} reps'**
  String targetRepsFixed(int sets, int reps);

  /// No description provided for @targetFailure.
  ///
  /// In pt, this message translates to:
  /// **'{sets} × até a falha'**
  String targetFailure(int sets);

  /// No description provided for @targetDuration.
  ///
  /// In pt, this message translates to:
  /// **'{sets} × {time}'**
  String targetDuration(int sets, String time);

  /// No description provided for @targetSetsOnly.
  ///
  /// In pt, this message translates to:
  /// **'{sets, plural, =1{1 série} other{{sets} séries}}'**
  String targetSetsOnly(int sets);

  /// No description provided for @targetRest.
  ///
  /// In pt, this message translates to:
  /// **'descanso {time}'**
  String targetRest(String time);

  /// No description provided for @colPrevious.
  ///
  /// In pt, this message translates to:
  /// **'ANTERIOR'**
  String get colPrevious;

  /// No description provided for @colTime.
  ///
  /// In pt, this message translates to:
  /// **'TEMPO'**
  String get colTime;

  /// No description provided for @timeHint.
  ///
  /// In pt, this message translates to:
  /// **'m:ss'**
  String get timeHint;

  /// No description provided for @workoutDiscard.
  ///
  /// In pt, this message translates to:
  /// **'Descartar treino'**
  String get workoutDiscard;

  /// No description provided for @workoutDiscardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Descartar este treino?'**
  String get workoutDiscardTitle;

  /// No description provided for @workoutDiscardBody.
  ///
  /// In pt, this message translates to:
  /// **'As séries não serão salvas e nenhum XP será concedido.'**
  String get workoutDiscardBody;

  /// No description provided for @workoutKeepGoing.
  ///
  /// In pt, this message translates to:
  /// **'Continuar treinando'**
  String get workoutKeepGoing;

  /// No description provided for @workoutNeedOneSet.
  ///
  /// In pt, this message translates to:
  /// **'Marque pelo menos uma série como concluída para finalizar.'**
  String get workoutNeedOneSet;

  /// No description provided for @workoutRecordsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Recordes Pessoais'**
  String get workoutRecordsTitle;

  /// No description provided for @workoutRecordLine.
  ///
  /// In pt, this message translates to:
  /// **'{name}: {weight} kg × {reps}'**
  String workoutRecordLine(String name, String weight, int reps);

  /// No description provided for @workoutBaseline.
  ///
  /// In pt, this message translates to:
  /// **'primeira marca'**
  String get workoutBaseline;

  /// No description provided for @workoutSetsDone.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 série concluída} other{{count} séries concluídas}}'**
  String workoutSetsDone(int count);

  /// No description provided for @exerciseRemove.
  ///
  /// In pt, this message translates to:
  /// **'Remover exercício'**
  String get exerciseRemove;

  /// No description provided for @setRemove.
  ///
  /// In pt, this message translates to:
  /// **'Remover série'**
  String get setRemove;

  /// No description provided for @onbCustomOriginName.
  ///
  /// In pt, this message translates to:
  /// **'Nome da sua origem'**
  String get onbCustomOriginName;

  /// No description provided for @onbCustomOriginNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Caçador das Montanhas'**
  String get onbCustomOriginNameHint;

  /// No description provided for @onbCustomOriginStory.
  ///
  /// In pt, this message translates to:
  /// **'Sua história (opcional)'**
  String get onbCustomOriginStory;

  /// No description provided for @onbCustomOriginStoryHint.
  ///
  /// In pt, this message translates to:
  /// **'De onde você veio? O que te trouxe até a forja?'**
  String get onbCustomOriginStoryHint;

  /// No description provided for @setComplete.
  ///
  /// In pt, this message translates to:
  /// **'Concluir série'**
  String get setComplete;

  /// No description provided for @rewardsSetsLine.
  ///
  /// In pt, this message translates to:
  /// **'Séries efetivas ({count})'**
  String rewardsSetsLine(int count);

  /// No description provided for @rewardsRecordLine.
  ///
  /// In pt, this message translates to:
  /// **'Recorde Pessoal · {name} {weight} kg'**
  String rewardsRecordLine(String name, String weight);

  /// No description provided for @rewardsQuestLine.
  ///
  /// In pt, this message translates to:
  /// **'Missão: {title}'**
  String rewardsQuestLine(String title);

  /// No description provided for @bonusGoalMet.
  ///
  /// In pt, this message translates to:
  /// **'Meta da semana cumprida ({day}/{goal})'**
  String bonusGoalMet(int day, int goal);

  /// No description provided for @bonusBeyondDuty.
  ///
  /// In pt, this message translates to:
  /// **'Além do Dever · {day}º dia de treino'**
  String bonusBeyondDuty(int day);

  /// No description provided for @bonusFlame.
  ///
  /// In pt, this message translates to:
  /// **'Chama da Constância · {weeks} semanas'**
  String bonusFlame(int weeks);

  /// No description provided for @bonusFlameReason.
  ///
  /// In pt, this message translates to:
  /// **'+{percent}% sobre os bônus da semana'**
  String bonusFlameReason(int percent);

  /// No description provided for @bonusWeekLabel.
  ///
  /// In pt, this message translates to:
  /// **'Semana'**
  String get bonusWeekLabel;

  /// No description provided for @rewardsTotal.
  ///
  /// In pt, this message translates to:
  /// **'Total'**
  String get rewardsTotal;

  /// No description provided for @rewardsLevelUp.
  ///
  /// In pt, this message translates to:
  /// **'Nível {level} alcançado!'**
  String rewardsLevelUp(int level);

  /// No description provided for @rewardsAttributeUp.
  ///
  /// In pt, this message translates to:
  /// **'{attribute} subiu para {score}!'**
  String rewardsAttributeUp(String attribute, int score);

  /// No description provided for @rewardsWeekProgress.
  ///
  /// In pt, this message translates to:
  /// **'{day}/{goal} dias de treino nesta semana'**
  String rewardsWeekProgress(int day, int goal);

  /// No description provided for @rewardsWeekDone.
  ///
  /// In pt, this message translates to:
  /// **'Meta semanal batida!'**
  String get rewardsWeekDone;

  /// No description provided for @rewardsNoWeeklyBonus.
  ///
  /// In pt, this message translates to:
  /// **'Você já treinou hoje: bônus semanais contam um treino por dia.'**
  String get rewardsNoWeeklyBonus;

  /// No description provided for @commonContinueShort.
  ///
  /// In pt, this message translates to:
  /// **'Continuar'**
  String get commonContinueShort;

  /// No description provided for @streakTitle.
  ///
  /// In pt, this message translates to:
  /// **'Chama da Constância'**
  String get streakTitle;

  /// No description provided for @streakWeeks.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{0 semanas} =1{1 semana} other{{count} semanas}}'**
  String streakWeeks(int count);

  /// No description provided for @streakWeekStatus.
  ///
  /// In pt, this message translates to:
  /// **'{done}/{goal} nesta semana'**
  String streakWeekStatus(int done, int goal);

  /// No description provided for @streakGoalHit.
  ///
  /// In pt, this message translates to:
  /// **'{done}/{goal} · meta batida!'**
  String streakGoalHit(int done, int goal);

  /// No description provided for @weekdayLetters.
  ///
  /// In pt, this message translates to:
  /// **'S,T,Q,Q,S,S,D'**
  String get weekdayLetters;

  /// No description provided for @historyTitle.
  ///
  /// In pt, this message translates to:
  /// **'Histórico'**
  String get historyTitle;

  /// No description provided for @historyOpen.
  ///
  /// In pt, this message translates to:
  /// **'Histórico & Recordes'**
  String get historyOpen;

  /// No description provided for @historyOpenSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Treinos passados, calendário e evolução de carga'**
  String get historyOpenSubtitle;

  /// No description provided for @historyTabWorkouts.
  ///
  /// In pt, this message translates to:
  /// **'Treinos'**
  String get historyTabWorkouts;

  /// No description provided for @historyTabCalendar.
  ///
  /// In pt, this message translates to:
  /// **'Calendário'**
  String get historyTabCalendar;

  /// No description provided for @historyTabRecords.
  ///
  /// In pt, this message translates to:
  /// **'Recordes'**
  String get historyTabRecords;

  /// No description provided for @historyEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum treino finalizado ainda. A forja espera.'**
  String get historyEmpty;

  /// No description provided for @recordsEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum recorde ainda. Termine um treino com carga para registrar suas marcas.'**
  String get recordsEmpty;

  /// No description provided for @historyVolume.
  ///
  /// In pt, this message translates to:
  /// **'{volume} kg'**
  String historyVolume(String volume);

  /// No description provided for @historyRecords.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 recorde} other{{count} recordes}}'**
  String historyRecords(int count);

  /// No description provided for @calendarMonthDays.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Nenhum dia de treino} =1{1 dia de treino} other{{count} dias de treino}}'**
  String calendarMonthDays(int count);

  /// No description provided for @recordBest.
  ///
  /// In pt, this message translates to:
  /// **'Melhor: {weight} kg × {reps}'**
  String recordBest(String weight, int reps);

  /// No description provided for @recordE1rm.
  ///
  /// In pt, this message translates to:
  /// **'1RM estimado: {value} kg'**
  String recordE1rm(String value);

  /// No description provided for @progressTitle.
  ///
  /// In pt, this message translates to:
  /// **'Evolução'**
  String get progressTitle;

  /// No description provided for @progressChartE1rm.
  ///
  /// In pt, this message translates to:
  /// **'1RM estimado por treino (kg)'**
  String get progressChartE1rm;

  /// No description provided for @progressChartDuration.
  ///
  /// In pt, this message translates to:
  /// **'Melhor tempo por treino'**
  String get progressChartDuration;

  /// No description provided for @progressChartReps.
  ///
  /// In pt, this message translates to:
  /// **'Mais repetições por treino'**
  String get progressChartReps;

  /// No description provided for @progressEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Sem dados ainda.'**
  String get progressEmpty;

  /// No description provided for @progressSessions.
  ///
  /// In pt, this message translates to:
  /// **'Treinos com este exercício'**
  String get progressSessions;

  /// No description provided for @settingsTraining.
  ///
  /// In pt, this message translates to:
  /// **'Treino'**
  String get settingsTraining;

  /// No description provided for @settingsWeeklyGoal.
  ///
  /// In pt, this message translates to:
  /// **'Meta semanal'**
  String get settingsWeeklyGoal;

  /// No description provided for @settingsWeeklyGoalHint.
  ///
  /// In pt, this message translates to:
  /// **'Dias de treino por semana. Bater a meta dá bônus; cada dia acima dela dá ainda mais.'**
  String get settingsWeeklyGoalHint;

  /// No description provided for @settingsWeeklyGoalValue.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =1{1 dia} other{{count} dias}}'**
  String settingsWeeklyGoalValue(int count);

  /// No description provided for @settingsWaterGoal.
  ///
  /// In pt, this message translates to:
  /// **'Meta diária de água'**
  String get settingsWaterGoal;

  /// No description provided for @settingsWaterGoalHint.
  ///
  /// In pt, this message translates to:
  /// **'Copos de 250 ml por dia. Cada copo até a meta concede XP de Constituição, com bônus ao atingir a meta.'**
  String get settingsWaterGoalHint;

  /// No description provided for @settingsWaterGoalValue.
  ///
  /// In pt, this message translates to:
  /// **'{cups} copos ({ml} ml)'**
  String settingsWaterGoalValue(int cups, int ml);

  /// No description provided for @hydrationTitle.
  ///
  /// In pt, this message translates to:
  /// **'Hidratação Diária'**
  String get hydrationTitle;

  /// No description provided for @hydrationSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Cada copo (250 ml) até a meta fortalece Constituição.'**
  String get hydrationSubtitle;

  /// No description provided for @hydrationProgress.
  ///
  /// In pt, this message translates to:
  /// **'{cups}/{goal} copos · {ml} ml'**
  String hydrationProgress(int cups, int goal, int ml);

  /// No description provided for @hydrationAddCup.
  ///
  /// In pt, this message translates to:
  /// **'+1 copo (250 ml)'**
  String get hydrationAddCup;

  /// No description provided for @hydrationGoalMetBadge.
  ///
  /// In pt, this message translates to:
  /// **'Meta de água batida hoje!'**
  String get hydrationGoalMetBadge;

  /// No description provided for @hydrationBonusLine.
  ///
  /// In pt, this message translates to:
  /// **'Meta diária de hidratação batida'**
  String get hydrationBonusLine;

  /// No description provided for @dietTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nutrição & Dieta'**
  String get dietTitle;

  /// No description provided for @dietSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Check-in diário de consistência alimentar (sem contagem neurótica).'**
  String get dietSubtitle;

  /// No description provided for @dietOnTrackButton.
  ///
  /// In pt, this message translates to:
  /// **'Plano cumprido'**
  String get dietOnTrackButton;

  /// No description provided for @dietPartialButton.
  ///
  /// In pt, this message translates to:
  /// **'Parcial / Equilibrado'**
  String get dietPartialButton;

  /// No description provided for @dietDoneOnTrack.
  ///
  /// In pt, this message translates to:
  /// **'Check-in de hoje: Plano alimentar cumprido'**
  String get dietDoneOnTrack;

  /// No description provided for @dietDonePartial.
  ///
  /// In pt, this message translates to:
  /// **'Check-in de hoje: Alimentação parcial / equilibrada'**
  String get dietDonePartial;

  /// No description provided for @sleepLoggedToday.
  ///
  /// In pt, this message translates to:
  /// **'Último registro hoje: {hours} h'**
  String sleepLoggedToday(String hours);

  /// No description provided for @activitiesCatalogSection.
  ///
  /// In pt, this message translates to:
  /// **'Catálogo de Hábitos & Práticas'**
  String get activitiesCatalogSection;

  /// No description provided for @activitiesCustomButton.
  ///
  /// In pt, this message translates to:
  /// **'Registrar outra atividade'**
  String get activitiesCustomButton;

  /// No description provided for @customActivityTitle.
  ///
  /// In pt, this message translates to:
  /// **'Nova Atividade'**
  String get customActivityTitle;

  /// No description provided for @customActivityNameLabel.
  ///
  /// In pt, this message translates to:
  /// **'O que você praticou?'**
  String get customActivityNameLabel;

  /// No description provided for @customActivityNameHint.
  ///
  /// In pt, this message translates to:
  /// **'Ex.: Aula de violão, conversa com amigo, trilha...'**
  String get customActivityNameHint;

  /// No description provided for @customActivityDefaultName.
  ///
  /// In pt, this message translates to:
  /// **'Prática focada'**
  String get customActivityDefaultName;

  /// No description provided for @customActivityAttributeLabel.
  ///
  /// In pt, this message translates to:
  /// **'Atributo trabalhado'**
  String get customActivityAttributeLabel;

  /// No description provided for @customActivityDurationLabel.
  ///
  /// In pt, this message translates to:
  /// **'Duração (minutos)'**
  String get customActivityDurationLabel;

  /// No description provided for @customActivityIntensityLabel.
  ///
  /// In pt, this message translates to:
  /// **'Intensidade'**
  String get customActivityIntensityLabel;

  /// No description provided for @intensityLightLabel.
  ///
  /// In pt, this message translates to:
  /// **'Leve'**
  String get intensityLightLabel;

  /// No description provided for @intensityModerateLabel.
  ///
  /// In pt, this message translates to:
  /// **'Moderada'**
  String get intensityModerateLabel;

  /// No description provided for @intensityHardLabel.
  ///
  /// In pt, this message translates to:
  /// **'Intensa'**
  String get intensityHardLabel;

  /// No description provided for @customActivitySubmit.
  ///
  /// In pt, this message translates to:
  /// **'Concluir e receber XP'**
  String get customActivitySubmit;

  /// No description provided for @activityRewardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Atividade Concluída!'**
  String get activityRewardTitle;

  /// No description provided for @activityRewardBaseLine.
  ///
  /// In pt, this message translates to:
  /// **'{name} ({minutes} min)'**
  String activityRewardBaseLine(String name, int minutes);

  /// No description provided for @exerciseGuideTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Como executar'**
  String get exerciseGuideTooltip;

  /// No description provided for @exerciseGuideTitle.
  ///
  /// In pt, this message translates to:
  /// **'Guia de Execução'**
  String get exerciseGuideTitle;

  /// No description provided for @exerciseGuideStepsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Passo a passo & Postura'**
  String get exerciseGuideStepsTitle;

  /// No description provided for @exerciseGuideSpriteNote.
  ///
  /// In pt, this message translates to:
  /// **'Ilustração em pixel art do movimento em breve.'**
  String get exerciseGuideSpriteNote;

  /// No description provided for @dailyCurveNote.
  ///
  /// In pt, this message translates to:
  /// **'Fôlego do Dia: parte do esforço entrou na curva diária de recuperação deste atributo. Seus recordes, missões e bônus continuam valendo 100%!'**
  String get dailyCurveNote;

  /// No description provided for @arenaBannerTitle.
  ///
  /// In pt, this message translates to:
  /// **'Arena da Forja'**
  String get arenaBannerTitle;

  /// No description provided for @arenaBannerSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Desafie campeões NPC para conquistar títulos e cosméticos (sem ganho de XP)'**
  String get arenaBannerSubtitle;

  /// No description provided for @arenaTokensBadge.
  ///
  /// In pt, this message translates to:
  /// **'Fichas hoje: {remaining}/{total}'**
  String arenaTokensBadge(int remaining, int total);

  /// No description provided for @arenaChampionsBadge.
  ///
  /// In pt, this message translates to:
  /// **'Campeões: {defeated}/{total}'**
  String arenaChampionsBadge(int defeated, int total);

  /// No description provided for @heroCustomizeButton.
  ///
  /// In pt, this message translates to:
  /// **'Títulos & Cosméticos'**
  String get heroCustomizeButton;

  /// No description provided for @heroTitlesSection.
  ///
  /// In pt, this message translates to:
  /// **'Títulos de Combate'**
  String get heroTitlesSection;

  /// No description provided for @heroCosmeticsSection.
  ///
  /// In pt, this message translates to:
  /// **'Cosméticos de Herói'**
  String get heroCosmeticsSection;

  /// No description provided for @heroUnequip.
  ///
  /// In pt, this message translates to:
  /// **'Nenhum (desequipar)'**
  String get heroUnequip;

  /// No description provided for @heroLockedHint.
  ///
  /// In pt, this message translates to:
  /// **'Derrote {npc} na Arena para desbloquear'**
  String heroLockedHint(String npc);

  /// No description provided for @arenaScreenTitle.
  ///
  /// In pt, this message translates to:
  /// **'Arena da Forja'**
  String get arenaScreenTitle;

  /// No description provided for @arenaTokensExplain.
  ///
  /// In pt, this message translates to:
  /// **'2 entradas grátis/dia + 1 por treino + 1 por missão diária + 1 por hábito de saúde.'**
  String get arenaTokensExplain;

  /// No description provided for @arenaNoTokens.
  ///
  /// In pt, this message translates to:
  /// **'Sem fichas de Arena disponíveis hoje. Conclua um treino, missão ou meta de saúde para ganhar mais!'**
  String get arenaNoTokens;

  /// No description provided for @arenaRecommendedLevel.
  ///
  /// In pt, this message translates to:
  /// **'Nv. rec. {level}'**
  String arenaRecommendedLevel(int level);

  /// No description provided for @arenaChallengeButton.
  ///
  /// In pt, this message translates to:
  /// **'Desafiar (1 ficha)'**
  String get arenaChallengeButton;

  /// No description provided for @arenaVictoriesCount.
  ///
  /// In pt, this message translates to:
  /// **'{count, plural, =0{Ainda não derrotado} =1{1 vitória} other{{count} vitórias}}'**
  String arenaVictoriesCount(int count);

  /// No description provided for @arenaRewardLabel.
  ///
  /// In pt, this message translates to:
  /// **'Recompensa: {title} · {cosmetic}'**
  String arenaRewardLabel(String title, String cosmetic);

  /// No description provided for @combatTurnLabel.
  ///
  /// In pt, this message translates to:
  /// **'Turno {turn}'**
  String combatTurnLabel(int turn);

  /// No description provided for @combatHpLabel.
  ///
  /// In pt, this message translates to:
  /// **'PV'**
  String get combatHpLabel;

  /// No description provided for @combatFocusLabel.
  ///
  /// In pt, this message translates to:
  /// **'FOCO'**
  String get combatFocusLabel;

  /// No description provided for @combatIntentStrike.
  ///
  /// In pt, this message translates to:
  /// **'Intenção: Ataque Direto'**
  String get combatIntentStrike;

  /// No description provided for @combatIntentHeavy.
  ///
  /// In pt, this message translates to:
  /// **'Intenção: Golpe Pesado (defenda ou atordoe!)'**
  String get combatIntentHeavy;

  /// No description provided for @combatIntentGuard.
  ///
  /// In pt, this message translates to:
  /// **'Intenção: Postura Defensiva'**
  String get combatIntentGuard;

  /// No description provided for @combatActionBasic.
  ///
  /// In pt, this message translates to:
  /// **'Golpe Básico (+3 Foco)'**
  String get combatActionBasic;

  /// No description provided for @combatActionSkill.
  ///
  /// In pt, this message translates to:
  /// **'{name} ({cost} Foco)'**
  String combatActionSkill(String name, int cost);

  /// No description provided for @combatActionSkillCooldown.
  ///
  /// In pt, this message translates to:
  /// **'{name} ({turns}t)'**
  String combatActionSkillCooldown(String name, int turns);

  /// No description provided for @combatActionDefend.
  ///
  /// In pt, this message translates to:
  /// **'Defender (-50% dano, +Foco/+PV)'**
  String get combatActionDefend;

  /// No description provided for @combatActionInspiration.
  ///
  /// In pt, this message translates to:
  /// **'Inspiração Heroica (Crítico · {count})'**
  String combatActionInspiration(int count);

  /// No description provided for @combatLogTitle.
  ///
  /// In pt, this message translates to:
  /// **'Registro de Batalha'**
  String get combatLogTitle;

  /// No description provided for @combatLogHeroBasic.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Seu golpe causou {dmg} de dano{crit}.'**
  String combatLogHeroBasic(int turn, int dmg, String crit);

  /// No description provided for @combatLogHeroSkill.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: {skill} causou {dmg} de dano{crit}!'**
  String combatLogHeroSkill(int turn, String skill, int dmg, String crit);

  /// No description provided for @combatLogHeroSkillHeal.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: {skill} causou {dmg} de dano e curou {heal} PV!'**
  String combatLogHeroSkillHeal(int turn, String skill, int dmg, int heal);

  /// No description provided for @combatLogHeroDefend.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Postura defensiva (+{heal} PV, +Foco).'**
  String combatLogHeroDefend(int turn, int heal);

  /// No description provided for @combatLogHeroInspiration.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Inspiração Heroica! Crítico devastador de {dmg} de dano!'**
  String combatLogHeroInspiration(int turn, int dmg);

  /// No description provided for @combatLogEnemyStrike.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: O oponente atacou causando {dmg} de dano.'**
  String combatLogEnemyStrike(int turn, int dmg);

  /// No description provided for @combatLogEnemyHeavy.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Golpe Pesado do oponente causou {dmg} de dano!'**
  String combatLogEnemyHeavy(int turn, int dmg);

  /// No description provided for @combatLogEnemyGuard.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: O oponente ergueu guarda e recuperou {heal} PV.'**
  String combatLogEnemyGuard(int turn, int heal);

  /// No description provided for @combatLogEnemyStunned.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: O oponente está atordoado e perdeu o turno!'**
  String combatLogEnemyStunned(int turn);

  /// No description provided for @combatLogEnemyDodged.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: O oponente esquivou do seu ataque!'**
  String combatLogEnemyDodged(int turn);

  /// No description provided for @combatLogHeroDodged.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Você esquivou do ataque inimigo!'**
  String combatLogHeroDodged(int turn);

  /// No description provided for @combatVictoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Vitória na Arena!'**
  String get combatVictoryTitle;

  /// No description provided for @combatDefeatTitle.
  ///
  /// In pt, this message translates to:
  /// **'Derrota na Arena'**
  String get combatDefeatTitle;

  /// No description provided for @combatDefeatBody.
  ///
  /// In pt, this message translates to:
  /// **'O oponente prevaleceu desta vez. Fortaleça seus atributos com treinos e hábitos reais e volte mais forte!'**
  String get combatDefeatBody;

  /// No description provided for @combatUnlockedReward.
  ///
  /// In pt, this message translates to:
  /// **'Recompensas Desbloqueadas!'**
  String get combatUnlockedReward;

  /// No description provided for @combatAlreadyUnlocked.
  ///
  /// In pt, this message translates to:
  /// **'Recompensas deste campeão já estão na sua coleção.'**
  String get combatAlreadyUnlocked;

  /// No description provided for @combatEquipNow.
  ///
  /// In pt, this message translates to:
  /// **'Equipar agora'**
  String get combatEquipNow;

  /// No description provided for @combatBackToArena.
  ///
  /// In pt, this message translates to:
  /// **'Voltar à Arena'**
  String get combatBackToArena;

  /// No description provided for @heroClassSection.
  ///
  /// In pt, this message translates to:
  /// **'Classe do Herói'**
  String get heroClassSection;

  /// No description provided for @heroClassAuto.
  ///
  /// In pt, this message translates to:
  /// **'Automática (Emergente: {className})'**
  String heroClassAuto(String className);

  /// No description provided for @heroClassUnlockedHint.
  ///
  /// In pt, this message translates to:
  /// **'Habilidade: {skill}'**
  String heroClassUnlockedHint(String skill);

  /// No description provided for @heroClassLockedHint.
  ///
  /// In pt, this message translates to:
  /// **'Requer {attr1} ≥ {score} e {attr2} ≥ {score}'**
  String heroClassLockedHint(String attr1, String attr2, int score);

  /// No description provided for @heroTournamentLockedHint.
  ///
  /// In pt, this message translates to:
  /// **'Vença o {tournament} para desbloquear'**
  String heroTournamentLockedHint(String tournament);

  /// No description provided for @arenaTabDuels.
  ///
  /// In pt, this message translates to:
  /// **'Duelos 1v1'**
  String get arenaTabDuels;

  /// No description provided for @arenaTabTournaments.
  ///
  /// In pt, this message translates to:
  /// **'Torneios'**
  String get arenaTabTournaments;

  /// No description provided for @tournamentRoundsBadge.
  ///
  /// In pt, this message translates to:
  /// **'{rounds} rodadas'**
  String tournamentRoundsBadge(int rounds);

  /// No description provided for @tournamentRoundProgress.
  ///
  /// In pt, this message translates to:
  /// **'Rodada {current}/{total}'**
  String tournamentRoundProgress(int current, int total);

  /// No description provided for @tournamentEnterButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar no Torneio (1 ficha)'**
  String get tournamentEnterButton;

  /// No description provided for @tournamentNextRoundTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rodada {round} Concluída!'**
  String tournamentNextRoundTitle(int round);

  /// No description provided for @tournamentNextRoundBody.
  ///
  /// In pt, this message translates to:
  /// **'Você recupera +35% de PV e +50% de Foco antes do próximo oponente.'**
  String get tournamentNextRoundBody;

  /// No description provided for @tournamentNextRoundButton.
  ///
  /// In pt, this message translates to:
  /// **'Avançar para a Rodada {next}'**
  String tournamentNextRoundButton(int next);

  /// No description provided for @tournamentVictoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Campeão do Torneio!'**
  String get tournamentVictoryTitle;

  /// No description provided for @navCombat.
  ///
  /// In pt, this message translates to:
  /// **'Combate'**
  String get navCombat;

  /// No description provided for @combatHubTitle.
  ///
  /// In pt, this message translates to:
  /// **'Central de Combate'**
  String get combatHubTitle;

  /// No description provided for @combatHubSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Ponha seus atributos reais à prova em duelos, torneios e masmorras (sem ganho de XP — recompensas de prestígio).'**
  String get combatHubSubtitle;

  /// No description provided for @combatBackToHub.
  ///
  /// In pt, this message translates to:
  /// **'Voltar aos Modos'**
  String get combatBackToHub;

  /// No description provided for @combatModeStoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Modo História · Crônicas da Forja'**
  String get combatModeStoryTitle;

  /// No description provided for @combatModeStoryBadge.
  ///
  /// In pt, this message translates to:
  /// **'FASE 2 · JOGÁVEL'**
  String get combatModeStoryBadge;

  /// No description provided for @combatModeStoryDescription.
  ///
  /// In pt, this message translates to:
  /// **'Campanha narrativa sombria conduzida pelo Mestre de Jogo. Suas escolhas, sua origem e o nível real dos seus 6 atributos abrirão caminhos, diálogos e provações únicas.'**
  String get combatModeStoryDescription;

  /// No description provided for @combatModeDuelsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Arena de Duelos (1v1)'**
  String get combatModeDuelsTitle;

  /// No description provided for @combatModeDuelsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Duelos táticos 1v1 por turnos contra os campeões da Forja. Role o d20 + seu atributo principal contra a Classe de Armadura (CA) do inimigo, use sua habilidade de classe e conquiste títulos e cosméticos exclusivos.'**
  String get combatModeDuelsDescription;

  /// No description provided for @combatModeDuelsButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar na Arena 1v1'**
  String get combatModeDuelsButton;

  /// No description provided for @combatModeTournamentsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Torneios da Forja (Gauntlet)'**
  String get combatModeTournamentsTitle;

  /// No description provided for @combatModeTournamentsBadge.
  ///
  /// In pt, this message translates to:
  /// **'Torneios: {won}/{total}'**
  String combatModeTournamentsBadge(int won, int total);

  /// No description provided for @combatModeTournamentsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Chaves eliminatórias de múltiplas rodadas em sequência. Os adversários escalam de poder a cada liga e seu herói recupera apenas parte do PV (+35%) e Foco (+50%) entre as lutas.'**
  String get combatModeTournamentsDescription;

  /// No description provided for @combatModeTournamentsButton.
  ///
  /// In pt, this message translates to:
  /// **'Ver Chaves de Torneio'**
  String get combatModeTournamentsButton;

  /// No description provided for @combatModeDungeonsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Masmorras Profundas (Dungeons)'**
  String get combatModeDungeonsTitle;

  /// No description provided for @combatModeDungeonsBadge.
  ///
  /// In pt, this message translates to:
  /// **'Masmorras: {completed}/{total}'**
  String combatModeDungeonsBadge(int completed, int total);

  /// No description provided for @combatModeDungeonsDescription.
  ///
  /// In pt, this message translates to:
  /// **'Explore salas perigosas com armadilhas, enigmas arcanos e provações que testam seus 6 atributos no d20 antes de enfrentar o Chefe da masmorra.'**
  String get combatModeDungeonsDescription;

  /// No description provided for @combatModeDungeonsButton.
  ///
  /// In pt, this message translates to:
  /// **'Explorar Masmorras'**
  String get combatModeDungeonsButton;

  /// No description provided for @combatArmorClassLabel.
  ///
  /// In pt, this message translates to:
  /// **'CA {ac}'**
  String combatArmorClassLabel(int ac);

  /// No description provided for @combatD20CritTitle.
  ///
  /// In pt, this message translates to:
  /// **'20 NATURAL! ACERTO CRÍTICO (2× DANO)!'**
  String get combatD20CritTitle;

  /// No description provided for @combatD20FumbleTitle.
  ///
  /// In pt, this message translates to:
  /// **'1 NATURAL! FALHA ABSURDA!'**
  String get combatD20FumbleTitle;

  /// No description provided for @combatD20HitTitle.
  ///
  /// In pt, this message translates to:
  /// **'ACERTOU! (Total {total} vs CA {ac})'**
  String combatD20HitTitle(int total, int ac);

  /// No description provided for @combatD20MissTitle.
  ///
  /// In pt, this message translates to:
  /// **'ERROU! (Total {total} vs CA {ac})'**
  String combatD20MissTitle(int total, int ac);

  /// No description provided for @combatD20Formula.
  ///
  /// In pt, this message translates to:
  /// **'d20 ({roll}) + {attr} ({mod}) + Prof (+{prof}) = {total} vs {targetLabel} {target}'**
  String combatD20Formula(
    int roll,
    String attr,
    String mod,
    int prof,
    int total,
    String targetLabel,
    int target,
  );

  /// No description provided for @combatLogHeroFumble.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: FALHA ABSURDA (1 no d20)! Você abriu a guarda e sofreu {dmg} de dano!'**
  String combatLogHeroFumble(int turn, int dmg);

  /// No description provided for @dungeonEnterButton.
  ///
  /// In pt, this message translates to:
  /// **'Explorar Masmorra (1 ficha)'**
  String get dungeonEnterButton;

  /// No description provided for @dungeonRoomsBadge.
  ///
  /// In pt, this message translates to:
  /// **'{rooms} salas + Chefe'**
  String dungeonRoomsBadge(int rooms);

  /// No description provided for @dungeonRoomProgress.
  ///
  /// In pt, this message translates to:
  /// **'Sala {current}/{total}'**
  String dungeonRoomProgress(int current, int total);

  /// No description provided for @dungeonDifficultyLabel.
  ///
  /// In pt, this message translates to:
  /// **'CD {dc}'**
  String dungeonDifficultyLabel(int dc);

  /// No description provided for @dungeonRoomCheckButton.
  ///
  /// In pt, this message translates to:
  /// **'Rolar d20 + {attr} (CD {dc})'**
  String dungeonRoomCheckButton(String attr, int dc);

  /// No description provided for @dungeonRoomBypassButton.
  ///
  /// In pt, this message translates to:
  /// **'Contornar com Cautela (-5% PV, -3 Foco)'**
  String get dungeonRoomBypassButton;

  /// No description provided for @dungeonRoomBlessingTitle.
  ///
  /// In pt, this message translates to:
  /// **'Provação Superada!'**
  String get dungeonRoomBlessingTitle;

  /// No description provided for @dungeonRoomBlessingBody.
  ///
  /// In pt, this message translates to:
  /// **'Seu domínio de {attr} abriu caminho! Você recuperou +{hp} PV, +Foco e ganhou +1 Benção para o Chefe.'**
  String dungeonRoomBlessingBody(String attr, int hp);

  /// No description provided for @dungeonRoomTrapTitle.
  ///
  /// In pt, this message translates to:
  /// **'Armadilha Acionada!'**
  String get dungeonRoomTrapTitle;

  /// No description provided for @dungeonRoomTrapBody.
  ///
  /// In pt, this message translates to:
  /// **'A provação cobrou seu preço: você sofreu {dmg} de dano ao atravessar a sala.'**
  String dungeonRoomTrapBody(int dmg);

  /// No description provided for @dungeonRoomBypassTitle.
  ///
  /// In pt, this message translates to:
  /// **'Passagem Cautelosa'**
  String get dungeonRoomBypassTitle;

  /// No description provided for @dungeonRoomBypassBody.
  ///
  /// In pt, this message translates to:
  /// **'Você contornou o perigo pelo caminho longo, gastando {dmg} PV e 3 de Foco.'**
  String dungeonRoomBypassBody(int dmg);

  /// No description provided for @dungeonNextRoomButton.
  ///
  /// In pt, this message translates to:
  /// **'Avançar para a Sala {next}'**
  String dungeonNextRoomButton(int next);

  /// No description provided for @dungeonEnterBossButton.
  ///
  /// In pt, this message translates to:
  /// **'Enfrentar o Chefe da Masmorra'**
  String get dungeonEnterBossButton;

  /// No description provided for @dungeonVictoryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Masmorra Conquistada!'**
  String get dungeonVictoryTitle;

  /// No description provided for @heroDungeonLockedHint.
  ///
  /// In pt, this message translates to:
  /// **'Conquiste {dungeon} para desbloquear'**
  String heroDungeonLockedHint(String dungeon);

  /// No description provided for @testerButtonLabel.
  ///
  /// In pt, this message translates to:
  /// **'Modo Tester'**
  String get testerButtonLabel;

  /// No description provided for @testerActiveBadge.
  ///
  /// In pt, this message translates to:
  /// **'TESTER ATIVO'**
  String get testerActiveBadge;

  /// No description provided for @testerSheetTitle.
  ///
  /// In pt, this message translates to:
  /// **'Painel de Tester (Sandbox)'**
  String get testerSheetTitle;

  /// No description provided for @testerSheetSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Edite atributos, fichas e o dado d20 em memória para testar combates e classes sem alterar seu histórico real de XP.'**
  String get testerSheetSubtitle;

  /// No description provided for @testerEnableSwitch.
  ///
  /// In pt, this message translates to:
  /// **'Ativar atributos de Tester'**
  String get testerEnableSwitch;

  /// No description provided for @testerInfiniteTokens.
  ///
  /// In pt, this message translates to:
  /// **'Fichas de Combate Infinitas'**
  String get testerInfiniteTokens;

  /// No description provided for @testerInspirationLabel.
  ///
  /// In pt, this message translates to:
  /// **'Inspiração Heroica'**
  String get testerInspirationLabel;

  /// No description provided for @testerDiceModeTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rolagem do Dado d20'**
  String get testerDiceModeTitle;

  /// No description provided for @testerDiceRandom.
  ///
  /// In pt, this message translates to:
  /// **'Aleatório (1d20)'**
  String get testerDiceRandom;

  /// No description provided for @testerDiceForce20.
  ///
  /// In pt, this message translates to:
  /// **'Forçar 20 (Crítico)'**
  String get testerDiceForce20;

  /// No description provided for @testerDiceForce1.
  ///
  /// In pt, this message translates to:
  /// **'Forçar 1 (Falha Absurda)'**
  String get testerDiceForce1;

  /// No description provided for @testerPresetNovice.
  ///
  /// In pt, this message translates to:
  /// **'Iniciante (10)'**
  String get testerPresetNovice;

  /// No description provided for @testerPresetBalanced.
  ///
  /// In pt, this message translates to:
  /// **'Veterano (16)'**
  String get testerPresetBalanced;

  /// No description provided for @testerPresetLegend.
  ///
  /// In pt, this message translates to:
  /// **'Lenda (22)'**
  String get testerPresetLegend;

  /// No description provided for @testerResetButton.
  ///
  /// In pt, this message translates to:
  /// **'Voltar aos Atributos Reais'**
  String get testerResetButton;

  /// No description provided for @appearanceTabLook.
  ///
  /// In pt, this message translates to:
  /// **'Aparência (Visual)'**
  String get appearanceTabLook;

  /// No description provided for @appearanceTabHonors.
  ///
  /// In pt, this message translates to:
  /// **'Classe & Títulos'**
  String get appearanceTabHonors;

  /// No description provided for @appearancePresetsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Arquétipos Pré-Prontos'**
  String get appearancePresetsTitle;

  /// No description provided for @appearanceSkinTitle.
  ///
  /// In pt, this message translates to:
  /// **'Tom de Pele'**
  String get appearanceSkinTitle;

  /// No description provided for @appearanceEyesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Olhos & Cicatriz'**
  String get appearanceEyesTitle;

  /// No description provided for @appearanceEyeColorTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cor dos Olhos'**
  String get appearanceEyeColorTitle;

  /// No description provided for @appearanceHairTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cabelo / Elmo'**
  String get appearanceHairTitle;

  /// No description provided for @appearanceHairColorTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cor do Cabelo'**
  String get appearanceHairColorTitle;

  /// No description provided for @appearanceBeardTitle.
  ///
  /// In pt, this message translates to:
  /// **'Barba'**
  String get appearanceBeardTitle;

  /// No description provided for @appearanceTorsoTitle.
  ///
  /// In pt, this message translates to:
  /// **'Camisa / Peitoral'**
  String get appearanceTorsoTitle;

  /// No description provided for @appearanceLegsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Calças / Grevas'**
  String get appearanceLegsTitle;

  /// No description provided for @appearanceBootsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Calçado / Botas'**
  String get appearanceBootsTitle;

  /// No description provided for @appearanceBackTitle.
  ///
  /// In pt, this message translates to:
  /// **'Capa & Arma nas Costas'**
  String get appearanceBackTitle;

  /// No description provided for @appearanceTintTitle.
  ///
  /// In pt, this message translates to:
  /// **'Paleta da Armadura / Roupa'**
  String get appearanceTintTitle;

  /// No description provided for @appearanceCustomizeButton.
  ///
  /// In pt, this message translates to:
  /// **'Editar Aparência do Herói'**
  String get appearanceCustomizeButton;

  /// No description provided for @settingsSound.
  ///
  /// In pt, this message translates to:
  /// **'Áudio & Efeitos'**
  String get settingsSound;

  /// No description provided for @settingsSoundEffects.
  ///
  /// In pt, this message translates to:
  /// **'Efeitos Sonoros (Retro SFX)'**
  String get settingsSoundEffects;

  /// No description provided for @settingsSoundHint.
  ///
  /// In pt, this message translates to:
  /// **'Sons sintetizados offline para o dado d20, golpes de arma, crítico e treinos.'**
  String get settingsSoundHint;

  /// No description provided for @d20DialogTapToRoll.
  ///
  /// In pt, this message translates to:
  /// **'TOQUE NO DADO PARA ROLAR'**
  String get d20DialogTapToRoll;

  /// No description provided for @d20DialogRolling.
  ///
  /// In pt, this message translates to:
  /// **'Rolando na mesa de pedra...'**
  String get d20DialogRolling;

  /// No description provided for @d20DialogTapToContinue.
  ///
  /// In pt, this message translates to:
  /// **'Toque para executar o golpe!'**
  String get d20DialogTapToContinue;

  /// No description provided for @d20DialogInspiredBanner.
  ///
  /// In pt, this message translates to:
  /// **'INSPIRAÇÃO HEROICA! CRÍTICO GARANTIDO (20)'**
  String get d20DialogInspiredBanner;

  /// No description provided for @settingsBackup.
  ///
  /// In pt, this message translates to:
  /// **'Backup & Dados'**
  String get settingsBackup;

  /// No description provided for @settingsBackupExportTitle.
  ///
  /// In pt, this message translates to:
  /// **'Exportar Backup (JSON)'**
  String get settingsBackupExportTitle;

  /// No description provided for @settingsBackupExportHint.
  ///
  /// In pt, this message translates to:
  /// **'Salva treinos, herói, rotinas e XP em arquivo/área de transferência para proteger seus dados no PWA.'**
  String get settingsBackupExportHint;

  /// No description provided for @settingsBackupExportSuccessClipboard.
  ///
  /// In pt, this message translates to:
  /// **'Backup copiado para a área de transferência!'**
  String get settingsBackupExportSuccessClipboard;

  /// No description provided for @settingsBackupExportSuccessDownload.
  ///
  /// In pt, this message translates to:
  /// **'Arquivo .json baixado e copiado para a área de transferência!'**
  String get settingsBackupExportSuccessDownload;

  /// No description provided for @settingsBackupRestoreTitle.
  ///
  /// In pt, this message translates to:
  /// **'Restaurar Backup (JSON)'**
  String get settingsBackupRestoreTitle;

  /// No description provided for @settingsBackupRestoreHint.
  ///
  /// In pt, this message translates to:
  /// **'Importa um snapshot JSON exportado anteriormente, substituindo o estado atual.'**
  String get settingsBackupRestoreHint;

  /// No description provided for @settingsBackupPasteLabel.
  ///
  /// In pt, this message translates to:
  /// **'Cole aqui o conteúdo do backup (.json)'**
  String get settingsBackupPasteLabel;

  /// No description provided for @settingsBackupPasteFromClipboard.
  ///
  /// In pt, this message translates to:
  /// **'Colar da Área de Transferência'**
  String get settingsBackupPasteFromClipboard;

  /// No description provided for @settingsBackupPreviewSummary.
  ///
  /// In pt, this message translates to:
  /// **'Herói: {hero} · Treinos: {workouts} · Registros XP: {xpCount}'**
  String settingsBackupPreviewSummary(String hero, int workouts, int xpCount);

  /// No description provided for @settingsBackupConfirmButton.
  ///
  /// In pt, this message translates to:
  /// **'Restaurar e Substituir Dados'**
  String get settingsBackupConfirmButton;

  /// No description provided for @settingsBackupRestoreSuccess.
  ///
  /// In pt, this message translates to:
  /// **'Backup restaurado com sucesso!'**
  String get settingsBackupRestoreSuccess;

  /// No description provided for @settingsBackupInvalidError.
  ///
  /// In pt, this message translates to:
  /// **'JSON de backup inválido ou incompatível.'**
  String get settingsBackupInvalidError;

  /// No description provided for @combatLogLegendaryCounter.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Contra-golpe relâmpago! Você sofreu {dmg} de dano.'**
  String combatLogLegendaryCounter(int turn, int dmg);

  /// No description provided for @combatLogLegendaryBleedTick.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Cortes amaldiçoados sangram ({dmg} de dano).'**
  String combatLogLegendaryBleedTick(int turn, int dmg);

  /// No description provided for @combatLogLegendaryPhaseShift.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Despertar Lendário! O chefe muda de forma e recupera +{heal} PV.'**
  String combatLogLegendaryPhaseShift(int turn, int heal);

  /// No description provided for @combatLogLegendaryPlateBroken.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Placa de armadura rachada!'**
  String combatLogLegendaryPlateBroken(int turn);

  /// No description provided for @combatLogLegendaryBarrierPierced.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: A Barreira do Infinito foi rompida!'**
  String combatLogLegendaryBarrierPierced(int turn);

  /// No description provided for @combatLogLegendaryFocusDrain.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Pressão sombria drenou {dmg} de Foco!'**
  String combatLogLegendaryFocusDrain(int turn, int dmg);

  /// No description provided for @combatLogLegendarySurge.
  ///
  /// In pt, this message translates to:
  /// **'T{turn}: Surto Lendário! O chefe desencadeou {dmg} de dano massivo!'**
  String combatLogLegendarySurge(int turn, int dmg);

  /// No description provided for @combatModeStoryEnterButton.
  ///
  /// In pt, this message translates to:
  /// **'Entrar nas Crônicas da Forja'**
  String get combatModeStoryEnterButton;

  /// No description provided for @combatModeLegendaryTitle.
  ///
  /// In pt, this message translates to:
  /// **'Chefes Semanais Lendários (18)'**
  String get combatModeLegendaryTitle;

  /// No description provided for @combatModeLegendaryBadge.
  ///
  /// In pt, this message translates to:
  /// **'18 CHEFES · 0 XP'**
  String get combatModeLegendaryBadge;

  /// No description provided for @combatModeLegendaryDescription.
  ///
  /// In pt, this message translates to:
  /// **'Enfrente o Soberano Lendário desta semana com mecânicas únicas de D&D 5e. Seus treinos e hábitos reais enfraquecem o chefe. Ative o Modo Tester para desafiar todos os 18!'**
  String get combatModeLegendaryDescription;

  /// No description provided for @combatModeLegendaryEnterButton.
  ///
  /// In pt, this message translates to:
  /// **'Ver Chefes Lendários'**
  String get combatModeLegendaryEnterButton;

  /// No description provided for @storyWeeklyBossHeader.
  ///
  /// In pt, this message translates to:
  /// **'Chefe Semanal · {week}'**
  String storyWeeklyBossHeader(String week);

  /// No description provided for @storyWeaknessSealsLabel.
  ///
  /// In pt, this message translates to:
  /// **'Selos de Enfraquecimento: {seals}/7'**
  String storyWeaknessSealsLabel(int seals);

  /// No description provided for @storyWeaknessSealsHint.
  ///
  /// In pt, this message translates to:
  /// **'Treinos, missões e saúde da semana reduzem o PV, CA e passivas deste Chefe.'**
  String get storyWeaknessSealsHint;

  /// No description provided for @storyBossDefeatedBadge.
  ///
  /// In pt, this message translates to:
  /// **'DERROTADO ESTA SEMANA'**
  String get storyBossDefeatedBadge;

  /// No description provided for @storyChallengeWeeklyBoss.
  ///
  /// In pt, this message translates to:
  /// **'Desafiar Chefe Semanal'**
  String get storyChallengeWeeklyBoss;

  /// No description provided for @storyChronicleButton.
  ///
  /// In pt, this message translates to:
  /// **'Diário ({count})'**
  String storyChronicleButton(int count);

  /// No description provided for @storyChronicleTitle.
  ///
  /// In pt, this message translates to:
  /// **'Diário de Crônicas'**
  String get storyChronicleTitle;

  /// No description provided for @storyChronicleEmpty.
  ///
  /// In pt, this message translates to:
  /// **'Nenhuma cena registrada nesta semana ainda. Escolha um caminho ou escreva sua ação!'**
  String get storyChronicleEmpty;

  /// No description provided for @storyInputHint.
  ///
  /// In pt, this message translates to:
  /// **'O que seu herói faz agora? (texto livre...)'**
  String get storyInputHint;

  /// No description provided for @storySendAction.
  ///
  /// In pt, this message translates to:
  /// **'Agir'**
  String get storySendAction;

  /// No description provided for @storyRerollInspiration.
  ///
  /// In pt, this message translates to:
  /// **'Gastar 1 Inspiração para Re-rolar d20 ({count} disp.)'**
  String storyRerollInspiration(int count);

  /// No description provided for @legendaryThisWeekBadge.
  ///
  /// In pt, this message translates to:
  /// **'CHEFE DESTA SEMANA'**
  String get legendaryThisWeekBadge;

  /// No description provided for @legendaryTesterAllBadge.
  ///
  /// In pt, this message translates to:
  /// **'TODOS OS 18 LENDÁRIOS (TESTER)'**
  String get legendaryTesterAllBadge;

  /// No description provided for @legendaryLockedTesterHint.
  ///
  /// In pt, this message translates to:
  /// **'Ative o Modo Tester para treinar contra outros chefes fora da rotação da semana.'**
  String get legendaryLockedTesterHint;

  /// No description provided for @legendaryFightButton.
  ///
  /// In pt, this message translates to:
  /// **'Enfrentar Lendário'**
  String get legendaryFightButton;

  /// No description provided for @workoutResumeBadge.
  ///
  /// In pt, this message translates to:
  /// **'TREINO EM ANDAMENTO'**
  String get workoutResumeBadge;

  /// No description provided for @workoutResumeHint.
  ///
  /// In pt, this message translates to:
  /// **'Seu progresso está salvo automaticamente. Continue de onde parou a qualquer momento.'**
  String get workoutResumeHint;

  /// No description provided for @workoutResumeButton.
  ///
  /// In pt, this message translates to:
  /// **'Retomar Treino'**
  String get workoutResumeButton;

  /// No description provided for @workoutMinimizeTooltip.
  ///
  /// In pt, this message translates to:
  /// **'Minimizar treino (mantém tudo salvo)'**
  String get workoutMinimizeTooltip;

  /// No description provided for @workoutActiveExistsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Treino já em andamento'**
  String get workoutActiveExistsTitle;

  /// No description provided for @workoutActiveExistsBody.
  ///
  /// In pt, this message translates to:
  /// **'Você já tem \"{title}\" aberto. Deseja retomá-lo ou descartá-lo para iniciar um novo?'**
  String workoutActiveExistsBody(String title);

  /// No description provided for @workoutDiscardAndStart.
  ///
  /// In pt, this message translates to:
  /// **'Descartar e Iniciar Novo'**
  String get workoutDiscardAndStart;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
