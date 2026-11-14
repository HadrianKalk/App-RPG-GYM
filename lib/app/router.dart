import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/game/hero_profile.dart';
import '../data/repositories/providers.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import 'theme.dart';

import '../features/character/presentation/character_screen.dart';
import '../features/workout/presentation/workout_screen.dart';
import '../features/activities/presentation/activities_screen.dart';
import '../features/quests/presentation/quests_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

/// Roteador do app. Enquanto não houver herói criado, toda navegação é
/// redirecionada para `/onboarding`; depois, `/onboarding` leva ao herói.
final routerProvider = Provider<GoRouter>((ref) {
  final heroState = ValueNotifier<AsyncValue<HeroProfile?>>(
    const AsyncLoading(),
  );
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
    routes: _routes,
  );
});

final List<RouteBase> _routes = [
  GoRoute(
    path: '/splash',
    builder: (context, state) => const Scaffold(
      body: Center(child: CircularProgressIndicator(color: AppTheme.emberGold)),
    ),
  ),
  GoRoute(
    path: '/onboarding',
    builder: (context, state) => const OnboardingScreen(),
  ),
  StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return ScaffoldWithNavBar(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/character',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: CharacterScreen()),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/workout',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: WorkoutScreen()),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/activities',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ActivitiesScreen()),
          ),
        ],
      ),
      StatefulShellBranch(
        routes: [
          GoRoute(
            path: '/quests',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: QuestsScreen()),
          ),
        ],
      ),
    ],
  ),
];

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.shield_outlined),
            selectedIcon: Icon(Icons.shield),
            label: 'Herói',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: 'Treino',
          ),
          NavigationDestination(
            icon: Icon(Icons.timer_outlined),
            selectedIcon: Icon(Icons.timer),
            label: 'Atividades',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories),
            label: 'Missões',
          ),
        ],
      ),
    );
  }
}
