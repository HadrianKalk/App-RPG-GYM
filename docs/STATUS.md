# STATUS — estado atual do projeto

_Atualize este arquivo sempre que o estado ou os próximos passos mudarem._

**Última atualização:** 2026-11-15 (Gemini / Antigravity) — Etapa 6B: Palco de Batalha 16-bit + Animações Específicas por Arma e Classe (Cajado, Espadão, Adagas, Arco, Ki, Luz Divina, Escudo)

## Fase atual
**Fase 1 — MVP offline concluído**; executando **Etapa 6 (Arte, Animações e Sons)** antes da Fase 2 (Narrador IA & Modo História).

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
- **Etapa 6A & 6B — Sistema Paper-Doll 16-bit (`28×36 px`) + Palco de Batalha e Animações por Arma/Classe (`CombatStageWidget`):**
  customização modular em camadas + 7 arquétipos pré-prontos + sprites 16-bit
  para os oponentes (`OpponentAvatar`, espelhados no combate) + poses de arma em
  mãos (`HeroPose.attackGreatsword`, `attackStaff`, `attackDaggers`, `attackBow`,
  `attackMartial`, `attackHolyBlade`, `guard`) + 9 animações de ataque/VFX
  específicas por arma e classe + respiração *idle*, *hit flash/shake* e números
  flutuantes de dano/crítico/cura.
- 118 testes passando; `flutter analyze` limpo.

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
- [ ] **Etapa 6C — Efeitos Sonoros Dark Fantasy Retro:** síntese procedural WAV
      offline (`SoundService`) para dado d20, golpes, crítico, falha, concluir
      série e subir de nível + toggle nas configurações.

## Fase 2 — Mundo Vivo & Narrador IA
- [ ] Narrador IA: "Capítulo do Dia" a partir das atividades do dia (2–4 chamadas/dia).
- [ ] Escolhas com rolagem d20 + modificador; IA só narra o resultado.
- [ ] Gasto de Inspiração para re-rolar.
- [ ] Arco semanal + Boss enfraquecido pelas metas cumpridas.
- [ ] Memória de campanha (resumo compacto, NPCs, lugares).
- [ ] Decidir provedor de IA (atrás de interface) e onde fica a chave (Edge Function).

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
