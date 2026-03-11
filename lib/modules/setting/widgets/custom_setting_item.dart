import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';

class CustomSettingItem extends StatelessWidget {
  final String title;
  const CustomSettingItem({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 32.h,
      margin: EdgeInsets.only(bottom: 14.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!, width: 1.0),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          Image.asset(
            AppAssets.arrowRight,
            width: 18.w,
            height: 18.h,
            color: AppColors.grey,
          ),
        ],
      ),
    );
  }
}
