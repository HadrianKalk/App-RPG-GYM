# STATUS — estado atual do projeto

_Atualize este arquivo sempre que o estado ou os próximos passos mudarem._

**Última atualização:** 2026-11-14 (Claude Code) — Etapa 1 concluída

## Fase atual
**Fase 1 — MVP offline: fechando lacunas** antes da Fase 2 (ver abaixo).

## O que existe
- Motor de jogo (`lib/core/game/`): atributos D&D, XP com retornos decrescentes,
  progressão de atributos (base 10) e níveis 1–20, 15 classes emergentes +
  Aventureiro, missões diárias determinísticas e Inspiração.
- Persistência Drift/SQLite: exercícios (seed 60+ pt-BR), treinos, séries, PRs
  (1RM Epley), atividades, livro-razão de XP, missões.
- Telas: Herói, Treino (estilo Hevy, timer de descanso), Atividades (Pomodoro,
  sono, meditação), Missões.
- Criação do herói; missões automáticas; Inspiração derivada do livro-razão.
- Visual pixel art, pt-BR + inglês, configurações e créditos.
- 43 testes passando; `flutter analyze` limpo.

## Fechamento da Fase 1 (em andamento)
- [x] Criação do herói (onboarding).
- [x] Missões avançam sozinhas com treinos/atividades; Inspiração real.
- [x] **Etapa 1:** pt-BR + inglês, visual pixel (Jersey 10 + Inter),
      configurações (idioma, fonte), créditos.
- [ ] **Etapa 2:** rotinas — 4 modelos fixos (Push/Pull/Legs/Cardio &
      Mobilidade) + rotinas personalizadas; séries por tempo e só-reps.
- [ ] **Etapa 3:** histórico de treinos, PRs, evolução de carga, sequência
      semanal (meta padrão 3) + calendário do mês, bônus (Meta Cumprida, Além
      do Dever, Chama da Constância) e tela "Treino Concluído".
- [ ] **Etapa 4:** registro de atividades genérico (catálogo: CAR, DES, CON,
      SAB, INT) + saúde em CON (água e dieta).
- [ ] Botão "?" em cada exercício (passo a passo; imagens a definir).
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
- Telas de Treino ativo e Atividades ganharam o visual novo, mas serão
  refeitas nas etapas 2–4 (rotinas, séries por tempo, recompensas).
- Comentários antigos em pt-BR ainda existem em arquivos não tocados
  (motor: progression, xp_calculator, class_resolver; repositórios).
- Documentos de design originais (`game_design.md`, `implementation_plan.md`,
  `walkthrough.md`) estão só no PC, na pasta do Antigravity — copiar para `docs/`.
