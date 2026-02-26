import 'package:baseline_pulse/src/features/home/presentation/home_shell.dart';
import 'package:baseline_pulse/src/features/ruck/presentation/ruck_placeholder_screen.dart';
import 'package:baseline_pulse/src/features/run/presentation/run_placeholder_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter createAppRouter() {
  return GoRouter(
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeShell(),
      ),
      GoRoute(
        path: '/run',
        builder: (context, state) => const RunPlaceholderScreen(),
      ),
      GoRoute(
        path: '/ruck',
        builder: (context, state) => const RuckPlaceholderScreen(),
      ),
    ],
  );
}

final GoRouter appRouter = createAppRouter();
