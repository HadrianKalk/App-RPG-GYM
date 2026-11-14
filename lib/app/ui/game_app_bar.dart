import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../data/repositories/providers.dart';
import '../../l10n/l10n.dart';
import '../theme.dart';
import 'pixel_icon.dart';
import 'pixel_tag.dart';

/// Standard top bar of the main tabs: title, Inspiration counter and the
/// settings button.
class GameAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const GameAppBar({super.key, required this.title, this.showInspiration = true});

  final String title;
  final bool showInspiration;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inspiration = ref.watch(characterStreamProvider).valueOrNull?.inspirationCount;
    return AppBar(
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      actions: [
        if (showInspiration && inspiration != null)
          Tooltip(
            message: context.l10n.inspirationTooltip,
            child: PixelTag(
              text: '$inspiration',
              fontSize: 20,
              leading: const PixelIcon(PixelIcons.star, size: 14, color: AppTheme.emberGold),
            ),
          ),
        IconButton(
          tooltip: context.l10n.commonSettings,
          icon: const PixelIcon(PixelIcons.gear, size: 22, color: AppTheme.dullSilver),
          onPressed: () => context.push('/settings'),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
