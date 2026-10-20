import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/formatters.dart';

class PendingPaymentsCard extends StatelessWidget {
  const PendingPaymentsCard({
    required this.amount,
    required this.jobCount,
    required this.onViewAll,
  });

  final int amount;
  final int jobCount;
  final VoidCallback onViewAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 18, 12, 10),
      decoration: BoxDecoration(
        color: AppColors.graphite,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pending payments',
            style: bodyStyle(14, color: AppColors.onGraphiteMuted)
                .copyWith(letterSpacing: 0.4),
          ),
          const SizedBox(height: 2),
          Text(
            formatRs(amount),
            style: displayStyle(44, color: Colors.white),
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  'From $jobCount jobs',
                  style: bodyStyle(14, color: AppColors.onGraphiteSoft),
                ),
              ),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.onGraphiteAction,
                  minimumSize: const Size(48, 48),
                ),
                child: Text(
                  'View all',
                  style: bodyStyle(
                    14,
                    weight: FontWeight.w600,
                    color: AppColors.onGraphiteAction,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

