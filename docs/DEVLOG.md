# DEVLOG — diário de desenvolvimento compartilhado

_Entradas mais recentes no topo. Todo agente (e humano) registra aqui o que fez
ao fim de cada sessão. Formato definido em `AGENTS.md` §0._

## 2026-11-14 — Claude Code — Correção: assertion de ListTile no seletor de exercícios
- `exercise_picker_sheet.dart`: fundo do modal trocado de `Container` colorido
  para `Material` (mesma cor/borda). Antes, cada item da lista disparava
  "ListTile background color or ink splashes may be invisible" no modo debug.
- Novo teste `test/features/workout/exercise_picker_sheet_test.dart` (falha sem
  a correção). 16 testes passando.
- Aviso: o app importa `package:material_ui/material_ui.dart`, não
  `flutter/material.dart` — testes de widget devem usar o mesmo import.
- A mensagem "Using WasmStorageImplementation.sharedIndexedDb..." na Web é
  informativa (Drift escolhendo o armazenamento), não é erro.

## 2026-11-14 — Claude Code — Correção: banco de dados na Web
- Bug: na Web todas as telas davam "When compiling to the web, the `web`
  parameter needs to be set" — o Drift não sabia carregar o SQLite em WebAssembly.
- Adicionados `web/sqlite3.wasm` (sqlite3 3.9.1) e `web/drift_worker.js`
  (drift 2.35.4); `driftDatabase(...)` em `lib/data/database.dart` agora recebe
  `DriftWebOptions`.
- **Aviso:** ao atualizar `drift` ou `sqlite3` no pubspec, baixe de novo os dois
  arquivos nas releases correspondentes do GitHub (simolus3/drift e
  simolus3/sqlite3.dart), senão a Web quebra.
- Verificado: analyze limpo, 15 testes ok, build web aberto no Chromium sem erros.

## 2026-11-14 — Claude Code — Protocolo de sincronização entre agentes
- Criados `AGENTS.md` (regras únicas), `CLAUDE.md` e `GEMINI.md` (ponteiros),
  `docs/STATUS.md`, `docs/DEVLOG.md`, `docs/DECISIONS.md`, `.gitattributes`.
- Nenhuma mudança de código.
- Próximo agente: copiar os docs de design do Antigravity para `docs/design/`.

## 2026-11 — Gemini (Antigravity) — Fase 1 MVP offline
- Commits `f73f73c` (scaffold) e `2943fe4` (motor D&D, Drift, seed, telas).
- 15 testes passando, analyze limpo.
