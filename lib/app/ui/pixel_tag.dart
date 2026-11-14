import 'package:material_ui/material_ui.dart';

import '../theme.dart';

/// Small bordered label (attribute codes, class badges, counters).
class PixelTag extends StatelessWidget {
  const PixelTag({
    super.key,
    required this.text,
    this.color = AppTheme.emberGold,
    this.background = AppTheme.obsidianBlack,
    this.fontSize = 16,
    this.leading,
  });

  final String text;
  final Color color;
  final Color background;
  final double fontSize;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(color: background, border: Border.all(color: color, width: 2)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 4)],
          Text(text, style: DisplayFont.from(context).style(fontSize, color: color)),
        ],
      ),
    );
  }
}
