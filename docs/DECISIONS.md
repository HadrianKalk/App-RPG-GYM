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
32. **Meta semanal conta DIAS de treino**, não sessões (evita farm com vários
    treinos curtos no mesmo dia). Bônus semanais só no **primeiro treino de
    cada dia**; a tela de recompensas explica quando não houve bônus.
    Semanas começam na segunda-feira (ISO).
33. **Meta semanal fica no herói** (tabela `heroes.weekly_goal`, 1–7, padrão 3),
    não nas preferências: é estado de jogo que afeta XP.
34. **Bônus semanal no livro-razão** (`XpSource.weeklyBonus`) é dividido
    entre os atributos treinados naquele treino, na proporção do XP das séries.
35. **Chama da Constância** conta a semana atual a partir do momento em que a
    meta é batida; semana em andamento nunca quebra a sequência.
36. **Catálogo de atividades (`ActivityCatalog`)**: hábitos fora da musculação
    (CAR, DES, SAB, INT, CON) são dados em `lib/core/game/activity_catalog.dart`,
    traduzidos via `activity.<id>.name`/`.description`, além de atividade
    personalizada com título, atributo, duração e intensidade.
37. **Saúde em Constituição (Hidratação & Dieta)**:
    - Hidratação em copos de 250 ml (`heroes.water_goal_cups`, 4–16, padrão 8).
      Cada copo novo até a meta concede +2 XP de CON; atingir a meta diária
      concede +10 XP bônus e +10 min na missão de CON. A marca d'água
      (`rewarded_water_cups` em `daily_health_logs`) impede farm com `-1/+1`
      preservando o livro-razão append-only.
    - Check-in diário de nutrição (1× por dia): Plano cumprido (+25 XP base,
      +10 min na missão de CON) ou Parcial (+12 XP base, +5 min na missão).
38. **Curva diária unificada por atributo (anti-burla sem frustrar):**
    - Todas as fontes de esforço (`workoutSet`, `pomodoroStudy`, `sleep`,
      `activity`, `hydration`, `nutrition`) passam pela curva diária do
      atributo: `0–60: 100%`, `60–120: 75%`, `120–180: 50%`, `180–300: 25%`,
      `300+: 0%` (teto diário de 165 XP de esforço por atributo).
    - Bônus motivacionais (`personalRecord`, `dailyQuest`, `weeklyBonus`,
      bônus de meta de água) **nunca** sofrem redução e **não** consomem a
      curva de esforço diário.
39. **Guia de execução ("?") em cada exercício:** passo a passo de execução e
    postura em `exercise.<id>.guide` (pt-BR e en) exibido em modal pixel a
    partir do treino ativo, seletor de exercícios e editor de rotinas.
40. **Combate sem XP (regras-base da Arena / Dungeon / Torneios):**
    - Nenhum modo de combate concede XP. Toda evolução numérica (nível e
      atributos) vem exclusivamente de hábitos e esforço no mundo real.
    - Recompensas dos modos de combate: **itens cosméticos e títulos**.
    - Pilares: **Arena** (duelos 1v1 contra NPCs), **Torneios** (chaves de
      múltiplos adversários com fator de escala `statScale` de `0.85×` a `1.30×`
      conforme o nível do torneio e recuperação parcial de `+35% PV` e `+50% Foco`
      entre rodadas) e **Dungeon** (exploração por salas/nós usando todos os 6
      atributos).
41. **Seleção de classe com pré-requisito de atributos (`ClassResolver`):**
    - `Aventureiro` e a classe emergente natural (`resolveClass`) estão sempre
      desbloqueados.
    - Qualquer uma das 15 classes híbridas é desbloqueada assim que seus dois
      atributos (`primary` e `secondary`) atingem pelo menos pontuação **12**
      (modificador **+1** no D&D 5e).
    - O jogador pode alternar livremente entre suas classes desbloqueadas (ou
      manter no modo Automático/Emergente) na ficha do herói, alterando também
      sua habilidade assinada na Arena e nos Torneios.
42. **Motor de Combate Tático em Turnos e Habilidades Inspiradas no D&D 5e (`combat.dart`):**
    - Combate 1v1 em turnos onde todos os 6 atributos têm função clara:
      - **FOR**: poder de golpe físico e penetração de guarda;
      - **DES**: iniciativa, chance de esquiva, chance de crítico e poder ágil;
      - **CON**: HP máximo e defesa física;
      - **INT**: reserva máxima de Foco (energia de habilidade) e poder arcano;
      - **SAB**: eficiência de cura, recuperação ao defender e leitura de intenção;
      - **CAR**: chance de crítico, multiplicador de presença e poder da Inspiração Heroica.
    - As 16 classes possuem habilidades assinadas inspiradas nos arquétipos do
      D&D 5e (*Surto de Ação*, *Fúria Ancestral*, *Destruição Divina*, *Ataque
      Furtivo*, *Ataque Atordoante*, *Rajada Mística*, *Chama Sagrada*, etc.).
    - O oponente telegrafa sua intenção (*Ataque*, *Golpe Pesado*, *Guarda*),
      premiando o uso tático de **Defender** ou **Atordoar**.
    - Fichas de entrada da Arena (`ArenaTokenRules`): 2 entradas grátis/dia + 1
      por treino concluído + 1 por missão diária cumprida + 1 por hábito de
      saúde (meta de água ou check-in de dieta).
43. **Rolagem `1d20 + Atributo + Proficiência` vs Classe de Armadura (`CA/AC`) e Classe de Dificuldade (`CD/DC`):**
    - Todo ataque do herói (`basicStrike`, `classSkill`) e toda provação de sala
      de masmorra rola `1d20 + mod(Atributo) + Bônus de Proficiência` contra a
      `CA` do oponente (ou `CD` da sala).
    - **20 Natural (ou Inspiração Heroica):** acerto crítico automático (`2.0×`
      de dano) com destaque dourado no dado d20 animado.
    - **1 Natural (Falha Absurda / *Critical Fumble*):** erro automático e o
      herói abre a guarda, sofrendo `6%` do PV máximo como dano de recuo.
    - **Acerto (`total >= CA`):** tanto a chance de acerto quanto o multiplicador
      de precisão do dano escalam com `d20 + mod(Atributo)`.
44. **Aba exclusiva de Combate (`PixelNavBar`) + Central de Modos + Dungeons (Etapa 5D):**
    - O combate vive na 5ª aba da barra inferior (`/combat`), mantendo a aba do
      Herói limpa e dedicada à ficha.
    - A Central de Combate apresenta 4 retângulos de seleção empilhados:
      1. **Modo História · Crônicas da Forja** (no topo, em destaque, bloqueado
         com badge `EM BREVE · FASE 2`);
      2. **Arena de Duelos (1v1)**;
      3. **Torneios da Forja (Gauntlet)**;
      4. **Masmorras Profundas (Dungeons — `DungeonCatalog`)**: 3 masmorras de
         múltiplas salas que testam todos os 6 atributos no d20 antes do Chefe
         final, concedendo títulos e cosméticos exclusivos (zero XP).
45. **Modo Tester / Sandbox (`TesterModeState` / `TesterPanelSheet`):**
    - Pode ser ativado por `--dart-define=TESTER_MODE=true` ou diretamente pelo
      botão **Modo Tester** na Central de Combate e nas Configurações.
    - Sobrescreve os 6 atributos (`8..30`), fichas de combate infinitas,
      Inspiração e permite forçar `20` (Crítico) ou `1` (Falha Absurda) no d20
      em memória (`CharacterState.fromOverrideScores`), sem jamais violar a
      imutabilidade do `xp_ledger`.
