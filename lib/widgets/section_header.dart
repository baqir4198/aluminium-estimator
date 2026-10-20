import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.actionLabel,
    required this.onAction,
  });

  final String title;
  final String actionLabel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: displayStyle(22)),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.accentDark,
            minimumSize: const Size(48, 48),
          ),
          child: Text(
            actionLabel,
            style: bodyStyle(
              14,
              weight: FontWeight.w600,
              color: AppColors.accentDark,
            ),
          ),
        ),
      ],
    );
  }
}