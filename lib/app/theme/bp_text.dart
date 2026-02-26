import 'package:baseline_pulse/app/theme/bp_colors.dart';
import 'package:flutter/material.dart';

abstract final class BpText {
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: BpColors.white,
    letterSpacing: -0.2,
  );

  static const TextStyle section = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: BpColors.white,
  );

  static const TextStyle body = TextStyle(
    fontSize: 14,
    color: BpColors.white,
  );

  static const TextStyle value = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    color: BpColors.white,
  );
}
