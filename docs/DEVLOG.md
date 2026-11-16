# DEVLOG — diário de desenvolvimento compartilhado

_Entradas mais recentes no topo. Todo agente (e humano) registra aqui o que fez
ao fim de cada sessão. Formato definido em `AGENTS.md` §0._

## 2026-11-15 — Gemini (Antigravity) — Mini-Janela Interativa do d20 + Etapa 6C: Efeitos Sonoros Offline
- **Mini-Janela Central Interativa do d20 (`lib/features/arena/presentation/d20_roll_dialog.dart`, `arena_screen.dart`):**
  - Ao atacar (`basicStrike`, `classSkill`, `heroicInspiration`) ou rolar uma
    provação na Masmorra, abre `showInteractiveD20RollDialog` no centro da tela
    exibindo a ação, `vs CA/CD` e os modificadores (`1d20 + Atributo + Prof`).
  - Ao tocar no dado, o d20 cai com quique (`Curves.bounceOut`), gira
    ciclando faces e revela o resultado (`1..20`) com destaque dourado no 20
    Crítico e carmesim na Falha Absurda (1), passando o valor rolado
    determinísticamente para o `CombatEngine` antes de disparar a animação da
    arma no palco.
- **Efeitos Sonoros Dark Fantasy Retro Offline (`lib/core/audio/wav_synth.dart`, `sound_service.dart`, `sound_backend_io.dart`, `sound_backend_stub.dart`):**
  - `WavSynth`: sintetizador procedural PCM 16-bit WAV em Dart puro (zero
    dependências externas) para `diceRoll`, `diceReveal`, `criticalHit`,
    `criticalFumble`, `swordSlash`, `staffCast`, `bowShot`, `daggerFlurry`,
    `holySmite`, `shieldGuard`, `hitImpact`, `levelUp` e `setComplete`.
  - `SoundService`: reprodução nativa via `winmm.dll!PlaySoundA` no Windows
    (sem plugins nativos que exijam symlink/Developer Mode) e fallback seguro.
  - Toggle **Efeitos Sonoros (Retro SFX)** persistido em `AppSettings` e
    disponível em `SettingsScreen`; sons integrados ao d20, armas/magias no
    combate e conclusão de treino / level-up (`WorkoutCompleteScreen`).
- **Testes:** 119 testes passando (`test/core/audio/wav_synth_test.dart`,
  `test/features/arena/arena_screen_test.dart` atualizado para o modal do d20 +
  suíte completa), `flutter analyze` limpo.
- **Próximo:** Fase 2 — Narrador IA e Modo História (*Crônicas da Forja*).

## 2026-11-15 — Gemini (Antigravity) — Etapa 6B: Palco de Batalha 16-bit + Animações Específicas por Arma e Classe
- **Resolução de Animação por Arma e Classe (`lib/core/game/hero_appearance.dart`):**
  - `AttackAnimationKind` e `HeroAppearance.resolveAttackAnimation`: determina a
    animação de combate com base na `CharacterClass`, na arma equipada nas costas
    (`BackStyle`) e na ação executada (`basicStrike`, `classSkill`, `defend`):
    - **Mago / Feiticeiro / Bruxo / Artífice (ou Cajado equipado):** `staffArcaneCast`;
    - **Guerreiro / Bárbaro / Aventureiro (ou Espadão equipado):** `greatswordCleave`;
    - **Ladino (ou Adagas Gêmeas equipadas):** `daggerShadowFlurry`;
    - **Patrulheiro:** `bowPiercingShot`;
    - **Monge:** `martialKiStrike`;
    - **Paladino / Templário / Clérigo (ou Espada Santa equipada):** `holyRadiantSmite`;
    - **Cavaleiro Arcano:** `eldritchRunicSlash`;
    - **Druida / Bardo:** `primalSongWave`;
    - **Defender:** `defensiveGuard`.
