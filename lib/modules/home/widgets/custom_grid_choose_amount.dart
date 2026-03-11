import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/withdraw_controller.dart';

class CustomGridChooseAmount extends StatelessWidget {
  const CustomGridChooseAmount({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawController>(
      builder: (controller) => GridView.builder(
        itemCount: controller.amounts.length,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 14.0,
          childAspectRatio: 1.5,
        ),
        itemBuilder: (context, index) => _buildGridItem(
          controller.amounts[index],
          isSelected: controller.selectedIndex == index,
          onTap: () => controller.selectAmount(index),
        ),
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
