import 'package:material_ui/material_ui.dart';

import '../theme.dart';
import 'pixel_border.dart';

/// RPG-window style panel: stepped corners, solid border, optional tap.
///
/// Use [highlight] for important panels (gold border + inner bevel line).
class PixelFrame extends StatelessWidget {
  const PixelFrame({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.color = AppTheme.castIron,
    this.borderColor,
    this.highlight = false,
    this.onTap,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final Color color;
  final Color? borderColor;
  final bool highlight;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final border = borderColor ?? (highlight ? AppTheme.emberGold : AppTheme.ironBorder);
    Widget content = Padding(padding: padding, child: child);

    // Highlighted frames get a thin dark-gold inner line (bevel effect).
    if (highlight) {
      content = DecoratedBox(
        decoration: const ShapeDecoration(
          shape: PixelBorder(side: BorderSide(color: Color(0xFF5A4127), width: 2), step: 2),
        ),
        child: content,
      );
    }

    final frame = Material(
      color: color,
      shape: PixelBorder(side: BorderSide(color: border, width: 3)),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? content : InkWell(onTap: onTap, child: content),
    );
    return margin == null ? frame : Padding(padding: margin!, child: frame);
  }
}
