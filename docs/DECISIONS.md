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
46. **Sistema Paper-Doll Customizável 16-bit (`28×36 px`) + Sprites de Oponentes (Etapa 6A):**
    - Estilo visual adotado: **Action-RPG 16-bit intermediário (`28×36` pixels)**,
      inspirado na referência do *Espadachim Negro (Berserk)* com contorno escuro
      (`#0F0F12`) e sombreamento automático de 3 tons (*highlight*, *base*,
      *shadow*) por camada.
    - Modelo puro no motor (`lib/core/game/hero_appearance.dart`): `HeroAppearance`
      configura independentemente `SkinTone` (6 tons), `EyeStyle` (5 estilos,
      incluindo cicatriz de 1 olho), `EyeColor` (6 cores), `HairStyle` (8 estilos,
      incluindo espetado com mecha branca, capuz e elmo), `HairColor` (6 cores),
      `BeardStyle` (5 estilos), `TorsoStyle` (6 camisas/armaduras), `LegsStyle`
      (6 calças/grevas), `BootsStyle` (6 botas/calçados), `BackStyle` (6 capas e
      armas nas costas, incluindo Espadão + Capa) e `OutfitTint` (6 paletas),
      além de **7 arquétipos pré-prontos (`HeroAppearancePreset`)**.
    - Persistido em `heroes.appearance` (schema v9) no formato extensível
      `chave=valor;...` e editável tanto no Onboarding quanto a qualquer momento
      na Ficha do Herói (`HeroCustomizationSheet`).
    - Oponentes da Arena, Torneios e Chefes de Masmorra possuem sprites próprios
      em `OpponentSprites` / `OpponentAvatar`.
47. **Palco de Batalha 16-bit e Animações Específicas por Arma/Classe (`AttackAnimationKind` + `CombatStageWidget`, Etapa 6B):**
    - Em combate (`ArenaScreen`), um palco visual 16-bit (`CombatStageWidget`)
      posiciona o Herói à esquerda e o Oponente à direita (espelhado
      horizontalmente) sobre o piso de pedra da forja sob o céu noturno.
    - `HeroAppearance.resolveAttackAnimation` resolve deterministicamente a
      animação do turno com base na `CharacterClass`, na arma equipada em
      `BackStyle` e na ação (`basicStrike`, `classSkill`, `defend`):
      1. `greatswordCleave`: Espadão Colossal em mãos (`HeroPose.attackGreatsword`) + arco cortante carmesim/aço;
      2. `staffArcaneCast`: Cajado Rúnico erguido (`HeroPose.attackStaff`) + círculo rúnico + orbe/feixe arcano que viaja até o inimigo e explode (Mago, Feiticeiro, Bruxo, Artífice ou Cajado equipado);
      3. `daggerShadowFlurry`: Adagas Gêmeas em mãos (`HeroPose.attackDaggers`) + investida rápida com rastro de sombra e corte duplo em `X` (Ladino);
      4. `bowPiercingShot`: Arco Longo esticado (`HeroPose.attackBow`) + disparo de flecha veloz com anéis de vento (Patrulheiro);
      5. `martialKiStrike`: Palma/Punho de Ki (`HeroPose.attackMartial`) + ondas de choque concêntricas douradas/jade (Monge);
      6. `holyRadiantSmite`: Espada Sagrada erguida (`HeroPose.attackHolyBlade`) + pilar vertical de luz divina e cruz radiante (Paladino, Templário, Clérigo);
      7. `eldritchRunicSlash`: Lâmina Rúnica + relâmpago arcano azul (Cavaleiro Arcano);
      8. `primalSongWave`: Ondas de ressonância e espinhos primais brotando sob o alvo (Druida, Bardo);
      9. `defensiveGuard`: Escudo forjado erguido (`HeroPose.guard`) + barreira protetora dourada.
    - Inclui respiração *idle* contínua, *hit flash/shake* ao receber dano,
      recuo de esquiva e popups flutuantes (`-Dano`, `CRIT!`, `FALHA 1!`,
      `+PV`, `ATORDOADO!`, `ESQUIVOU!`).
48. **Mini-Janela Interativa do d20 + Efeitos Sonoros Dark Fantasy Offline (Etapa 6C):**
    - Ao atacar na Arena/Torneio ou rolar uma provação de Masmorra, uma
      mini-janela central (`showInteractiveD20RollDialog`) solicita o toque do
      jogador no dado d20; ao tocar, o dado cai quicando na mesa de pedra, gira
      e revela o número natural (`1..20`) com a fórmula completa antes de
      disparar a animação da arma no palco. O número rolado é passado
      determinísticamente para `CombatEngine` (`forcedD20`).
    - Áudio 100% offline via síntese procedural PCM WAV 16-bit (`WavSynth` +
      `SoundService`), com reprodução nativa sem plugins extras no Windows
      (`winmm.dll!PlaySoundA` via `dart:ffi`) e fallback seguro em outras
      plataformas/testes, controlado por `settings.soundEnabled`.
