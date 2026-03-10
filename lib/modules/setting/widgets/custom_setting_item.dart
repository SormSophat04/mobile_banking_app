import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';

class CustomSettingItem extends StatelessWidget {
  const CustomSettingItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36.h,
      margin: EdgeInsets.only(bottom: 10.h),
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
            "Infomation",
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
          ),
          Image.asset(AppAssets.arrowRight, width: 18.w, height: 18.h),
        ],
      ),
    );
  }
}
