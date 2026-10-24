import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text.dart';

/// Name on the left, editable number box on the right.
class RateFieldRow extends StatelessWidget {
  const RateFieldRow({
    super.key,
    required this.label,
    required this.controller,
    required this.suffix,
    required this.onChanged,
    this.prefix = 'Rs',
    this.onDelete,
  });

  final String label;
  final TextEditingController controller;
  final String suffix;
  final VoidCallback onChanged;

  /// Text before the number. Use '' for a percentage.
  final String prefix;

  /// When not null, a delete button is shown (used for custom profiles).
  final VoidCallback? onDelete;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: displayStyle(24),
            ),
          ),
          if (onDelete != null)
            IconButton(
              tooltip: 'Delete $label',
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline_rounded),
              color: AppColors.muted,
            ),
          const SizedBox(width: 12),
          Semantics(
            label: '$label value',
            child: PriceBox(
              controller: controller,
              prefix: prefix,
              suffix: suffix,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

/// Number box with a prefix (Rs) and a suffix (/ ft, %, ...).
class PriceBox extends StatefulWidget {
  const PriceBox({
    super.key,
    required this.controller,
    required this.suffix,
    required this.onChanged,
    this.prefix = 'Rs',
    this.width = 150,
  });

  final TextEditingController controller;
  final String prefix;
  final String suffix;
  final VoidCallback onChanged;
  final double width;

  @override
  State<PriceBox> createState() => _PriceBoxState();
}

class _PriceBoxState extends State<PriceBox> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final focused = _focus.hasFocus;
    return GestureDetector(
      onTap: _focus.requestFocus,
      child: Container(
        width: widget.width,
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: focused ? 9 : 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF7F9FA),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: focused ? AppColors.accent : const Color(0xFFCDD4DA),
            width: focused ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            if (widget.prefix.isNotEmpty)
              Text(widget.prefix, style: bodyStyle(14, color: AppColors.muted)),
            Expanded(
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                textAlign: TextAlign.end,
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
                ],
                onChanged: (_) => widget.onChanged(),
                style: bodyStyle(17, weight: FontWeight.w600),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  hintText: '0',
                  contentPadding: EdgeInsets.symmetric(horizontal: 6),
                ),
              ),
            ),
            Text(widget.suffix, style: bodyStyle(13, color: AppColors.muted)),
          ],
        ),
      ),
    );
  }
}