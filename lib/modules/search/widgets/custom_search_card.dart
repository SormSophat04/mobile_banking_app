import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';

class CustomSearchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  const CustomSearchCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110.h,
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.title3.copyWith(color: AppColors.black),
                ),
                Text(
                  subtitle,
                  style: AppTextStyles.body2.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
          Container(
            height: 100.h,
            width: 100.w,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage(image)),
            ),
          ),
        ],
      ),
    );
  }
}
