import 'package:flutter/material.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';

/// The Reusable Custom Input Field
class CustomInputField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? text;
  final String? caption;
  final Widget? prefixIcon;
  final Widget? prefixWidget;
  final Widget? suffixIcon;
  final Widget? suffixWidget;
  final Color? textColor;
  final TextInputType? keybaordType;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;

  const CustomInputField({
    super.key,
    this.label,
    this.hint,
    this.text,
    this.caption,
    this.prefixIcon,
    this.prefixWidget,
    this.suffixIcon,
    this.suffixWidget,
    this.textColor,
    this.keybaordType,
    this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const Color captionColor = AppColors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Optional Top Label
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              color: Colors.grey.shade500,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
        ],

        // The TextField
        TextFormField(
          controller: controller,
          initialValue: controller == null ? text : null,
          keyboardType: keybaordType,
          onChanged: onChanged,
          style: AppTextStyles.title3.copyWith(color: AppColors.black),
          decoration: InputDecoration(
            fillColor: Colors.transparent,
            filled: true,
            hintText: hint,
            hintStyle: AppTextStyles.body3.copyWith(
              fontWeight: FontWeight.w600,
            ),
            prefixIcon: prefixWidget ?? prefixIcon,
            suffixIcon: suffixWidget ?? suffixIcon,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.lightGrey,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.lightGrey,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: captionColor, width: 1.5),
            ),
          ),
        ),

        // Optional Bottom Caption
        if (caption != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(caption!, style: AppTextStyles.caption1),
          ),
        ],
      ],
    );
  }
}

/// The Reusable Currency Suffix (for the USD dropdown)
class CurrencySuffix extends StatelessWidget {
  final bool isActive;
  final String currencyCode;

  const CurrencySuffix({
    super.key,
    this.isActive = false,
    this.currencyCode = 'USD',
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VerticalDivider(
            color: Colors.grey.shade300,
            thickness: 1.5,
            indent: 12,
            endIndent: 12,
          ),
          const SizedBox(width: 8),
          Text(
            currencyCode,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isActive ? Colors.black87 : Colors.grey.shade400,
            ),
          ),
          const SizedBox(width: 4),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.keyboard_arrow_up,
                size: 16,
                color: Colors.grey.shade400,
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: Colors.grey.shade400,
              ),
            ],
          ),
          const SizedBox(width: 16),
        ],
      ),
    );
  }
}
