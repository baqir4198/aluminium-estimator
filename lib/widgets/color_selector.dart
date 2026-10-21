import 'package:flutter/material.dart';
import '../models/frame_color.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class ColorSelector extends StatelessWidget {
  const ColorSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final String selected;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 4, 6, 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text.rich(
              TextSpan(
                text: 'Color',
                style: bodyStyle(16, weight: FontWeight.w600),
                children: [
                  TextSpan(
                    text: ' · $selected',
                    style: bodyStyle(16, color: AppColors.muted),
                  ),
                ],
              ),
            ),
          ),
          for (final option in FrameColor.options)
            _Swatch(
              option: option,
              selected: option.name == selected,
              onTap: () => onChanged(option.name),
            ),
        ],
      ),
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final FrameColor option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: option.name,
      child: InkResponse(
        onTap: onTap,
        radius: 24,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 38,
              height: 38,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.accent : Colors.transparent,
                  width: 2.5,
                ),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: option.color,
                  border: Border.all(color: const Color(0xFF8A96A1)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}