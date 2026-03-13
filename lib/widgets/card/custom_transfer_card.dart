import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';

class CustomTransferCard extends StatelessWidget {
  final String title;
  final String icon;
  const CustomTransferCard({
    super.key,
    this.isSelected = false,
    required this.title,
    required this.icon,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = isSelected
        ? AppColors.primary
        : AppColors.backgroundGrey;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      height: 100.h,
      width: 130.w,
      padding: EdgeInsets.all(16.dg),
      margin: EdgeInsets.symmetric(horizontal: 8.dg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        color: backgroundColor,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(icon, height: 28.h, width: 28.w, color: AppColors.white),
          Text(
            title,
            style: AppTextStyles.caption2.copyWith(
              color: AppColors.white,
              height: 1.h,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
