import 'package:flutter/material.dart';
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
        height: 53,
        width: double.infinity,
        // color: bg ? AppColors.darkGrey : null,
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            Image.asset(
              AppAssets.arrowBack,
              width: 16,
              height: 16,
              color: bg ? AppColors.white : AppColors.black,
            ),
            const SizedBox(width: 8),
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
