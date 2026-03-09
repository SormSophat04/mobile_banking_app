import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_strings.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class VerifyCodeView extends StatelessWidget {
  const VerifyCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Column(
        children: [
          SizedBox(height: 40.h),
          CustomPopBar(text: 'Forgot Password'),
          SizedBox(height: 10.h),
          _buildCard(),
          SizedBox(height: 40.h),
          _buildChangeNumber(),
        ],
      ),
    );
  }

  Widget _buildChangeNumber() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Text(AppStrings.changeNumber)],
    );
  }

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.dg),
      margin: EdgeInsets.symmetric(horizontal: 16.dg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: AppColors.white,
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.typeCode,
            style: AppTextStyles.caption1.copyWith(color: AppColors.grey),
          ),
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: CustomInputField(
                  hint: 'Code',
                  keybaordType: TextInputType.number,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(child: CustomButtonPrimaryActive(label: 'Resend')),
            ],
          ),
          SizedBox(height: 20.h),
          Text(
            'We texted you a code to verify your phone number',
            style: AppTextStyles.caption2.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 20.h),
          Text(
            "This code will expired 10 minutes after this message. If you don't get a message.",
            style: AppTextStyles.caption2.copyWith(color: AppColors.black),
          ),
          SizedBox(height: 20.h),
          CustomButtonPrimaryDissable(
            label: 'Change password',
            onTap: () => Get.toNamed(AppRoutes.RESET_PASSWORD),
          ),
        ],
      ),
    );
  }
}
