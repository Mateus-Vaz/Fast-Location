import 'package:flutter/material.dart';

import '../colors/app_colors.dart';
import '../metrics/app_metrics.dart';

/// Cabeçalho com degradê usado no topo da Home.
class GradientHeader extends StatelessWidget {
  const GradientHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  final String title;
  final String subtitle;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final brightness = Theme.of(context).brightness;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppColors.headerGradient(brightness),
        ),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(AppMetrics.radiusXl),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppMetrics.spacingLg,
            AppMetrics.spacingSm,
            AppMetrics.spacingSm,
            AppMetrics.spacingLg + AppMetrics.spacingSm,
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppMetrics.spacingSm + 2),
                decoration: BoxDecoration(
                  color: AppColors.onPrimary.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(AppMetrics.radius),
                ),
                child: const Icon(
                  Icons.location_on,
                  color: AppColors.onPrimary,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppMetrics.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleLarge?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: AppColors.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                  ],
                ),
              ),
              IconButtonTheme(
                data: IconButtonThemeData(
                  style: IconButton.styleFrom(
                    foregroundColor: AppColors.onPrimary,
                  ),
                ),
                child: Row(children: actions),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