- **Poses de Arma em Mãos no Compositor 28×36 (`lib/app/ui/pixel_sprite.dart`):**
  - Novos estados em `HeroPose`: `attackGreatsword`, `attackStaff`,
    `attackDaggers`, `attackBow`, `attackMartial`, `attackHolyBlade` e `guard`.
  - Quando o herói ataca ou defende, a arma sai das costas e é renderizada nas
    mãos do personagem (Espadão horizontal, Cajado Rúnico erguido com cristal
    brilhante, Adagas duplas, Arco Longo com flecha puxada, Punho de Ki, Espada
    Sagrada ou Escudo Forjado).
  - Adicionado suporte a `flipHorizontal` (para o oponente encarar o herói) e
    `hitFlashColor` (flash de impacto ao receber dano).
- **Palco de Batalha Visual 16-bit (`lib/features/arena/presentation/combat_stage_widget.dart`, `arena_screen.dart`):**
  - `CombatStageWidget`: exibe Herói vs Oponente sobre o piso de pedra da forja,
    com respiração *idle*, avanço coreografado (*lunge/dash*) no turno do herói e
    no contra-ataque do inimigo, VFX dedicados para todas as 9 categorias de
    arma/magia (feixe e orbe de cajado, corte crescente de espadão, corte em X de
    adagas, flecha veloz com anéis de vento, ondas de Ki, pilar de luz divina,
    relâmpago arcano, espinhos primais e barreira de escudo) e popups flutuantes
    (`-Dano`, `CRIT!`, `FALHA 1!`, `+PV`, `ATORDOADO!`, `ESQUIVOU!`).
- **Testes:** 118 testes passando, `flutter analyze` limpo.
- **Próximo:** Etapa 6C — Efeitos Sonoros Dark Fantasy Retro (síntese procedural
  WAV offline + toggle de som nas configurações).

## 2026-11-15 — Gemini (Antigravity) — Etapa 6A: Sistema Paper-Doll Customizável 16-bit (28×36 px) + Arquétipos Pré-Prontos + Sprites dos Oponentes
- **Modelo Puro de Aparência (`lib/core/game/hero_appearance.dart`, `hero_profile.dart`):**
  - `HeroAppearance`: modelo modular Paper-Doll em Dart puro com rampas de 3 tons
    (*highlight*, *base*, *shadow*) para 11 categorias: `SkinTone` (6), `EyeStyle`
    (5, incluindo cicatriz de 1 olho), `EyeColor` (6), `HairStyle` (8, incluindo
    espetado à la Guts, mecha branca, capuz e elmo), `HairColor` (6), `BeardStyle`
    (5), `TorsoStyle` (6 camisas/armaduras), `LegsStyle` (6 calças/grevas),
    `BootsStyle` (6 botas/calçados), `BackStyle` (6 capas e armas nas costas,
    incluindo Espadão + Capa) e `OutfitTint` (6 paletas), mais **7 arquétipos
    pré-prontos (`HeroAppearancePreset`)**.
- **Compositor de Sprites 16-bit `28×36` (`lib/app/ui/pixel_sprite.dart`):**
  - `HeroPaperDoll`, `HeroAvatar` e `OpponentAvatar`: compõem as camadas de trás
    para frente com contorno escuro (`#0F0F12`), sombreamento de 3 tons, poses
    `idle` e `flex`, aura de cosmético equipado e sprites exclusivos para os
    oponentes da Arena, Torneios e Chefes de Masmorra (`OpponentSprites`).
- **Persistência (Schema v9) e UI (`database.dart`, `hero_repository.dart`, `hero_customization_sheet.dart`, `onboarding_screen.dart`, `character_screen.dart`, `arena_screen.dart`, `workout_complete_screen.dart`):**
  - Coluna `heroes.appearance` com migração automática `v8 -> v9`.
  - Editor visual completo com preview ao vivo (alternando pose *idle* / *flex*)
    em `HeroCustomizationSheet` (aba **Aparência (Visual)** e aba **Classe &
    Títulos**) e direto no **Onboarding** durante a criação do herói.
  - Traduções completas em pt-BR e inglês (`game_content_pt.dart`,
    `game_content_en.dart`, `app_pt.arb`, `app_en.arb`).
