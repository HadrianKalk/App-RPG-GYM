import 'package:material_ui/material_ui.dart';

/// Pixel-art icon drawn from a character grid (see [PixelIcons]).
///
/// Grid legend: `#` = main color, `+` = accent color, `.` = transparent.
class PixelIcon extends StatelessWidget {
  const PixelIcon(this.grid, {super.key, this.size = 24, this.color, this.accent});

  final List<String> grid;
  final double size;

  /// Main color; defaults to the ambient [IconTheme] color.
  final Color? color;

  /// Accent color; defaults to a darker shade of [color].
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final main = color ?? IconTheme.of(context).color ?? Colors.white;
    return SizedBox.square(
      dimension: size,
      child: CustomPaint(
        painter: _GridPainter(grid, main, accent ?? Color.lerp(main, Colors.black, 0.45)!),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  _GridPainter(this.grid, this.main, this.accent);

  final List<String> grid;
  final Color main;
  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final rows = grid.length;
    final cols = grid.fold<int>(0, (m, r) => r.length > m ? r.length : m);
    final cell = size.width / (cols > rows ? cols : rows);
    final mainPaint = Paint()..color = main;
    final accentPaint = Paint()..color = accent;
    for (var y = 0; y < rows; y++) {
      final row = grid[y];
      for (var x = 0; x < row.length; x++) {
        final c = row[x];
        if (c == '.') continue;
        // Slight overlap avoids hairline gaps between cells.
        canvas.drawRect(
          Rect.fromLTWH(x * cell, y * cell, cell + 0.3, cell + 0.3),
          c == '+' ? accentPaint : mainPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) =>
      old.grid != grid || old.main != main || old.accent != accent;
}

/// Icon catalog. Add a new icon by adding a grid here (any square size).
abstract final class PixelIcons {
  static const shield = [
    '..####..',
    '.######.',
    '.#++++#.',
    '.#+##+#.',
    '.#+##+#.',
    '..#++#..',
    '...##...',
    '........',
  ];
  static const dumbbell = [
    '........',
    '........',
    '##....##',
    '########',
    '##....##',
    '........',
    '........',
    '........',
  ];
  static const hourglass = [
    '########',
    '.#++++#.',
    '..#++#..',
    '...##...',
    '..#..#..',
    '.#.++.#.',
    '########',
    '........',
  ];
  static const scroll = [
    '.######.',
    '#+....+#',
    '.#.##.#.',
    '.#....#.',
    '.#.##.#.',
    '#+....+#',
    '.######.',
    '........',
  ];
  static const flame = [
    '...#....',
    '..##....',
    '..###.#.',
    '.##+###.',
    '.#+++##.',
    '.#++++#.',
    '..#++#..',
    '........',
  ];
  static const star = [
    '...#....',
    '...#....',
    '#######.',
    '..###...',
    '.##.##..',
    '#.....#.',
    '........',
    '........',
  ];
  static const check = [
    '........',
    '......#.',
    '.....##.',
    '#...##..',
    '##.##...',
    '.###....',
    '..#.....',
    '........',
  ];
  static const gear = [
    '...##...',
    '.#.##.#.',
    '..####..',
    '###..###',
    '###..###',
    '..####..',
    '.#.##.#.',
    '...##...',
  ];
  static const plus = [
    '........',
    '...##...',
    '...##...',
    '.######.',
    '.######.',
    '...##...',
    '...##...',
    '........',
  ];
  static const back = [
    '........',
    '...#....',
    '..##....',
    '.#######',
    '..##....',
    '...#....',
    '........',
    '........',
  ];
  static const heart = [
    '........',
    '.##.##..',
    '#######.',
    '#######.',
    '.#####..',
    '..###...',
    '...#....',
    '........',
  ];
  static const trophy = [
    '#######.',
    '#.###.#.',
    '.#####..',
    '..###...',
    '...#....',
    '..###...',
    '.#####..',
    '........',
  ];
}
