import 'package:material_ui/material_ui.dart';

import '../theme.dart';

/// Progress bar made of discrete blocks (pixel-art style).
class SegmentedBar extends StatelessWidget {
  const SegmentedBar({
    super.key,
    required this.value,
    this.segments = 20,
    this.color = AppTheme.emberGold,
    this.height = 8,
  });

  /// Progress from 0.0 to 1.0 (clamped).
  final double value;
  final int segments;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final filled = (value.clamp(0.0, 1.0) * segments).round();
    return Row(
      children: [
        for (var i = 0; i < segments; i++) ...[
          if (i > 0) const SizedBox(width: 2),
          Expanded(
            child: Container(
              height: height,
              decoration: BoxDecoration(
                color: i < filled ? color : AppTheme.obsidianBlack,
                border: Border.all(
                  color: i < filled ? color.withValues(alpha: 0.6) : AppTheme.forgedSteel,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
