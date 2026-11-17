# STATUS — estado atual do projeto

_Atualize este arquivo sempre que o estado ou os próximos passos mudarem._

**Última atualização:** 2026-11-16 (Gemini / Antigravity) — Fase 2 concluída! (Etapa 7C: Bíblia do Mundo `WorldLorePrompt`, `GeminiStoryNarrator` BYOK com fallback offline & config local nas Configurações)

## Fase atual
**Fase 2 (Mundo Vivo, 18 Chefes Lendários & Narrador IA) concluída!** Pronto para testes de campanha com IA ao vivo ou iniciar a **Fase 3**.

## Fase 2 — Mundo Vivo, Inimigos Lendários & Narrador IA
- [x] **Etapa 7A — Backup JSON + 18 Chefes Lendários + Motor de História & `StoryNarrator` Offline:**
  - [x] Exportar / Importar Backup JSON nas Configurações (proteção para PWA iOS + Desktop).
  - [x] Sistema de **18 Inimigos Lendários** em `legendary_bosses.dart` + `combat.dart` com 9 mecânicas únicas D&D 5e e **Selos de Enfraquecimento** vindos dos hábitos reais da semana.
  - [x] Motor puro `lib/core/game/story.dart` (Arco Semanal + Capítulos livres com `StoryQuotaPolicy` pronto para tiers futuros + protocolo `StoryTriggerType` + `CampaignMemory` compacta + re-rolagem por Inspiração).
  - [x] Interface `StoryNarrator` + `TemplateStoryNarrator` offline-first (`pt-BR` e `en`).
- [x] **Etapa 7B — Sprites/VFX dos Lendários + Persistência v10 + UI Modo História & Diário:**
  - [x] Sprites 16-bit e indicadores/auras de mecânicas lendárias no `CombatStageWidget` (`OpponentSprites` + `pixel_sprite.dart`) para os 18 Chefes Semanais.
  - [x] Drift schema v10 (`story_runs`, `story_chapters`) + `StoryRepository` + Backup JSON atualizado + desbloqueio de títulos/cosméticos lendários em `CombatRepository`.
  - [x] Card **Modo História · Crônicas da Forja** desbloqueado no topo da aba Combate + `StoryModeView` (texto livre + escolhas rápidas + `D20RollDialog` + re-rolagem real por Inspiração + combate ao vivo no palco 16-bit + Diário de Crônicas) + aba/card **Chefes Semanais Lendários (18)** liberando todos no **Modo Tester**.
- [x] **Etapa 7C — Provedor de IA Real (`GeminiStoryNarrator`):**
  - [x] Bíblia do Mundo (`WorldLorePrompt`) injetando contexto Dark Fantasy de Grindheim, ficha/origem real, hábitos do dia, Chefe Semanal Lendário + Selos e regras estritas D&D 5e (`0` alucinação numérica).
  - [x] Conector HTTP multiplataforma sem dependências extras (`ai_http_io.dart` + `ai_http_web.dart` via `fetch` para PWA) usando **BYOK** (chave Gemini configurável localmente nas Configurações, fora do Backup JSON) com JSON estrito e fallback automático para `TemplateStoryNarrator`.

## O que existe
- Motor de jogo (`lib/core/game/`): atributos D&D, XP com retornos decrescentes
  unificados por atributo (treinos e atividades, bônus isentos), progressão de
  atributos (base 10) e níveis 1–20, 15 classes emergentes + Aventureiro com
  **desbloqueio e seleção de classe por atributo ≥ 12 (`ClassResolver`)**,
  missões diárias determinísticas, Inspiração e **motor de combate e masmorras
  baseado em `1d20 + Atributo + Proficiência vs CA/CD` (`combat.dart`)** com:
  - **20 Natural (Crítico 2×)** e **1 Natural (Falha Absurda)**;
  - 16 habilidades de classe inspiradas no D&D 5e (`ClassSkillCatalog`);
  - 6 NPCs da Arena (`ArenaCatalog`), **4 Torneios (`TournamentCatalog`)** e
    **3 Masmorras multi-salas (`DungeonCatalog`)** testando os 6 atributos
    (zero XP; recompensas de títulos e cosméticos).
- Persistência Drift/SQLite (schema v9): exercícios (seed 64 pt-BR + en com guia
  passo a passo), treinos, séries, PRs (1RM Epley), atividades, saúde diária
  (água, dieta, sono), progresso de Arena, Torneios e Dungeons (`arena_progress`),
  fichas diárias (`daily_arena_logs`), classe selecionada (`heroes.selected_class`),
  aparência Paper-Doll (`heroes.appearance`), título/cosmético equipados no herói,
  livro-razão de XP (incluindo `inspirationSpend`), missões.
- Telas (5 abas na `PixelNavBar`):
  1. **Herói** (ficha limpa, seletor de classe desbloqueada, títulos e cosméticos);
  2. **Treino** (estilo Hevy, timer de descanso, botão "?" de execução);
  3. **Atividades** (Pomodoro, hidratação, nutrição, sono, catálogo e atividade personalizada);
  4. **Missões** (3 missões diárias determinísticas + Inspiração);
  5. **Combate** (`ArenaScreen`: Central de Combate com retângulos de seleção para
     **Modo História** bloqueado no topo, **Arena 1v1**, **Torneios**,
     **Masmorras / Dungeons**, **dado d20 animado** e **Painel de Tester**).
- **Modo Tester / Sandbox (`TesterPanelSheet`):** edição ao vivo dos 6 atributos
  (8–30), presets rápidos, fichas infinitas e forçar rolagem `20` ou `1` no d20
  sem tocar no `xp_ledger`.
