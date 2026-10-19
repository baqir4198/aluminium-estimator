import 'package:flutter/cupertino.dart';

import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class StatTile extends StatelessWidget {
  const StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: displayStyle(32)),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: bodyStyle(14, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}
