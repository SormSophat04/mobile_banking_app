import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_strings.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';

class CustomBranchSearch extends StatelessWidget {
  const CustomBranchSearch({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360.h,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          SizedBox(height: 16.h),
          CustomInputField(
            prefixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Image.asset(AppAssets.search, height: 16.h, width: 16.w),
            ),
            hint: AppStrings.search,
            suffixWidget: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Image.asset(AppAssets.remove, height: 16.h, width: 16.w),
            ),
          ),
          SizedBox(height: 18.h),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: 10,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => _buildBranchLocation(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchLocation() {
    return Container(
      height: 37.h,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(width: 1.5.w, color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            AppAssets.locattion,
            height: 24.h,
            width: 24.w,
            color: AppColors.primary,
          ),
          SizedBox(width: 12.w),
          Text(
            'Branch Location',
            style: AppTextStyles.title3.copyWith(color: AppColors.black),
          ),
          Spacer(),
          Text(
            '530m',
            style: AppTextStyles.body1.copyWith(color: AppColors.darkGrey),
          ),
        ],
      ),
    );
  }
}
