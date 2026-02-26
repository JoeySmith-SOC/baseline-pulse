import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:baseline_pulse/features/home/screens/home_screen.dart';
import 'package:baseline_pulse/features/recovery/screens/recovery_screen.dart';
import 'package:baseline_pulse/features/ruck/screens/ruck_active_screen.dart';
import 'package:baseline_pulse/features/ruck/screens/ruck_history_screen.dart';
import 'package:baseline_pulse/features/ruck/screens/ruck_setup_screen.dart';
import 'package:baseline_pulse/features/ruck/screens/ruck_summary_screen.dart';
import 'package:baseline_pulse/features/run/screens/run_active_screen.dart';
import 'package:baseline_pulse/features/run/screens/run_history_screen.dart';
import 'package:baseline_pulse/features/run/screens/run_setup_screen.dart';
import 'package:baseline_pulse/features/run/screens/run_summary_screen.dart';
import 'package:baseline_pulse/features/subscription/screens/paywall_screen.dart';
import 'package:baseline_pulse/features/workouts/screens/workouts_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

GoRouter buildRouter(BootstrapContainer container) {
  return GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return HomeScreen(container: container);
        },
      ),
      GoRoute(
        path: '/run/setup',
        builder: (BuildContext context, GoRouterState state) {
          return RunSetupScreen(container: container);
        },
      ),
      GoRoute(
        path: '/run/active',
        builder: (BuildContext context, GoRouterState state) {
          final RunActiveArgs args = state.extra! as RunActiveArgs;
          return RunActiveScreen(container: container, args: args);
        },
      ),
      GoRoute(
        path: '/run/summary',
        builder: (BuildContext context, GoRouterState state) {
          final RunSummaryArgs args = state.extra! as RunSummaryArgs;
          return RunSummaryScreen(args: args);
        },
      ),
      GoRoute(
        path: '/run/history',
        builder: (BuildContext context, GoRouterState state) {
          return RunHistoryScreen(container: container);
        },
      ),
      GoRoute(
        path: '/ruck/setup',
        builder: (BuildContext context, GoRouterState state) {
          return RuckSetupScreen(container: container);
        },
      ),
      GoRoute(
        path: '/ruck/active',
        builder: (BuildContext context, GoRouterState state) {
          final RuckActiveArgs args = state.extra! as RuckActiveArgs;
          return RuckActiveScreen(container: container, args: args);
        },
      ),
      GoRoute(
        path: '/ruck/summary',
        builder: (BuildContext context, GoRouterState state) {
          final RuckSummaryArgs args = state.extra! as RuckSummaryArgs;
          return RuckSummaryScreen(args: args);
        },
      ),
      GoRoute(
        path: '/ruck/history',
        builder: (BuildContext context, GoRouterState state) {
          return RuckHistoryScreen(container: container);
        },
      ),
      GoRoute(
        path: '/workouts',
        builder: (BuildContext context, GoRouterState state) {
          return const WorkoutsScreen();
        },
      ),
      GoRoute(
        path: '/recovery',
        builder: (BuildContext context, GoRouterState state) {
          return RecoveryScreen(container: container);
        },
      ),
      GoRoute(
        path: '/paywall',
        builder: (BuildContext context, GoRouterState state) {
          return const PaywallScreen();
        },
      ),
    ],
    errorBuilder: (BuildContext context, GoRouterState state) {
      return Scaffold(
        appBar: AppBar(title: const Text('Route Error')),
        body: Center(child: Text(state.error.toString())),
      );
    },
  );
}
