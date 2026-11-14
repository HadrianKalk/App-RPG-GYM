import 'package:material_ui/material_ui.dart';

/// A rectangle with stepped ("pixel") corners and a solid border.
///
/// Works anywhere a [ShapeBorder] is accepted (Material, Ink, buttons), so
/// ink splashes are clipped to the pixel shape.
class PixelBorder extends OutlinedBorder {
  const PixelBorder({
    super.side = const BorderSide(color: Color(0xFF353945), width: 3),
    this.step = 3,
  });

  /// Size of each corner step in logical pixels.
  final double step;

  /// Builds the stepped outline of [rect] (two steps per corner).
  Path _stepped(Rect rect, double s) {
    final l = rect.left, t = rect.top, r = rect.right, b = rect.bottom;
    final s2 = s * 2;
    return Path()
      ..moveTo(l + s2, t)
      ..lineTo(r - s2, t)
      ..lineTo(r - s2, t + s)
      ..lineTo(r - s, t + s)
      ..lineTo(r - s, t + s2)
      ..lineTo(r, t + s2)
      ..lineTo(r, b - s2)
      ..lineTo(r - s, b - s2)
      ..lineTo(r - s, b - s)
      ..lineTo(r - s2, b - s)
      ..lineTo(r - s2, b)
      ..lineTo(l + s2, b)
      ..lineTo(l + s2, b - s)
      ..lineTo(l + s, b - s)
      ..lineTo(l + s, b - s2)
      ..lineTo(l, b - s2)
      ..lineTo(l, t + s2)
      ..lineTo(l + s, t + s2)
      ..lineTo(l + s, t + s)
      ..lineTo(l + s2, t + s)
      ..close();
  }

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.width);

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) => _stepped(rect, step);

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      _stepped(rect.deflate(side.width), step);

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {
    if (side.style == BorderStyle.none || side.width == 0) return;
    // Border = outer shape minus inner shape.
    final path = Path()
      ..fillType = PathFillType.evenOdd
      ..addPath(getOuterPath(rect), Offset.zero)
      ..addPath(getInnerPath(rect), Offset.zero);
    canvas.drawPath(path, Paint()..color = side.color);
  }

  @override
  ShapeBorder scale(double t) => PixelBorder(side: side.scale(t), step: step * t);

  @override
  PixelBorder copyWith({BorderSide? side, double? step}) =>
      PixelBorder(side: side ?? this.side, step: step ?? this.step);
}
