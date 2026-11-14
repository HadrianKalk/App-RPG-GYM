import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

import '../features/character/presentation/character_screen.dart';
import '../features/workout/presentation/workout_screen.dart';
import '../features/activities/presentation/activities_screen.dart';
import '../features/quests/presentation/quests_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/character',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/character',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: CharacterScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/workout',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: WorkoutScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/activities',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: ActivitiesScreen(),
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/quests',
              pageBuilder: (context, state) => const NoTransitionPage(
                child: QuestsScreen(),
              ),
            ),
          ],
        ),
      ],
    ),
  ],
);

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({
    required this.navigationShell,
    super.key,
  });

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
