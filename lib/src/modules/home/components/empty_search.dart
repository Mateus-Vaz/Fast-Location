import 'package:flutter/material.dart';

import '../../../shared/metrics/app_metrics.dart';

class EmptySearch extends StatelessWidget {
  const EmptySearch({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.search_off_rounded,
  });

  final String title;
  final String message;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppMetrics.spacingXl),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppMetrics.spacingLg),
            decoration: BoxDecoration(
              color: scheme.surfaceContainerHighest,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: AppMetrics.iconLg / 1.5,
              color: scheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppMetrics.spacingMd),
          Text(
            title,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppMetrics.spacingXs),
          Text(
            message,
            textAlign: TextAlign.center,
            style: textTheme.bodyMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
