import 'package:flutter/material.dart';

import '../../../shared/metrics/app_metrics.dart';
import '../model/address_model.dart';

class LastAddress extends StatelessWidget {
  const LastAddress({super.key, required this.address});

  final AddressModel address;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppMetrics.radiusLg),
        side: BorderSide(color: scheme.primary, width: 1.5),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppMetrics.spacingLg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppMetrics.spacingSm + 2,
                vertical: AppMetrics.spacingXs + 1,
              ),
              decoration: BoxDecoration(
                color: scheme.primary.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(AppMetrics.radiusXl),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, size: 16, color: scheme.primary),
                  const SizedBox(width: AppMetrics.spacingXs),
                  Text(
                    'Último endereço consultado',
                    style: textTheme.labelMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppMetrics.spacingMd),
            Text(
              address.cep,
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            if (address.street.isNotEmpty)
              Text(address.street, style: textTheme.titleMedium),
            const SizedBox(height: AppMetrics.spacingMd),
            Divider(color: scheme.outlineVariant, height: 1),
            const SizedBox(height: AppMetrics.spacingMd),
            _InfoRow(label: 'Complemento', value: address.complement),
            _InfoRow(label: 'Bairro', value: address.neighborhood),
            _InfoRow(label: 'Cidade', value: address.cityAndState),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    if (value.trim().isEmpty) {
      return const SizedBox.shrink();
    }
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppMetrics.spacingSm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 104,
            child: Text(
              label,
              style: TextStyle(color: scheme.onSurfaceVariant),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
