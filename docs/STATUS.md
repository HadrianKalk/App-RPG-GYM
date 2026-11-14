# STATUS — estado atual do projeto

_Atualize este arquivo sempre que o estado ou os próximos passos mudarem._

**Última atualização:** 2026-11-14 (Claude Code)

## Fase atual
**Fase 1 — MVP offline: concluída.** Próxima: Fase 2 (Mundo Vivo & Narrador IA).

## O que existe
- Motor de jogo (`lib/core/game/`): atributos D&D, XP com retornos decrescentes,
  progressão de atributos (base 10) e níveis 1–20, 15 classes emergentes +
  Aventureiro, missões diárias determinísticas e Inspiração.
- Persistência Drift/SQLite: exercícios (seed 60+ pt-BR), treinos, séries, PRs
  (1RM Epley), atividades, livro-razão de XP, missões.
- Telas: Herói, Treino (estilo Hevy, timer de descanso), Atividades (Pomodoro,
  sono, meditação), Missões.
- 15 testes passando; `flutter analyze` limpo (último verificado pelo Gemini).

## Próximos passos (Fase 2)
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
- Documentos de design originais (`game_design.md`, `implementation_plan.md`,
  `walkthrough.md`) estão só no PC, na pasta do Antigravity — copiar para `docs/`.
