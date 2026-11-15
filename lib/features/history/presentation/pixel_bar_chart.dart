import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';

/// Blocky bar chart (each bar is a stack of pixel blocks). Values are
/// quantized to whole blocks so it reads as pixel art.
class PixelBarChart extends StatelessWidget {
  const PixelBarChart({
    super.key,
    required this.values,
    this.height = 140,
    this.color = AppTheme.emberGold,
    this.highlightLast = true,
  });

  final List<double> values;
  final double height;
  final Color color;
  final bool highlightLast;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _BarPainter(values, color, highlightLast)),
    );
  }
}

class _BarPainter extends CustomPainter {
  _BarPainter(this.values, this.color, this.highlightLast);

  final List<double> values;
  final Color color;
  final bool highlightLast;

  static const double block = 6;
  static const double gap = 2;

  @override
  void paint(Canvas canvas, Size size) {
    final base = Paint()..color = AppTheme.forgedSteel;
    canvas.drawRect(Rect.fromLTWH(0, size.height - 2, size.width, 2), base);
    if (values.isEmpty) return;

    final maxV = values.reduce((a, b) => a > b ? a : b);
    final minV = values.reduce((a, b) => a < b ? a : b);
    // Start the scale a bit below the minimum so small gains are visible.
    final floor = (minV * 0.8).clamp(0.0, double.infinity);
    final span = (maxV - floor) <= 0 ? 1.0 : maxV - floor;
    final maxBlocks = ((size.height - 4) / (block + gap)).floor();
    final barWidth = (size.width / values.length).clamp(6.0, 28.0) - 4;

    for (var i = 0; i < values.length; i++) {
      final blocks = (((values[i] - floor) / span) * (maxBlocks - 1)).round() + 1;
      final isLast = highlightLast && i == values.length - 1;
      final isMax = values[i] == maxV;
      final paint = Paint()..color = isLast ? AppTheme.emberOrange : (isMax ? color : color.withValues(alpha: 0.55));
      final x = i * (size.width / values.length) + 2;
      for (var b = 0; b < blocks; b++) {
        final y = size.height - 4 - (b + 1) * (block + gap) + gap;
        canvas.drawRect(Rect.fromLTWH(x, y, barWidth, block), paint);
      }
    }
  }

  @override
  bool shouldRepaint(_BarPainter old) => old.values != values || old.color != color;
}
