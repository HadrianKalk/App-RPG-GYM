import 'package:material_ui/material_ui.dart';

import '../../../app/theme.dart';
import '../../../app/ui/pixel_frame.dart';
import '../../../app/ui/pixel_icon.dart';
import '../../../l10n/l10n.dart';
import '../domain/credits.dart';

/// Thanks everyone listed in [Credits].
class CreditsScreen extends StatelessWidget {
  const CreditsScreen({super.key});

  String _roleLabel(AppLocalizations l10n, CreditRole role) => switch (role) {
        CreditRole.support => l10n.creditRoleSupport,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final text = Theme.of(context).textTheme;
    final display = DisplayFont.from(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.creditsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(child: PixelIcon(PixelIcons.flame, size: 56, color: AppTheme.emberOrange)),
          const SizedBox(height: 12),
          Text(l10n.creditsIntro, textAlign: TextAlign.center, style: text.bodyMedium),
          const SizedBox(height: 20),
          Text(l10n.creditsPeople, style: text.titleLarge),
          const SizedBox(height: 8),
          for (final person in Credits.people)
            PixelFrame(
              highlight: true,
              margin: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  const PixelIcon(PixelIcons.shield, size: 28, color: AppTheme.emberGold),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.name, style: display.style(26)),
                        Text(_roleLabel(l10n, person.role), style: text.bodyMedium),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
          Text(l10n.creditsFonts, style: text.titleLarge),
          const SizedBox(height: 8),
          PixelFrame(child: Text(l10n.creditsFontsBody, style: text.bodyMedium)),
        ],
      ),
    );
  }
}
