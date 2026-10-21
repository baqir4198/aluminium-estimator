import 'package:flutter/material.dart';
import '../models/opening.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';
import '../utils/formatters.dart';

class OpeningTile extends StatelessWidget {
  const OpeningTile({super.key, required this.opening, required this.onTap});

  final Opening opening;
  final VoidCallback onTap;

  IconData get _icon => switch (opening.type) {
    OpeningType.slidingWindow => Icons.window_outlined,
    OpeningType.fixedGlass => Icons.crop_portrait_rounded,
    OpeningType.door => Icons.door_front_door_outlined,
  };

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.iconTile,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_icon, color: AppColors.iconTileFg, size: 28),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      opening.type.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyStyle(16, weight: FontWeight.w600),
                    ),
                    Text(
                      '${opening.sizesSummary} · ${opening.color}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyStyle(14, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                formatRs(opening.price),
                style: bodyStyle(16, weight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}