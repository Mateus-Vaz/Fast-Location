import 'package:flutter/material.dart';

import '../../modules/home/model/address_model.dart';
import '../metrics/app_metrics.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({
    super.key,
    required this.address,
    this.onTap,
    this.showConsultedAt = false,
  });

  final AddressModel address;
  final VoidCallback? onTap;
  final bool showConsultedAt;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final title = address.street.isEmpty
        ? address.cityAndState
        : address.street;
    final details = [
      if (address.neighborhood.isNotEmpty) address.neighborhood,
      if (address.street.isNotEmpty) address.cityAndState,
    ];

    return Card(
      margin: const EdgeInsets.only(bottom: AppMetrics.spacingSm + 2),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppMetrics.spacingMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: scheme.primary.withValues(alpha: 0.14),
                foregroundColor: scheme.primary,
                child: const Icon(Icons.place_outlined),
              ),
              const SizedBox(width: AppMetrics.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppMetrics.spacingXs),
                    Text(
                      'CEP ${address.cep}',
                      style: textTheme.bodyMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (details.isNotEmpty)
                      Text(
                        details.join(' • '),
                        style: textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    if (showConsultedAt)
                      Padding(
                        padding: const EdgeInsets.only(
                          top: AppMetrics.spacingXs,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.schedule,
                              size: 14,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: AppMetrics.spacingXs),
                            Text(
                              _formatDate(address.consultedAt),
                              style: textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
              if (onTap != null)
                Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.day)}/${twoDigits(date.month)}/${date.year} '
        'às ${twoDigits(date.hour)}:${twoDigits(date.minute)}';
  }
}