- **Testes:** 116 testes passando (`test/core/game/hero_appearance_test.dart` +
  suíte completa), `flutter analyze` limpo.
- **Próximo:** Etapa 6B — Animações de Combate e UI (respiração *idle*, avanço de
  golpe, *hit shake/flash* e números flutuantes de dano/crítico).

## 2026-11-15 — Gemini (Antigravity) — Combate D20 (Crítico 20 / Falha Absurda 1 + Animação) + Aba Central de Combate + Etapa 5D (Dungeons) + Modo Tester
- **Rolagem D20 + Atributo + Proficiência vs CA/CD (`combat.dart`, `xp_rules.dart`, `d20_roller_widget.dart`):**
  - `D20RollResult` e `D20Outcome`: todo ataque do herói e teste de masmorra rola
    `1d20 + mod(Atributo) + Proficiência` contra a Classe de Armadura (`CA/AC`)
    do oponente ou Classe de Dificuldade (`CD/DC`) da sala.
  - **20 Natural:** acerto crítico garantido (`2.0×` de dano).
  - **1 Natural:** falha absurda (*Critical Fumble*), erro automático e dano de
    abertura de guarda (`6%` do PV máximo).
  - **Acerto normal:** tanto a chance de acertar quanto o multiplicador de
    precisão do dano escalam com `d20 + mod(Atributo)`.
  - `D20RollerBanner`: widget animado de dado d20 icosaédrico que gira/cicla as
    faces e exibe o número sorteado + fórmula completa D&D 5e.
- **5ª Aba Exclusiva de Combate + Retângulos de Seleção (`router.dart`, `arena_screen.dart`, `character_screen.dart`):**
  - Removido o card da Arena de dentro da ficha do Herói e adicionada a aba
    **Combate** (`/combat`) na `PixelNavBar`.
  - Central de Combate com 4 retângulos de seleção explicativos:
    1. **Modo História · Crônicas da Forja** no topo, em destaque, bloqueado com
       badge `EM BREVE · FASE 2`;
    2. **Arena de Duelos (1v1)**;
    3. **Torneios da Forja (Gauntlet)**;
    4. **Masmorras Profundas (Dungeons — Etapa 5D)**: 3 masmorras (`DungeonCatalog`)
       com 3 salas de provação dos 6 atributos no d20 + Chefe final, concedendo
       3 novos títulos e 3 novos cosméticos (zero XP).
- **Modo Tester / Sandbox (`providers.dart`, `character_repository.dart`, `tester_panel_sheet.dart`):**
  - Suporte a `--dart-define=TESTER_MODE=true` e botão direto **Modo Tester** na
    Central de Combate e Configurações.
  - Permite editar os 6 atributos (`8..30`), aplicar presets rápidos, ativar
    fichas infinitas e forçar `20` (Crítico) ou `1` (Falha Absurda) no d20 sem
    tocar no `xp_ledger`.
- **Testes:** 112 testes passando, `flutter analyze` limpo.
- **Próximo:** Fase 2 — Narrador IA e Modo História (Crônicas da Forja).

