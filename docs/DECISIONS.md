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
