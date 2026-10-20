import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Good morning', style: bodyStyle(14, color: AppColors.muted)),
              Text('Workshop overview', style: displayStyle(30)),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Search jobs and contacts',
          onPressed: () {},
          icon: const Icon(Icons.search_rounded),
          style: IconButton.styleFrom(
            fixedSize: const Size(48, 48),
            backgroundColor: Colors.white,
            foregroundColor: AppColors.ink,
            side: const BorderSide(color: Color(0xFFCDD4DA)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}