# STATUS — estado atual do projeto

_Atualize este arquivo sempre que o estado ou os próximos passos mudarem._

**Última atualização:** 2026-11-15 (Gemini / Antigravity) — Etapa 5B: Persistência + Tela da Arena 1v1 + Títulos e Cosméticos no Herói

## Fase atual
**Fase 1 — MVP offline: fechando lacunas** antes da Fase 2 (ver abaixo).

## O que existe
- Motor de jogo (`lib/core/game/`): atributos D&D, XP com retornos decrescentes
  unificados por atributo (treinos e atividades, bônus isentos), progressão de
  atributos (base 10) e níveis 1–20, 15 classes emergentes + Aventureiro,
  missões diárias determinísticas, Inspiração e **motor de combate tático em
  turnos (`combat.dart`)** com 16 habilidades de classe inspiradas no D&D 5e e
  6 NPCs da Arena (recompensas: títulos e cosméticos, zero XP).
- Persistência Drift/SQLite (schema v7): exercícios (seed 64 pt-BR + en com guia
  passo a passo), treinos, séries, PRs (1RM Epley), atividades, saúde diária
  (água, dieta, sono), progresso da Arena (`arena_progress`), fichas diárias
  da Arena (`daily_arena_logs`), título/cosmético equipados no herói, livro-razão
  de XP (incluindo `inspirationSpend`), missões.
- Telas: Herói (com título/cosmético equipados, seletor `HeroCustomizationSheet`
  e acesso à **Arena da Forja**), Arena 1v1 (`ArenaScreen`), Treino (estilo
  Hevy, timer de descanso, botão "?" de execução), Atividades (Pomodoro,
  hidratação, nutrição, sono, catálogo CAR/DES/SAB/INT/CON e atividade
  personalizada), Missões.
- Criação do herói; missões automáticas; Inspiração derivada do livro-razão.
- Visual pixel art, pt-BR + inglês, configurações e créditos.
- Rotinas (modelos + personalizadas), treino ativo estilo Hevy com séries
  por tempo, recordes calculados ao finalizar.
- Histórico, calendário, recordes, sequência semanal e tela de recompensas.
- 107 testes passando; `flutter analyze` limpo.

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
- [ ] **Etapa 5C (futuro):** Torneios (sequência de oponentes com escalonamento)
      e Dungeon (exploração por salas com testes dos 6 atributos).
- [ ] (Mais tarde) Sprites definitivos do herói por grupo muscular.
- [ ] (Backlog) **Seleção de classe desbloqueada**: permitir trocar entre classes
      cujos pré-requisitos de atributos o herói já cumpriu (Decisão #41).

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
