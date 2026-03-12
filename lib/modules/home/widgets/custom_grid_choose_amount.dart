import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';

class CustomGridChooseAmount extends StatelessWidget {
  const CustomGridChooseAmount({
    super.key,
    required this.amounts,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<String> amounts;
  final int? selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: amounts.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.0,
        mainAxisSpacing: 14.0,
        childAspectRatio: 1.5,
      ),
      itemBuilder: (context, index) => _buildGridItem(
        amounts[index],
        isSelected: selectedIndex == index,
        onTap: () => onSelect(index),
      ),
    );
  }

  Widget _buildGridItem(
    String text, {
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final Color backgroundColor = isSelected
        ? AppColors.primary
        : AppColors.white;
    final Color textColor = isSelected ? AppColors.white : AppColors.grey;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(15.r),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(15.r),
            boxShadow: AppShadows.card,
          ),
          child: Center(
            child: Text(
              text,
              style: AppTextStyles.title2.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
