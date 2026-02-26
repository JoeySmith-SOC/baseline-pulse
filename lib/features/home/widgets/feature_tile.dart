import 'package:baseline_pulse/app/theme/bp_colors.dart';
import 'package:baseline_pulse/app/theme/bp_text.dart';
import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  const FeatureTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: <Widget>[
              Icon(icon, color: BpColors.red, size: 30),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(title, style: BpText.section),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: BpColors.muted)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: BpColors.muted),
            ],
          ),
        ),
      ),
    );
  }
}
