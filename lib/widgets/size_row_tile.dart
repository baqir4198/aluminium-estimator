import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

class SizeRowTile extends StatelessWidget {
  const SizeRowTile({
    super.key,
    required this.widthController,
    required this.heightController,
    required this.quantity,
    required this.selected,
    required this.onSelect,
    required this.onChanged,
    required this.onQuantityChanged,
    this.onRemove,
  });

  final TextEditingController widthController;
  final TextEditingController heightController;
  final int quantity;
  final bool selected;
  final VoidCallback onSelect;
  final VoidCallback onChanged;
  final ValueChanged<int> onQuantityChanged;

  /// Null hides the delete action (used when only one size is left).
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: EdgeInsets.all(selected ? 9 : 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            _DimField(
              controller: widthController,
              label: 'Width in feet',
              onTap: onSelect,
              onChanged: onChanged,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text('×', style: bodyStyle(16, color: AppColors.muted)),
            ),
            _DimField(
              controller: heightController,
              label: 'Height in feet',
              onTap: onSelect,
              onChanged: onChanged,
            ),
            const SizedBox(width: 6),
            Text('ft', style: bodyStyle(13, color: AppColors.muted)),
            const Spacer(),
            _SquareButton(
              icon: Icons.remove_rounded,
              tooltip: 'Decrease quantity',
              onPressed:
              quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
            ),
            SizedBox(
              width: 26,
              child: Text(
                '$quantity',
                textAlign: TextAlign.center,
                style: displayStyle(24),
              ),
            ),
            _SquareButton(
              icon: Icons.add_rounded,
              tooltip: 'Increase quantity',
              onPressed: () => onQuantityChanged(quantity + 1),
            ),
            SizedBox(
              width: 36,
              height: 36,
              child: onRemove == null
                  ? null
                  : IconButton(
                tooltip: 'Remove size',
                padding: EdgeInsets.zero,
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline_rounded, size: 20),
                color: AppColors.muted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DimField extends StatelessWidget {
  const _DimField({
    required this.controller,
    required this.label,
    required this.onTap,
    required this.onChanged,
  });

  final TextEditingController controller;
  final String label;
  final VoidCallback onTap;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: c, width: w),
    );

    return SizedBox(
      width: 52,
      height: 40,
      child: Semantics(
        label: label,
        child: TextField(
          controller: controller,
          onTap: onTap,
          onChanged: (_) => onChanged(),
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
          style: bodyStyle(17, weight: FontWeight.w600),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: const Color(0xFFF7F9FA),
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            enabledBorder: border(const Color(0xFFCDD4DA)),
            focusedBorder: border(AppColors.accent, 2),
          ),
        ),
      ),
    );
  }
}

class _SquareButton extends StatelessWidget {
  const _SquareButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: 36,
      child: IconButton(
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        style: IconButton.styleFrom(
          backgroundColor: const Color(0xFFF7F9FA),
          foregroundColor: AppColors.ink,
          side: const BorderSide(color: Color(0xFFCDD4DA)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}