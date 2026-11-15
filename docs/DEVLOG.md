# DEVLOG — diário de desenvolvimento compartilhado

_Entradas mais recentes no topo. Todo agente (e humano) registra aqui o que fez
ao fim de cada sessão. Formato definido em `AGENTS.md` §0._

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
