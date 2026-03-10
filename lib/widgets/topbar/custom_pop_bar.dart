import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';

class CustomPopBar extends StatelessWidget {
  final bool bg;
  final String text;
  const CustomPopBar({super.key, this.bg = false, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.back(),
      child: Container(
        height: 58,
        width: double.infinity,
        // color: bg ? AppColors.darkGrey : null,
        // color: Colors.lightBlueAccent,
        padding: EdgeInsets.only(left: 22.dg, top: 12.dg),
        child: Row(
          children: [
            Image.asset(
              AppAssets.arrowBack,
              width: 18,
              height: 18,
              color: bg ? AppColors.white : AppColors.black,
            ),
            SizedBox(width: 18.w),
            Text(
              text,
              style: bg
                  ? AppTextStyles.title2
                  : AppTextStyles.title2.copyWith(color: AppColors.black),
            ),
          ],
        ),
      ),
    );
  }
}
