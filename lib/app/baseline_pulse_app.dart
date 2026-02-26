import 'package:baseline_pulse/app/router.dart';
import 'package:baseline_pulse/app/theme/bp_theme.dart';
import 'package:baseline_pulse/core/bootstrap/app_bootstrap.dart';
import 'package:flutter/material.dart';

class BaselinePulseApp extends StatelessWidget {
  const BaselinePulseApp({super.key, required this.container});

  final BootstrapContainer container;

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'BASELINE PULSE',
      theme: BpTheme.build(),
      routerConfig: buildRouter(container),
    );
  }
}