49. **Arquitetura da Fase 2 — Modo História Interativo ("Mestre + Gatilhos de Motor"):**
    - O Modo História é uma campanha narrativa aberta conduzida pelo Mestre
      (`StoryNarrator`), conectada diretamente ao motor de regras (`story.dart`
      e `combat.dart`) por um protocolo estruturado de gatilhos:
      - `narrative`: diálogo/exploração livre;
      - `skillCheck`: pedido de teste em `Attribute` com dificuldade decidida
        pelo motor, resolvido na mini-janela `D20RollDialog` com opção de gastar
        **Inspiração** (`XpSource.inspirationSpend`) para re-rolar;
      - `combatTrigger`: transição direta para o palco 16-bit (`CombatStageWidget`
        + `CombatEngine`) com resultado devolvido ao Mestre após Vitória/Derrota.
    - Ritmo: **1 Arco Semanal com Capítulos livres (sem trava diária por enquanto)**,
      estruturado atrás de uma política (`StoryQuotaPolicy`) pronta para aplicar
      limites no futuro plano gratuito vs. ilimitado no plano pago.
    - Offline-first: `TemplateStoryNarrator` funciona 100% sem rede;
      `RemoteAiStoryNarrator` usará **BYOK** (chave Gemini própria salva
      localmente nas Configurações do dispositivo) por enquanto, com interface
      pronta para migrar para proxy/Edge Function no futuro e fallback automático
      para o narrador offline.
50. **18 Chefes Semanais Lendários (Catálogo Seguro + Mecânicas D&D 5e):**
    - Nova categoria de oponentes (`LegendaryBossSpec` em `combat.dart`) como
      Chefes Semanais do Modo História (e acessíveis para treino no Modo Tester).
    - **Nomes e habilidades Dark Fantasy originais** com inspiração reconhecível
      mas sem marcas/nomes literais de terceiros (Satorion, Ryomoth, Gonnir,
      Netherion, Meruvor, Kakarion, Toshirion, Aforion, Lord Vadric, Vegor,
      Naruval, Sasukar, Arthorius, Gerric, Kaibaron, Saurath, Erendir, Reinor).
    - Combinam 9 blocos mecânicos modulares no motor (`infinityBarrier`,
      `bleedSanctuary`, `telegraphedTriad`, `counterStance`, `tacticalAdaptation`,
      `multiPhaseAwakening`, `armorPlates`, `focusDrainAndBurn`,
      `powerStealOrSurge`).
    - **Disciplina real enfraquece o Chefe:** metas cumpridas na semana (treinos,
      hidratação, dieta, sono, missões) acumulam **Selos de Enfraquecimento**
      que reduzem PV, CA ou severidade das passivas do Chefe Lendário no Dia 7.
      Recompensas seguem Decisão #40 (**0 XP**; Títulos e Cosméticos Lendários).
51. **Backup & Restauração Portável (JSON):**
    - Para proteger o progresso dos usuários (especialmente no PWA do Safari/iOS),
      as Configurações oferecem Exportar e Importar snapshot JSON completo de
      treinos, rotinas, atividades, saúde, livro-razão de XP, herói e campanha.
53. **Arte dos personagens: estilo chibi 28×36** (aprovado pelo usuário; a
    tentativa 64×72 da #52 foi revertida):
    - Proporção chibi (cabelo/cabeça ≈ metade da altura), contorno preto
      grosso, 2–3 tons chapados por material, capas envolvendo o corpo.
    - **Fonte de verdade:** `tool/art/chibi_gen.py` → gera
      `lib/app/ui/paper_doll/chibi_layers.g.dart`. Cada peça é feita sobre
      **moldes do corpo** (poses parado/flexionando) para tudo se alinhar;
      cabelo espetado e rosto do herói vêm direto do protótipo aprovado.
      `tool/art/chibi_preview.py` gera a galeria PNG (paletas reais).
    - Nova camada `backFront.<estilo>` (parte da frente da capa, sobre o tronco).
    - Mesmas 11 categorias, tamanho e paleta de antes; inimigos herdam o estilo.
    - **Regra:** nenhuma troca de arte em massa sem protótipo aprovado.
