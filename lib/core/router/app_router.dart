import 'package:go_router/go_router.dart';
import 'package:skill_arena/features/academy_core/presentation/screens/academy_core_screen.dart';
import 'package:skill_arena/features/auth/presentation/screens/auth_screen.dart';
import 'package:skill_arena/features/battle_grid/presentation/screens/battle_grid_screen.dart';
import 'package:skill_arena/features/coding_arena/presentation/screens/live_coding_arena_screen.dart';
import 'package:skill_arena/features/economy/presentation/screens/vault_marketplace_screen.dart';
import 'package:skill_arena/features/identity_hub/presentation/screens/identity_hub_screen.dart';
import 'package:skill_arena/features/navigation/presentation/screens/main_navigation_shell.dart';
import 'package:skill_arena/features/nexus/presentation/screens/nexus_screen.dart';
import 'package:skill_arena/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:skill_arena/features/recruiter/presentation/screens/recruiter_portal_screen.dart';
import 'package:skill_arena/features/showcase/presentation/screens/design_showcase_screen.dart';

/// Top-level GoRouter instance.
final GoRouter appRouter = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) => const AuthScreen(),
    ),
    GoRoute(
      path: '/showcase',
      builder: (context, state) => const DesignShowcaseScreen(),
    ),
    GoRoute(
      path: '/vault',
      builder: (context, state) => const VaultMarketplaceScreen(),
    ),
    GoRoute(
      path: '/recruiter',
      builder: (context, state) => const RecruiterPortalScreen(),
    ),
    GoRoute(
      path: '/coding-arena',
      builder: (context, state) => const LiveCodingArenaScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/nexus',
              builder: (context, state) => const NexusScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/battle-grid',
              builder: (context, state) => const BattleGridScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/academy',
              builder: (context, state) => const AcademyCoreScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/identity',
              builder: (context, state) => const IdentityHubScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
