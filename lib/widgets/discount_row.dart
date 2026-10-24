import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import 'rate_field_row.dart';

/// "Discount on aluminium" with a % box (Add opening screen).
class DiscountRow extends StatelessWidget {
  const DiscountRow({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 10, 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discount on aluminium',
                  style: bodyStyle(16, weight: FontWeight.w600),
                ),
                Text(
                  'Not applied to glass, labour, hardware, rent',
                  style: bodyStyle(12, color: AppColors.muted),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Semantics(
            label: 'Discount percent',
            child: PriceBox(
              controller: controller,
              prefix: '',
              suffix: '%',
              width: 88,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}