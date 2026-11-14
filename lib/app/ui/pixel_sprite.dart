import 'package:material_ui/material_ui.dart';

/// Multi-color pixel sprite: each character in [rows] maps to a color in
/// [palette]; '.' is transparent.
class PixelSprite extends StatelessWidget {
  const PixelSprite({super.key, required this.rows, required this.palette, this.pixelSize = 4});

  final List<String> rows;
  final Map<String, Color> palette;
  final double pixelSize;

  @override
  Widget build(BuildContext context) {
    final w = rows.fold<int>(0, (m, r) => r.length > m ? r.length : m);
    return CustomPaint(
      size: Size(w * pixelSize, rows.length * pixelSize),
      painter: _SpritePainter(rows, palette, pixelSize),
    );
  }
}

class _SpritePainter extends CustomPainter {
  _SpritePainter(this.rows, this.palette, this.px);

  final List<String> rows;
  final Map<String, Color> palette;
  final double px;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (var y = 0; y < rows.length; y++) {
      for (var x = 0; x < rows[y].length; x++) {
        final color = palette[rows[y][x]];
        if (color == null) continue;
        paint.color = color;
        canvas.drawRect(Rect.fromLTWH(x * px, y * px, px + 0.3, px + 0.3), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_SpritePainter old) => old.rows != rows || old.px != px;
}

/// Placeholder hero sprites until the final art is commissioned.
abstract final class HeroSprites {
  static const Map<String, Color> palette = {
    'H': Color(0xFF2B1D16), // hair
    'F': Color(0xFFC9906A), // skin
    'K': Color(0xFF0F0F12), // eyes / outline
    'R': Color(0xFF9E2A2B), // crimson cloth
    'S': Color(0xFF9E9FA5), // steel armor
    'D': Color(0xFF353945), // dark steel
  };

  static const idle = [
    '......HHHH......',
    '.....HHHHHH.....',
    '.....HFFFFH.....',
    '.....FKFFKF.....',
    '.....FFFFFF.....',
    '......FRRF......',
    '...DDSSSSSSDD...',
    '..DSSSDDDDSSSD..',
    '..DSSSSRRSSSSD..',
    '..FFSSSRRSSSFF..',
    '..FF.SSSSSS.FF..',
    '..FF.SDDDDS.FF..',
    '..FF.SSSSSS.FF..',
    '.....DD..DD.....',
    '.....SS..SS.....',
    '.....SS..SS.....',
    '.....SS..SS.....',
    '....DDD..DDD....',
  ];
}
