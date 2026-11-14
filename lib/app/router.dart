import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/game/hero_profile.dart';
import '../data/repositories/providers.dart';
import '../features/activities/presentation/activities_screen.dart';
import '../features/character/presentation/character_screen.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/quests/presentation/quests_screen.dart';
import '../features/settings/presentation/credits_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/workout/presentation/workout_screen.dart';
import '../l10n/l10n.dart';
import 'ui/pixel_icon.dart';
import 'ui/pixel_nav_bar.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

/// App router. Until a hero exists every location redirects to
/// `/onboarding`; afterwards `/onboarding` leads to the hero screen.
final routerProvider = Provider<GoRouter>((ref) {
  // Bridge the hero stream into a Listenable so GoRouter re-runs redirects.
  final heroState = ValueNotifier<AsyncValue<HeroProfile?>>(const AsyncLoading());
  ref.listen<AsyncValue<HeroProfile?>>(
    heroStreamProvider,
    (_, next) => heroState.value = next,
    fireImmediately: true,
  );
  ref.onDispose(heroState.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/character',
    refreshListenable: heroState,
    redirect: (context, state) {
      final loc = state.matchedLocation;
      final hero = heroState.value;
      if (hero.isLoading && !hero.hasValue) {
        return loc == '/splash' ? null : '/splash';
      }
      final hasHero = hero.valueOrNull != null;
      if (!hasHero) return loc == '/onboarding' ? null : '/onboarding';
      if (loc == '/onboarding' || loc == '/splash') return '/character';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
        routes: [
          GoRoute(path: 'credits', builder: (context, state) => const CreditsScreen()),
        ],
      ),
      // Main tabs keep their own navigation stacks.
      StatefulShellRoute.indexedStack(
        builder: (context, state, shell) => ScaffoldWithNavBar(navigationShell: shell),
        branches: [
          _tab('/character', const CharacterScreen()),
          _tab('/workout', const WorkoutScreen()),
          _tab('/activities', const ActivitiesScreen()),
          _tab('/quests', const QuestsScreen()),
        ],
      ),
    ],
  );
});

StatefulShellBranch _tab(String path, Widget screen) => StatefulShellBranch(
      routes: [GoRoute(path: path, pageBuilder: (context, state) => NoTransitionPage(child: screen))],
    );

/// Shell scaffold with the pixel bottom navigation.
class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: PixelNavBar(
        selectedIndex: navigationShell.currentIndex,
        onSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: [
          PixelNavItem(icon: PixelIcons.shield, label: l10n.navHero),
          PixelNavItem(icon: PixelIcons.dumbbell, label: l10n.navWorkout),
          PixelNavItem(icon: PixelIcons.hourglass, label: l10n.navActivities),
          PixelNavItem(icon: PixelIcons.scroll, label: l10n.navQuests),
        ],
      ),
    );
  }
}
