import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/formatters.dart';

/// Sticky bottom bar: caption + amount on the left, one action on the right.
class QuotationBottomBar extends StatelessWidget {
  const QuotationBottomBar({
    super.key,
    required this.total,
    required this.caption,
    required this.actionLabel,
    required this.onAction,
    this.enabled = true,
  });

  final int total;
  final String caption;
  final String actionLabel;
  final VoidCallback onAction;
  final bool enabled;

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
                      caption,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyStyle(13, color: AppColors.muted),
                    ),
                    Text(formatRs(total), style: displayStyle(30)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              FilledButton(
                onPressed: enabled ? onAction : null,
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
                child: Text(actionLabel),
              ),
            ],
          ),
        ),
      ),
    );
  }
}