## 2026-11-15 — Gemini (Antigravity) — Etapa 5C: Seleção de Classe Desbloqueada + Torneios da Forja
- **Seleção de Classe Desbloqueada (`class_resolver.dart`, `xp_rules.dart`, `database.dart` schema v8):**
  - `ClassResolver.unlockedClasses` e `effectiveClass`: desbloqueia `Aventureiro`,
    a classe emergente natural e qualquer classe híbrida cujos dois atributos
    (`primary` e `secondary`) tenham atingido pontuação **≥ 12** (modificador +1
    no D&D 5e). Impede escolher classes sem treinar seus atributos reais
    (Decisão #41).
  - Coluna `heroes.selected_class` (schema v8) e seção **Classe do Herói** em
    `HeroCustomizationSheet` exibindo todas as 16 classes (com a habilidade D&D
    5e quando desbloqueada ou os requisitos de atributos quando bloqueada).
- **Modo Torneios da Forja (`combat.dart`, `combat_repository.dart`, `arena_screen.dart`):**
  - `TournamentCatalog`: 4 torneios escalonados (*Torneio das Cinzas* `0.85×`,
    *Torneio de Ferro Fundido* `1.00×`, *Torneio Carmesim* `1.15×` e *Grande
    Torneio de Obsidiana* `1.30×`), com 3 a 4 rodadas consecutivas e
    recuperação parcial entre lutas (`+35% PV` e `+50% Foco`).
  - 4 novos títulos e 4 novos cosméticos de prestígio traduzidos em pt-BR e en
    (zero XP concedido, Decisão #40).
  - Aba **Torneios** em `ArenaScreen` com progressão de rodadas ao vivo.
- **Testes:** 110 testes passando, `flutter analyze` limpo.
- **Próximo:** Etapa 5D — Modo Dungeon (exploração por salas/nós usando os 6
  atributos + combates).

## 2026-11-15 — Gemini (Antigravity) — Etapa 5B: Persistência + Tela da Arena 1v1 + Títulos e Cosméticos no Herói
- **Banco (Schema v7, `database.dart`, `database.g.dart`):**
  - Colunas `heroes.equipped_title_id` e `heroes.equipped_cosmetic_id`.
  - Tabelas `arena_progress` (vitórias por NPC da Arena, desbloqueando título e
    cosmético) e `daily_arena_logs` (fichas de entrada consumidas no dia).
  - Novo `XpSource.inspirationSpend` (0 XP, append-only no `xp_ledger`) para
    deduzir Inspiração Heroica gasta em batalha sem violar a imutabilidade do
    livro-razão.
- **Repositório (`combat_repository.dart`, `providers.dart`, `hero_repository.dart`):**
  `ArenaState` reativo combinando vitórias, títulos/cosméticos desbloqueados e
  fichas ganhas hoje (2 grátis + treinos + missões + hábito de saúde); métodos
  `consumeDailyEntry` e `finishMatch` (zero XP garantido).
- **UI (`arena_screen.dart`, `character_screen.dart`, `hero_customization_sheet.dart`):**
  - Card da **Arena da Forja** na ficha do Herói com contadores ao vivo de
    fichas e campeões derrotados.
  - Exibição do **Título** (`« ... »`) e **Cosmético** equipados no card do
    Herói + modal `HeroCustomizationSheet` para equipar/desequipar.
  - **Tela da Arena 1v1 (`ArenaScreen`)**: lista dos 6 desafiantes NPC + combate
    em turnos com barras segmentadas de PV e Foco, intenção telegrafada do
    inimigo, 4 ações táticas, log de batalha e card de vitória com botão
    "Equipar agora".
- **Localização (`app_pt.arb`, `app_en.arb`):** todas as chaves da Arena e de
  customização geradas em pt-BR e en via `flutter gen-l10n`.
- **Testes:** 107 testes passando (`repositories_test.dart`,
  `arena_screen_test.dart`), `flutter analyze` limpo.
- **Próximo:** Etapa 5C (Torneios e/ou Dungeon) ou Seleção de Classe
  Desbloqueada (Decisão #41).

## 2026-11-15 — Gemini (Antigravity) — Etapa 5A: Motor de Combate em Turnos, Habilidades D&D 5e e Arena
- **Motor (`lib/core/game/combat.dart`, `xp_rules.dart`):**
  - `CombatStats.fromHero`: deriva HP máximo, Foco máximo, Defesa, Iniciativa,
    Esquiva, Crítico, Bônus de Cura e Presença a partir dos 6 atributos reais
    do herói (FOR, DES, CON, INT, SAB, CAR).
  - `ClassSkillCatalog`: 16 habilidades assinadas inspiradas nos arquétipos do
    D&D 5e (*Surto de Ação*, *Fúria Ancestral*, *Lâmina Rúnica*, *Égide do
    Juramento*, *Destruição Divina*, *Marca do Caçador*, *Ataque Furtivo*,
    *Ataque Atordoante*, *Acorde Dissonante*, *Disparo Arcano*, *Fúria
    Espinhosa*, *Surto Caótico*, *Projétil Arcano*, *Rajada Mística*, *Chama
    Sagrada* e *Golpe Determinado*).
  - `ArenaCatalog`: 6 oponentes NPC (*Recruta das Cinzas* até *Colosso da
    Forja*, níveis recomendados 1 a 16), cada um concedendo título e cosmético
    exclusivos (`CombatReward`), sem nunca conceder XP (Decisão #40).
  - `CombatEngine`: resolução pura em turnos (`basicStrike`, `classSkill`,
    `defend`, `heroicInspiration`) com intenções telegrafadas do inimigo
    (`strike`, `heavyBlow`, `guard`) e log estruturado (`CombatLogEntry`).
  - `ArenaTokenRules`: cálculo das fichas diárias de entrada (2 grátis + 1 por
    treino + 1 por missão diária + 1 por hábito de saúde).
- **Localização (`game_content_pt.dart`, `game_content_en.dart`, `game_text.dart`):**
  tradução completa em pt-BR e en das 16 habilidades, 6 NPCs, 6 títulos e 6
  cosméticos, cobertos por `test/l10n/game_content_test.dart`.
- **Testes (`test/core/game/combat_test.dart`):** 104 testes passando no total,
  `flutter analyze` sem avisos.
- **Próximo:** Etapa 5B — Persistência de títulos/cosméticos desbloqueados e
  fichas da Arena + Tela da Arena 1v1 + seleção de título e cosmético no Herói.

## 2026-11-15 — Gemini (Antigravity) — Curva diária unificada por atributo + Guia "?" nos exercícios
- **Motor (`xp_calculator.dart`, `xp_rules.dart`, `xp_event.dart`):** curva
  diária de retornos decrescentes por atributo (`0–60: 100%`, `60–120: 75%`,
  `120–180: 50%`, `180–300: 25%`, `300+: 0%`, teto de 165 XP de esforço/dia por
  atributo) aplicada também às séries de treino (`WorkoutRepository`). Bônus
  motivacionais (`personalRecord`, `dailyQuest`, `weeklyBonus`, meta de água)
  são 100% preservados e não consomem a curva (`XpSource.isEffort`).
- **Guia de execução ("?") nos 64 exercícios:** `exercise_guide_sheet.dart` com
  `ExerciseHelpButton` no treino ativo, seletor de exercícios e editor de
  rotinas; passo a passo em 3 etapas (`exercise.<id>.guide`) traduzido em
  pt-BR e en.
- **Regra adicionada em `AGENTS.md`:** sempre recomendar o modelo e nível de
  intensidade ideal ao sugerir a próxima etapa ao usuário.
- **Testes:** 91 testes passando, `flutter analyze` limpo.

## 2026-11-15 — Gemini (Antigravity) — Etapa 4: catálogo de atividades, hidratação e nutrição em CON
- **Motor (`lib/core/game/activity_catalog.dart`):** catálogo de atividades
  (`ActivityCatalog`, 12 hábitos cobrindo INT, SAB, CAR, DES e CON) e regras de
  saúde em Constituição (`HealthRules`: hidratação com marca d'água anti-farm,
  check-in diário de dieta e faixas de sono). Constantes em `xp_rules.dart`;
  novos `XpSource.hydration` e `XpSource.nutrition`.
- **Banco (Schema v6):** tabela `daily_health_logs` e coluna
  `heroes.water_goal_cups` (meta diária de água ajustável em Configurações).
- **Repositório (`activity_repository.dart`):** `ActivityRewardResult` com XP
  base, bônus, missões concluídas e `ProgressDiff`; suporte a atividades do
  catálogo, atividades personalizadas, hidratação e check-in de dieta.
- **Tela de Atividades (`activities_screen.dart`):** Pomodoro (INT), Hidratação
  diária (CON), Nutrição & Dieta (CON), Sono (CON), catálogo filtrável por
  atributo (CAR, DES, SAB, INT, CON), modal de atividade personalizada e
  diálogo de recompensas completo (bônus, missões concluídas e subidas de
  nível/atributo).
- **Localização:** traduções pt-BR e en para as 12 atividades do catálogo e
  novos textos de interface.
- **Testes:** 88 testes passando (`activity_catalog_test.dart`,
  `repositories_test.dart`, `activities_screen_test.dart`, `game_content_test.dart`).
- **Próximo:** botão "?" em cada exercício (passo a passo de execução) e
  decisões sobre a Arena de Treino.

## 2026-11-15 — Claude Code — Etapa 3: histórico, sequência semanal, bônus e recompensas
- **Motor:** `weekly_progress.dart` (WeekCalendar, bônus Meta Cumprida /
  Além do Dever / Chama da Constância, sequência), `progress_diff.dart`
  (nível/atributo que subiu). Constantes em `xp_rules.dart`.
- **Finalizar treino** agora concede bônus semanais (1º treino do dia),
  devolve missões concluídas e o diff de progresso (`WorkoutSummary`).
- **Tela "Treino Concluído"** (`workout_complete_screen.dart`): herói
  flexionando, linhas de recompensa reveladas uma a uma com o motivo, total
  contando, progresso da semana, banners de nível/atributo.
- **Herói:** card Chama da Constância (semanas + faixa dos 7 dias).
- **Histórico** (`features/history/`): treinos, detalhe do treino,
  calendário mensal, recordes e evolução por exercício (gráfico de barras pixel).
- **Configurações:** meta semanal (1–7 dias).
- Schema **v5** (`heroes.weekly_goal`); `XpSource.weeklyBonus`.
- Testes: 77.
- **Próximo:** Etapa 4 (atividades genéricas + saúde em CON). Usuário
  propôs uma **arena de combate de treino** — proposta enviada, aguardando
  decisões (ver STATUS).

## 2026-11-15 — Claude Code — Etapa 2: rotinas, séries por tempo, origem própria
- **Rotinas:** 4 modelos fixos (Push, Pull, Legs, Cardio & Mobilidade) em
  `data/seed/routine_seed.dart` + rotinas personalizadas (criar, editar,
  reordenar, excluir, copiar modelo). `RoutineRepository`,
  `features/workout/presentation/routine_editor_screen.dart`.
- **Treino ativo reescrito** sobre `ActiveWorkoutController`
  (`features/workout/application/`): pré-carrega rotina com metas e valores
  do último treino, coluna "Anterior", colunas por tipo de série (kg×reps,
  reps, tempo m:ss), remover série (deslizar) e exercício, descanso por
  exercício, descartar treino (com confirmação), tela cheia (root navigator).
- **Motor:** `routine.dart` (Routine, RoutineExercise, RoutinePlanner),
  `personal_record.dart` (regras de PR), XP de série por tempo.
- **Regra nova de PR** (decisão 29): primeira marca não dá bônus; PR e XP
  calculados ao finalizar; máx. 1 bônus de PR por exercício por treino.
- **Origem própria** do herói (nome + história).
- **Schema v4:** tabelas `routines`, `routine_exercises`; colunas
  `workout_sessions.routine_id`, `workout_sets.duration_seconds`,
  `heroes.custom_origin_name/story`; `PRAGMA foreign_keys = ON`.
- **Bug achado nos testes:** Drift grava DateTime com precisão de segundos →
  "último treino" empatava; desempate pelo id da sessão.
- Testes: 64 (regras de PR, planner, formatação de tempo, repositórios,
  editor de rotina e origem própria via widget test).
- **Avisos:** `flutter pub get` lista pacotes com versão maior disponível
  (Riverpod 3, go_router 18…). São upgrades com breaking changes — fazer em
  tarefa própria, não misturar com features.
- **Próximo:** Etapa 3 — histórico, sequência semanal, bônus e tela
  "Treino Concluído" (o resumo atual em diálogo é provisório).

## 2026-11-14 — Claude Code — Etapa 1: i18n pt/en, revamp pixel, configurações e créditos
- **Idiomas:** ARB (`lib/l10n/arb`) para interface + mapas de conteúdo de jogo
  (`lib/l10n/content`) com 170 chaves (atributos, 16 classes, origens,
  missões, 64 exercícios, músculos, equipamentos). O motor não tem mais
  textos: expõe ids/chaves. Missões gravam chaves no banco (linhas antigas
  com texto pt continuam sendo exibidas).
- **Visual pixel:** fontes empacotadas (Jersey 10/Inter/Cinzel, sem
  google_fonts), kit `lib/app/ui/` e todas as telas reestilizadas.
- **Configurações** (engrenagem no topo): idioma e estilo de fonte, salvos em
  shared_preferences. **Créditos** com Leonardo Heck.
- **Schema v3:** exercícios com `MuscleGroup`/`Equipment` (enums) + coluna
  `tracking`; migração converte rótulos pt antigos. Catálogo sincronizado a
  cada start (`syncCatalog`).
- **Bugs corrigidos:**
  - Retornos decrescentes nunca funcionavam: o enum `Attribute` tinha um
    campo `name` ("Força") que sombreava o `.name` do Dart; a consulta do XP
    do dia comparava "Força" com "strength". Teste de regressão adicionado.
  - Com `material_ui`, os delegates gerados pelo gen-l10n não dão
    MaterialLocalizations em pt → campos de texto/chips quebravam. Usar
    `appLocalizationsDelegates`.
- Dependências: + `flutter_localizations` (gen-l10n), − `google_fonts`
  (fontes agora são assets, app 100% offline).
- Testes: 43 (inclui conteúdo traduzido completo, configurações, fluxo de
  onboarding em pt e en, busca do seletor em inglês).
- **Próximo:** Etapa 2 — rotinas (4 modelos + personalizadas) e séries por
  tempo (`SetTracking.duration` já existe no catálogo).

## 2026-11-14 — Claude Code — Protótipo pixel art + regras de bônus semanal
- Usuário escolheu fonte **D (Jersey 10 + Inter)** e aprovou o revamp pixel.
- `docs/design/prototype-pixel-v1.png`: protótipo de 3 telas (Herói, Treino
  ativo, Treino Concluído com recompensas explicadas). Ainda não aplicado ao app.
- Decisões 20–22 em `DECISIONS.md` (visual, sequência semanal, bônus).

## 2026-11-14 — Claude Code — Novas regras do projeto + estudo de fonte pixel
- Regras novas em `AGENTS.md`: modularidade/catálogos como dados, i18n
  pt-BR + en obrigatório, comentários de código em inglês.
- `docs/design/font-comparison.png`: comparação de 4 estilos tipográficos
  (atual, tudo pixel, híbrido Pixelify, híbrido Jersey 10) — aguardando
  decisão do usuário para o revamp visual.
- Ordem combinada: rotinas (fixas + personalizadas) → histórico/sequência →
  registro de atividades → botão "?" → pixel art. i18n entra como base antes.

## 2026-11-14 — Claude Code — Criação do herói + missões automáticas
- **Bug:** "Bad state: Too many elements" ao iniciar o 2º treino —
  `startWorkoutSession` buscava "a única sessão" sem filtrar por id. Corrigido.
- **Criação do herói (onboarding):** prólogo → nome + forma de tratamento
  (Ele/Herói, Ela/Heroína, Neutro/Lenda) → origem (6, só narrativa) →
  juramento opcional. Enquanto não houver herói, o roteador redireciona tudo
  para `/onboarding`. Nome e origem aparecem na tela do Herói.
- **Missões automáticas:** botão "Registrar Progresso" removido (dava progresso
  grátis). Treinos e atividades geram `QuestCredit` (motor:
  `core/game/quest_progress.dart`) aplicado por `QuestRepository.applyCredit`.
  As missões do dia são geradas ANTES do XP da primeira ação do dia.
- **Inspiração** deixou de ser fixa em 1: agora = nº de missões cumpridas
  (eventos `dailyQuest` no livro-razão). Gasto chega na Fase 2.
- Schema Drift **v2**: tabela `heroes` (+ migração `from < 2`).
- Arquivos novos: `core/game/hero_profile.dart`, `core/game/quest_progress.dart`,
  `data/repositories/hero_repository.dart`, `features/onboarding/...`.
  `appRouter` virou `routerProvider` (Riverpod).
- Testes: 32 (motor, repositórios com SQLite em memória, fluxo de onboarding).
- **Avisos para o próximo agente:**
  - Testes de widget não usam `GrindheimApp` (o tema baixa Google Fonts);
    montam `MaterialApp.router` com `routerProvider` + `ThemeData.dark()`.
  - Testes com Drift em widget test: chamar `disposeApp` no fim (ver
    `test/widget_test.dart`), senão o teste trava ou acusa timers pendentes.
  - Missão de Carisma ainda não tem como avançar (falta registro de atividade
    genérico — item 2 do STATUS).

## 2026-11-14 — Claude Code — Correção: assertion de ListTile no seletor de exercícios
- `exercise_picker_sheet.dart`: fundo do modal trocado de `Container` colorido
  para `Material` (mesma cor/borda). Antes, cada item da lista disparava
  "ListTile background color or ink splashes may be invisible" no modo debug.
- Novo teste `test/features/workout/exercise_picker_sheet_test.dart` (falha sem
  a correção). 16 testes passando.
- Aviso: o app importa `package:material_ui/material_ui.dart`, não
  `flutter/material.dart` — testes de widget devem usar o mesmo import.
- A mensagem "Using WasmStorageImplementation.sharedIndexedDb..." na Web é
  informativa (Drift escolhendo o armazenamento), não é erro.

## 2026-11-14 — Claude Code — Correção: banco de dados na Web
- Bug: na Web todas as telas davam "When compiling to the web, the `web`
  parameter needs to be set" — o Drift não sabia carregar o SQLite em WebAssembly.
- Adicionados `web/sqlite3.wasm` (sqlite3 3.9.1) e `web/drift_worker.js`
  (drift 2.35.4); `driftDatabase(...)` em `lib/data/database.dart` agora recebe
  `DriftWebOptions`.
- **Aviso:** ao atualizar `drift` ou `sqlite3` no pubspec, baixe de novo os dois
  arquivos nas releases correspondentes do GitHub (simolus3/drift e
  simolus3/sqlite3.dart), senão a Web quebra.
- Verificado: analyze limpo, 15 testes ok, build web aberto no Chromium sem erros.

## 2026-11-14 — Claude Code — Protocolo de sincronização entre agentes
- Criados `AGENTS.md` (regras únicas), `CLAUDE.md` e `GEMINI.md` (ponteiros),
  `docs/STATUS.md`, `docs/DEVLOG.md`, `docs/DECISIONS.md`, `.gitattributes`.
- Nenhuma mudança de código.
- Próximo agente: copiar os docs de design do Antigravity para `docs/design/`.

## 2026-11 — Gemini (Antigravity) — Fase 1 MVP offline
- Commits `f73f73c` (scaffold) e `2943fe4` (motor D&D, Drift, seed, telas).
- 15 testes passando, analyze limpo.
