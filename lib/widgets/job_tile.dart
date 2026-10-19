import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/job.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class JobTile extends StatelessWidget {
  const JobTile({required this.job, required this.onTap});

  final Job job;
  final VoidCallback onTap;

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
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.iconTile,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.window_outlined,
                  color: AppColors.iconTileFg,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job.customer,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyStyle(16, weight: FontWeight.w600),
                    ),
                    Text(
                      job.summary,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodyStyle(14, color: AppColors.muted),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    formatRs(job.amount),
                    style: bodyStyle(16, weight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  _StatusChip(status: job.status),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final JobStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: status.background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.label,
        style: bodyStyle(12, weight: FontWeight.w600, color: status.foreground),
      ),
    );
  }
}
