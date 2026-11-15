# STATUS — estado atual do projeto

_Atualize este arquivo sempre que o estado ou os próximos passos mudarem._

**Última atualização:** 2026-11-15 (Gemini / Antigravity) — Etapa 5C: Seleção de Classe Desbloqueada + Torneios da Forja

## Fase atual
**Fase 1 — MVP offline: fechando lacunas** antes da Fase 2 (ver abaixo).

## O que existe
- Motor de jogo (`lib/core/game/`): atributos D&D, XP com retornos decrescentes
  unificados por atributo (treinos e atividades, bônus isentos), progressão de
  atributos (base 10) e níveis 1–20, 15 classes emergentes + Aventureiro com
  **desbloqueio e seleção de classe por atributo ≥ 12 (`ClassResolver`)**,
  missões diárias determinísticas, Inspiração e **motor de combate tático em
  turnos (`combat.dart`)** com 16 habilidades de classe inspiradas no D&D 5e,
  6 NPCs da Arena e **4 Torneios (Gauntlet)** com escalonamento de atributos
  (`0.85×` a `1.30×`) e recuperação parcial entre rodadas (zero XP).
- Persistência Drift/SQLite (schema v8): exercícios (seed 64 pt-BR + en com guia
  passo a passo), treinos, séries, PRs (1RM Epley), atividades, saúde diária
  (água, dieta, sono), progresso da Arena e Torneios (`arena_progress`), fichas
  diárias (`daily_arena_logs`), classe selecionada (`heroes.selected_class`),
  título/cosmético equipados no herói, livro-razão de XP (incluindo
  `inspirationSpend`), missões.
- Telas: Herói (com seletor de classe desbloqueada, título/cosmético equipados
  via `HeroCustomizationSheet` e acesso à **Arena da Forja**), Arena & Torneios
  (`ArenaScreen`), Treino (estilo Hevy, timer de descanso, botão "?" de
  execução), Atividades (Pomodoro, hidratação, nutrição, sono, catálogo
  CAR/DES/SAB/INT/CON e atividade personalizada), Missões.
- Criação do herói; missões automáticas; Inspiração derivada do livro-razão.
- Visual pixel art, pt-BR + inglês, configurações e créditos.
- Rotinas (modelos + personalizadas), treino ativo estilo Hevy com séries
  por tempo, recordes calculados ao finalizar.
- Histórico, calendário, recordes, sequência semanal e tela de recompensas.
- 110 testes passando; `flutter analyze` limpo.

## Fechamento da Fase 1 (em andamento)
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
- [ ] **Etapa 5D (futuro):** Modo **Dungeon** (exploração por salas/nós com
      testes dos 6 atributos e encontros de combate).
- [ ] (Mais tarde) Sprites definitivos do herói por grupo muscular.

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
