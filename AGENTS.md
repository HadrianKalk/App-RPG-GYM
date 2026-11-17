# AGENTS.md — Regras do projeto para qualquer agente de IA

> Fonte única de verdade para **todos** os agentes (Claude Code, Gemini/Antigravity,
> Copilot, etc.). `CLAUDE.md` e `GEMINI.md` apenas apontam para este arquivo.
> Se uma regra mudar, mude **aqui**.

## 0. Protocolo de sincronização (OBRIGATÓRIO)

Vários agentes trabalham neste repositório em momentos diferentes. O **Git é a
única memória compartilhada** — nada que fique só no chat de um agente existe
para o outro.

**Ao iniciar uma sessão:**
1. `git pull` (ou `git fetch` + rebase) para pegar o trabalho mais recente.
2. Ler `docs/STATUS.md` (estado atual + próximos passos) e as últimas entradas
   de `docs/DEVLOG.md`.
3. Se for mexer em regras de jogo, ler `docs/DECISIONS.md`.

**Ao encerrar uma sessão (ou um bloco de trabalho relevante):**
1. Rodar `flutter analyze` e `flutter test` — ambos devem passar.
2. Adicionar uma entrada **no topo** de `docs/DEVLOG.md` (formato abaixo).
3. Atualizar `docs/STATUS.md` se o estado/próximos passos mudaram.
4. Se uma decisão de design/arquitetura foi tomada, registrar em `docs/DECISIONS.md`.
5. Commit + push. Trabalho não enviado ao GitHub = trabalho perdido para o outro agente.
6. **Ao sugerir a próxima etapa ao usuário:** sempre indicar junto qual modelo e
   nível de intensidade são ideais para executá-la, visando o melhor
   custo-benefício para o caso (ex.: *"Para esse caso, o modelo ideal é Gemini 4
   Argon (Medium), pois ele cumpre todos os papéis e tem o melhor
   custo-benefício."*).

Formato da entrada do DEVLOG:
```
## AAAA-MM-DD — <agente> — <título curto>
- O que foi feito
- Arquivos principais tocados
- Pendências / avisos para o próximo agente
```

## 1. Visão do produto

**Grindheim** (franquia **RPGym**): registro de treinos de musculação no nível
do Hevy + RPG de mesa inspirado em D&D 5e. Ações reais (treino, estudo, sono,
meditação) alimentam os atributos do herói. Estética Dark Fantasy (Berserk /
Dark Souls), visual **pixel art**. Idiomas: **pt-BR e inglês**.

Paleta: Obsidiana `#0F0F12`, Ferro Fundido `#181A20`, Brasa Dourada `#E0A96D`,
Sangue Carmesim `#9E2A2B`.

## 2. Regras de arquitetura (não violar)

- **"O motor decide, a UI exibe, a IA apenas narra."** A IA (Fase 2) nunca
  inventa XP, atributos, rolagens ou qualquer número. Todo número vem de
  `lib/core/game/`.
- `lib/core/game/` é **Dart puro**: zero imports de Flutter, Drift, Riverpod.
  Toda regra nova de jogo vai aqui e ganha teste em `test/core/game/`.
- **Livro-razão de XP (`xp_ledger`) é imutável** (append-only). O estado do herói
  é sempre derivado dele. Correções = novos lançamentos, nunca UPDATE/DELETE.
- Constantes de balanceamento ficam em `xp_rules.dart`, não espalhadas.
- O nome do app vive **só** em `lib/app/brand.dart`. Nunca escrever "Grindheim"
  ou "RPGym" literal em outro lugar. Pacote Dart é `package:app/...`.
- Offline-first: o app deve funcionar sem rede. Rede (IA, sync) é opcional.
- Provedores externos (IA etc.) ficam atrás de uma interface, trocáveis.
- **Flexibilidade e modularidade acima de velocidade.** Preferir a solução
  mais extensível mesmo que custe mais agora. Em especial:
  - Catálogos (atividades, rotinas, exercícios, origens, missões…) são
    **dados**, definidos em um único lugar e consumidos pela UI — nunca listas
    fixas espalhadas em widgets. Adicionar/remover um item não deve exigir
    mexer em telas.
  - Cada feature isolada em seu módulo (`features/<nome>/`), comunicando-se
    via repositórios/providers, não por acesso direto entre telas.
- **Idiomas: pt-BR e inglês desde já.** Nenhum texto visível ao usuário fica
  literal no código: tudo passa pelo sistema de localização (arquivos ARB).
  Isso inclui conteúdo de jogo (nomes de classes, origens, missões,
  exercícios, atividades). O motor (`core/game/`) expõe **chaves/ids**, e a
  camada de UI resolve o texto no idioma atual.

## 3. Estrutura

```
lib/app/            brand, theme (+ DisplayFont), router (GoRouter)
lib/app/ui/         kit pixel: PixelFrame, PixelButton, SegmentedBar, PixelTag,
                    PixelIcon(s), PixelSprite, PixelNavBar, GameAppBar
lib/core/game/      motor de jogo (Dart puro, só ids — sem textos)
lib/data/           Drift (SQLite), seed/catálogo de exercícios, repositories, providers
lib/features/<x>/   telas e lógica de cada feature (character, workout,
                    activities, quests, onboarding, settings)
lib/l10n/arb/       textos de interface (app_pt.arb = modelo, app_en.arb)
lib/l10n/content/   conteúdo de jogo traduzido (mapas por idioma, chaves estáveis)
lib/l10n/generated/ gerado pelo `flutter gen-l10n` (commitado)
assets/fonts/       Jersey 10, Inter, Cinzel (+ licenças OFL)
tool/art/           gerador da arte dos personagens (Python + Pillow) — ver decisão #53
test/               motor, repositórios (SQLite em memória), widgets, l10n
docs/               STATUS, DEVLOG, DECISIONS, design/
```

Stack: Flutter 3.50 / Dart 3.14, `material_ui` (no lugar do Material
embutido), Riverpod, go_router, Drift, shared_preferences.

### Como adicionar textos
- **Texto de interface:** adicionar a chave em `lib/l10n/arb/app_pt.arb` **e**
  `app_en.arb`, rodar `flutter gen-l10n`, usar `context.l10n.<chave>`.
- **Conteúdo de jogo** (exercício, classe, missão…): adicionar a chave em
  `lib/l10n/content/game_content_pt.dart` **e** `_en.dart`; usar
  `context.game.<método>`. O teste `test/l10n/game_content_test.dart` falha se
  faltar tradução.
- Delegates de localização: usar `appLocalizationsDelegates` (de
  `lib/l10n/l10n.dart`), **nunca** `AppLocalizations.localizationsDelegates`
  (quebra campos de texto em pt por causa do `material_ui`).

## 4. Comandos

```bash
flutter pub get
flutter gen-l10n                                          # após editar arquivos .arb
flutter analyze
flutter test
dart run build_runner build --delete-conflicting-outputs   # após mudar o schema do Drift
flutter run -d chrome    # ou -d windows / dispositivo Android
```

## 5. Convenções

- Commits no estilo Conventional Commits em pt-BR: `feat:`, `fix:`, `refactor:`,
  `test:`, `docs:`, `chore:`.
- Mudou schema do Drift → incrementar `schemaVersion`, escrever migração,
  regerar `database.g.dart` e commitar o arquivo gerado.
- **Comentários de código em inglês**, descrevendo o que cada etapa faz /
  deve fazer (doc comments em classes e métodos públicos, comentários curtos
  nos passos não óbvios). Identificadores em inglês. Textos de UI via
  localização (pt-BR + en). Docs em `docs/` continuam em pt-BR.
  Código antigo com comentários em pt-BR é convertido quando for tocado.
- Não adicionar dependências sem registrar o motivo no DEVLOG.
