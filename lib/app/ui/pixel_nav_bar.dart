import 'package:material_ui/material_ui.dart';

import '../theme.dart';
import 'pixel_icon.dart';

/// One destination of [PixelNavBar].
class PixelNavItem {
  const PixelNavItem({required this.icon, required this.label});

  final List<String> icon;
  final String label;
}

/// Bottom navigation with pixel icons; the active tab gets a gold top bar.
class PixelNavBar extends StatelessWidget {
  const PixelNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<PixelNavItem> items;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final display = DisplayFont.from(context);
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.castIron,
        border: Border(top: BorderSide(color: AppTheme.forgedSteel, width: 3)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            children: [
              for (var i = 0; i < items.length; i++)
                Expanded(
                  child: Semantics(
                    selected: i == selectedIndex,
                    button: true,
                    label: items[i].label,
                    child: InkWell(
                      onTap: () => onSelected(i),
                      child: Container(
                        decoration: BoxDecoration(
                          color: i == selectedIndex ? AppTheme.obsidianBlack : null,
                          border: Border(
                            top: BorderSide(
                              color: i == selectedIndex ? AppTheme.emberGold : Colors.transparent,
                              width: 3,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PixelIcon(
                              items[i].icon,
                              size: 22,
                              color: i == selectedIndex ? AppTheme.emberGold : AppTheme.darkAsh,
                            ),
                            const SizedBox(height: 3),
                            ExcludeSemantics(
                              child: Text(
                                items[i].label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: display.style(
                                  15,
                                  color: i == selectedIndex ? AppTheme.emberGold : AppTheme.darkAsh,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
