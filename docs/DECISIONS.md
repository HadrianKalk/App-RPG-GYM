# DECISIONS — registro de decisões de design e arquitetura

_Decisões que não devem ser revertidas sem discussão. Adicione novas no fim,
numeradas. Se uma decisão for substituída, marque como **Substituída por #N**._

1. **Motor decide, UI exibe, IA narra.** IA nunca gera números de jogo.
2. **Livro-razão de XP imutável** como fonte de verdade do estado do herói.
3. **Atributos começam em 10**; modificador = ⌊(score−10)/2⌋.
4. **Custo de atributo:** 300 × (S−9)^1.5 XP para S→S+1.
5. **XP por nível:** round(150 × (L−1)² × 1.2 + 200 × (L−1)), níveis 1–20.
6. **XP base:** 1 min focado = 1 XP × intensidade (0.75 / 1.0 / 1.25);
   série efetiva = 4 XP × intensidade; PR = +25 XP.
7. **Retornos decrescentes diários por atributo:** 0–60 min 100%, 60–120 75%,
   120–180 50%, 180+ 25%.
8. **Classe emerge** dos 2 atributos com mais XP (tabela em `class_resolver.dart`);
   Aventureiro se dispersão < 60 XP ou < 12%.
9. **3 missões diárias determinísticas** (seed = AAAAMMDD): Superação, Dever da
   Classe, Desafio Diário. Recompensa: XP + Inspiração.
10. **Nome desacoplado** em `lib/app/brand.dart`; pacote `package:app`.
11. **Offline-first** com Drift/SQLite em todas as plataformas.
12. **Origem do herói é só narrativa** — nenhuma origem dá bônus numérico.
    Forma de tratamento (Herói/Heroína/Lenda) existe porque o pt-BR é flexionado.
13. **Missões avançam só por ações registradas**, nunca por botão manual.
    Séries contam para missões em séries; minutos do treino são divididos entre
    atributos pela proporção de séries (teto 180 min/treino); sono ≥ 8h conclui
    a missão de CON; o "XP de sono" não conta como minutos.
14. **Missões do dia são sorteadas antes do XP da primeira ação do dia.**
15. **Inspiração = nº de missões diárias cumpridas** (derivado do livro-razão).
16. **Modularidade > velocidade**: catálogos como dados, features isoladas
    (ver AGENTS.md §2).
17. **Idiomas pt-BR + en** desde a Fase 1; conteúdo de jogo também é traduzido.
18. **Comentários de código em inglês.**
19. **Rotinas**: 4 modelos fixos (Push, Pull, Legs, Cardio & Mobilidade) como
    ponto de partida + rotinas personalizadas criadas pelo usuário com
    exercícios do catálogo.
20. **Visual pixel art (revamp)**: fonte **Jersey 10** (títulos, números,
    botões, rótulos) + **Inter** (texto corrido). Molduras com cantos em
    degrau, barras segmentadas, ícones em pixel. Fontes empacotadas como
    assets (offline), sem baixar do Google em runtime.
    Referência aprovada: `docs/design/prototype-pixel-v1.png`.
21. **Sequência semanal** em vez de diária: meta padrão **3 treinos/semana**
    (ajustável no perfil); a sequência conta semanas seguidas com a meta
    cumprida. Calendário do mês mostra os dias treinados (sem contador que zera).
22. **Bônus por consistência** (valores em `xp_rules.dart`, ajustáveis):
    - *Meta Cumprida*: +50 XP ao atingir a meta da semana.
    - *Além do Dever*: cada treino acima da meta na semana: +15, +20, +25…
      (até 7 treinos/semana).
    - *Chama da Constância*: +10% nos bônus semanais por semana seguida com
      meta cumprida (máx. +50%).
    - Toda recompensa aparece **com o motivo** na tela "Treino Concluído",
      linha por linha, para reforçar a sensação de conquista.
23. **Configurações**: idioma (aparelho / pt / en) e estilo de fonte de
    destaque (Pixel = Jersey 10 / Clássica = Cinzel). Texto corrido sempre Inter.
    Idioma do aparelho não suportado → inglês.
24. **Créditos**: tela em Configurações › Créditos, lista em
    `lib/features/settings/domain/credits.dart`. Primeiro nome: Leonardo Heck
    (Apoio e ideias).
25. **Constituição = saúde**: além de cardio e sono, CON passa a incluir
    hidratação (meta diária de água) e adesão à dieta (check-in diário).
    Implementar junto do registro de atividades (item 4 do STATUS). Sem
    alegações médicas; metas ajustáveis pelo usuário.
26. **Catálogo de exercícios sincronizado** a cada inicialização a partir de
    `exercise_seed.dart` (upsert), com taxonomia normalizada
    (`MuscleGroup`, `Equipment`, `SetTracking`).
27. **Rotinas**: modelos fixos são dados em `lib/data/seed/routine_seed.dart`
    (nomes traduzidos via `routine.<id>.*`); rotinas personalizadas ficam no
    banco (`routines` + `routine_exercises`). A UI só vê `Routine`.
    Modelos podem ser **copiados** para "Minhas Rotinas" e editados.
28. **Séries por tipo** (`SetTracking`): peso×reps, só reps ou tempo.
    XP de série por tempo = 1 XP/min, mínimo de uma série comum (4 XP).
29. **Recorde Pessoal**: a primeira marca de um exercício é só *baseline*
    (sem bônus). Bônus de PR só ao bater marca existente, no máximo **1 por
    exercício por treino**. Todo XP (séries e PRs) é concedido **ao finalizar**
    o treino — desmarcar séries ou descartar o treino nunca deixa XP órfão.
30. **Pré-preenchimento**: ao iniciar rotina/adicionar exercício, cada série
    copia a série correspondente do último treino finalizado com aquele
    exercício; sem histórico, usa a meta da rotina.
31. **Origem personalizada** do herói: opção "Origem própria" com nome
    (obrigatório, até 32) e história (opcional, até 240). Só narrativa.
