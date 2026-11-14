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

  /// No description provided for @routinesTitle.
  ///
  /// In pt, this message translates to:
  /// **'Rotinas Populares'**
  String get routinesTitle;

  /// No description provided for @routinePushTitle.
  ///
  /// In pt, this message translates to:
  /// **'Push · Peito, Ombro e Tríceps'**
  String get routinePushTitle;

  /// No description provided for @routinePushSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Supino, Militar, Elevação Lateral, Paralelas'**
  String get routinePushSubtitle;

  /// No description provided for @routinePullTitle.
  ///
  /// In pt, this message translates to:
  /// **'Pull · Costas e Bíceps'**
  String get routinePullTitle;

  /// No description provided for @routinePullSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Barra Fixa, Remada, Face Pull, Rosca'**
  String get routinePullSubtitle;

  /// No description provided for @routineLegsTitle.
  ///
  /// In pt, this message translates to:
  /// **'Legs · Pernas e Glúteos'**
  String get routineLegsTitle;

  /// No description provided for @routineLegsSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Agachamento, Stiff, Leg Press, Panturrilha'**
  String get routineLegsSubtitle;

  /// No description provided for @routineCardioTitle.
  ///
  /// In pt, this message translates to:
  /// **'Cardio & Mobilidade'**
  String get routineCardioTitle;

  /// No description provided for @routineCardioSubtitle.
  ///
  /// In pt, this message translates to:
  /// **'Corrida, Corda, Prancha, Alongamento'**
  String get routineCardioSubtitle;

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
