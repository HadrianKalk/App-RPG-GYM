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
