import 'package:flutter/material.dart';
import 'package:aluminium_estimator/theme/app_colors.dart';
import 'package:aluminium_estimator/theme/app_text.dart';

class CustomerCard extends StatelessWidget {
  const CustomerCard({
    super.key,
    required this.nameController,
    required this.phoneController,
    required this.onPickContact,
  });

  final TextEditingController nameController;
  final TextEditingController phoneController;
  final VoidCallback onPickContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Customer', style: displayStyle(20)),
              TextButton(
                onPressed: onPickContact,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.accentDark,
                  minimumSize: const Size(48, 48),
                ),
                child: Text(
                  'Pick from contacts',
                  style: bodyStyle(
                    14,
                    weight: FontWeight.w600,
                    color: AppColors.accentDark,
                  ),
                ),
              ),
            ],
          ),
          _Field(
            controller: nameController,
            label: 'Name',
            hint: 'Customer name',
            keyboardType: TextInputType.name,
            action: TextInputAction.next,
          ),
          const SizedBox(height: 10),
          _Field(
            controller: phoneController,
            label: 'Phone',
            hint: '03XX XXXXXXX',
            keyboardType: TextInputType.phone,
            action: TextInputAction.done,
          ),
        ],
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    required this.keyboardType,
    required this.action,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final TextInputType keyboardType;
  final TextInputAction action;

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color c, [double w = 1]) => OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: c, width: w),
    );

    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: action,
      style: bodyStyle(16),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF7F9FA),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        enabledBorder: border(const Color(0xFFCDD4DA)),
        focusedBorder: border(AppColors.accent, 2),
      ),
    );
  }
}