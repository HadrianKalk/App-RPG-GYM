import 'package:material_ui/material_ui.dart';

import '../theme.dart';
import 'pixel_border.dart';

/// Visual variants of [PixelButton].
enum PixelButtonVariant { primary, secondary, danger }

/// Chunky beveled button (light top-left edge, dark bottom-right edge).
class PixelButton extends StatelessWidget {
  const PixelButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = PixelButtonVariant.primary,
    this.icon,
    this.expand = true,
    this.loading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final PixelButtonVariant variant;
  final Widget? icon;
  final bool expand;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !loading;
    final (Color bg, Color fg, Color light, Color dark) = switch (variant) {
      PixelButtonVariant.primary => (AppTheme.emberGold, AppTheme.obsidianBlack, AppTheme.emberGoldLight, AppTheme.emberGoldDark),
      PixelButtonVariant.secondary => (AppTheme.forgedSteel, AppTheme.ashWhite, AppTheme.ironBorder, AppTheme.obsidianBlack),
      PixelButtonVariant.danger => (AppTheme.bloodCrimson, AppTheme.ashWhite, const Color(0xFFC0504F), AppTheme.darkBlood),
    };
    final display = DisplayFont.from(context);

    final child = Container(
      constraints: const BoxConstraints(minHeight: 48),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: enabled ? light : AppTheme.ironBorder, width: 3),
          left: BorderSide(color: enabled ? light : AppTheme.ironBorder, width: 3),
          bottom: BorderSide(color: enabled ? dark : AppTheme.obsidianBlack, width: 3),
          right: BorderSide(color: enabled ? dark : AppTheme.obsidianBlack, width: 3),
        ),
      ),
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (loading)
            SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2.5, color: fg))
          else ...[
            if (icon != null) ...[
              IconTheme(data: IconThemeData(color: enabled ? fg : AppTheme.darkAsh, size: 20), child: icon!),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: display.style(22, color: enabled ? fg : AppTheme.darkAsh),
              ),
            ),
          ],
        ],
      ),
    );

    return Material(
      color: enabled ? bg : AppTheme.forgedSteel,
      shape: const PixelBorder(side: BorderSide.none, step: 2),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: enabled ? onPressed : null, child: child),
    );
  }
}
