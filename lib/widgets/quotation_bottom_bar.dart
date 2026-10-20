import 'package:flutter/material.dart';
import 'package:aluminium_estimator/theme/app_colors.dart';
import 'package:aluminium_estimator/theme/app_text.dart';
import 'package:aluminium_estimator/utils/formatters.dart';

class QuotationBottomBar extends StatelessWidget {
  const QuotationBottomBar({
    super.key,
    required this.total,
    required this.pieces,
    required this.onPreview,
  });

  final int total;
  final int pieces;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total · $pieces ${pieces == 1 ? 'piece' : 'pieces'}',
                      style: bodyStyle(13, color: AppColors.muted),
                    ),
                    Text(formatRs(total), style: displayStyle(30)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: pieces == 0 ? null : onPreview,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 52),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: bodyStyle(16, weight: FontWeight.w600),
                ),
                child: const Text('Preview PDF'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}