- **Etapa 6A, 6B & 6C — Sistema Paper-Doll 16-bit (`28×36 px`) + Palco de Batalha + Mini-Janela do d20 + Sons Offline:**
  customização modular em camadas + 7 arquétipos pré-prontos + sprites 16-bit
  para os oponentes (`OpponentAvatar`) + poses de arma em mãos + 9 animações de
  ataque/VFX por arma e classe + mini-janela interativa central do dado d20
  (`D20RollDialog`: toque para rolar, queda quicando, giro e revelação) +
  síntese procedural WAV offline (`WavSynth` + `SoundService`) com toggle nas
  Configurações.
- 119 testes passando; `flutter analyze` limpo.

## Fechamento da Fase 1 (concluído)
- [x] Criação do herói (onboarding).
- [x] Missões avançam sozinhas com treinos/atividades; Inspiração real.
- [x] **Etapa 1:** pt-BR + inglês, visual pixel (Jersey 10 + Inter),
      configurações (idioma, fonte), créditos.
- [x] **Etapa 2:** rotinas — 4 modelos fixos + rotinas personalizadas;
      séries por tempo e só-reps; origem própria do herói.
- [x] **Etapa 3:** histórico, recordes, evolução de carga, calendário,
      sequência semanal (meta padrão 3), bônus e tela "Treino Concluído".
- [x] **Etapa 4:** registro de atividades genérico (catálogo: CAR, DES, CON,
      SAB, INT + atividade personalizada) + saúde em CON (água e dieta) +
      modal de recompensas completo.
- [x] **Curva diária unificada por atributo** (séries de treino + atividades,
      teto diário de esforço e bônus 100% preservados).
- [x] **Botão "?" em cada exercício** (passo a passo de execução e postura nos
      64 exercícios em pt-BR e en; ilustrações pixel a definir).
- [x] **Etapa 5A:** motor de combate tático em turnos (`lib/core/game/combat.dart`),
      16 habilidades de classe inspiradas no D&D 5e (`ClassSkillCatalog`),
      catálogo de 6 NPCs da Arena (`ArenaCatalog`), títulos e cosméticos
      traduzidos (pt-BR/en) e regras de fichas diárias (`ArenaTokenRules`).
- [x] **Etapa 5B:** persistência de títulos/cosméticos desbloqueados e fichas
      usadas no dia (schema v7) + `CombatRepository` + Tela da Arena 1v1
      (`ArenaScreen`) + seletor de título/cosmético na ficha do herói
      (`HeroCustomizationSheet`).
- [x] **Etapa 5C:** seleção de classe desbloqueada (Decisão #41, schema v8) +
      Modo **Torneios da Forja** (`TournamentCatalog`, 4 chaves escalonadas com
      títulos e cosméticos de prestígio).
- [x] **Etapa 5D + Combate D20 + Aba de Combate + Modo Tester:** rolagem `1d20 + Atributo`
      com `CA/CD`, Crítico no 20 (`2×`), Falha Absurda no 1, animação visual do
      d20, 5ª aba dedicada de **Combate** com retângulos de seleção (Modo
      História bloqueado no topo, Duelos 1v1, Torneios e Dungeons com 3
      masmorras testando os 6 atributos) e **Painel de Tester (Sandbox)**.
- [x] **Etapa 6A — Arte Paper-Doll 16-bit (`28×36 px`) + Sprites de Oponentes:**
      compositor em camadas sombreadas (estilo Berserk Action-RPG), 11 categorias
      customizáveis, 7 arquétipos pré-prontos, editor no Onboarding e na Ficha
      do Herói, e avatares para todos os NPCs/Chefes.
- [x] **Etapa 6B — Animações de Combate por Arma/Classe e Palco 16-bit:**
      respiração *idle*, poses de arma sacada em mãos, 9 animações de ataque e
      VFX (Cajado Arcano, Espadão, Adagas Gêmeas, Arco, Punho de Ki, Espada
      Sagrada, Lâmina Rúnica, Onda Primal e Escudo de Guarda), *hit flash/shake*
      e números flutuantes de dano/crítico/cura.
- [x] **Etapa 6C — Mini-Janela Interativa do d20 + Efeitos Sonoros Dark Fantasy Retro:**
      mini-janela central solicitando toque no dado (queda com quique, giro e
      revelação antes do golpe) + síntese procedural WAV offline (`WavSynth` +
      `SoundService`) para dado d20, armas/magias, crítico, falha, concluir
      treino e subir de nível + toggle em Configurações.

## Pré-lançamento (prioridade atual)
- [ ] **Chefes Lendários originais** — proposta "Os 18 Flagelos" em
      `docs/design/chefes-lendarios-v2.md`, aguardando aprovação do usuário.
- [ ] **Revamp da arte** — usuário vai enviar referências.
- [ ] README do projeto.
- [ ] Upgrade de dependências (Riverpod 3, go_router 18, …) em tarefa própria.
- [ ] Servidor intermediário da IA (proxy) — adiado: por enquanto o app é de
      uso pessoal com BYOK. Distribuição futura: só APK/IPA (sem GitHub Pages).

## Fase 3 (futuro)
- Modo Hardcore: atrofia após 7 dias inativo + memória muscular (2x ao voltar).

## Avisos / dívidas conhecidas
- `README.md` ainda é o template padrão do Flutter.
- Dependências com versão maior disponível (Riverpod 3, go_router 18,
  etc.): upgrade planejado em tarefa separada.
- Comentários antigos em pt-BR ainda existem em arquivos não tocados
  (motor: progression, xp_calculator, class_resolver; repositórios).
- Documentos de design originais (`game_design.md`, `implementation_plan.md`,
  `walkthrough.md`) estão só no PC, na pasta do Antigravity — copiar para `docs/`.
