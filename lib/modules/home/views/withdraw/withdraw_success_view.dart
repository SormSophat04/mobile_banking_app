import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_strings.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';

class WithdrawSuccessView extends StatelessWidget {
  const WithdrawSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: _buildBody());
  }

  Widget _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              children: [
                Image.asset(AppAssets.imageIll4),
                SizedBox(height: 32.h),
                _buildText(),
                SizedBox(height: 50.h),
                CustomButtonPrimaryActive(
                  label: AppStrings.confirm,
                  onTap: () => Get.offAndToNamed(AppRoutes.MAIN_LAYOUT),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildText() {
    return Column(
      children: [
        Text(
          AppStrings.withDrawSuccess,
          style: AppTextStyles.title1.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 24.h),
        Text(
          AppStrings.msgWithDrawSuccess,
          style: AppTextStyles.body3.copyWith(color: AppColors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
