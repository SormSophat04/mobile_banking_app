import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_strings.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/auth/controller/login_controlller.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.primaryLight,
        body: Column(
          children: [
            SizedBox(height: 40),
            CustomPopBar(bg: true, text: 'Sign In'),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  color: AppColors.white,
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: SizedBox(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        _buildWelcomeTextAndImage(),
                        SizedBox(height: 32.h),
                        _buildForm(controller),
                        SizedBox(height: 32.h),
                        _buildButton(controller),
                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeTextAndImage() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.welcome,
          style: AppTextStyles.title1.copyWith(color: AppColors.primary),
        ),
        Text(
          'Hello there, sign in to continue',
          style: AppTextStyles.caption2.copyWith(color: AppColors.black),
        ),
        SizedBox(height: 32),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Image.asset(AppAssets.signUpIcon2, height: 165.h),
          ),
        ),
      ],
    );
  }

  Widget _buildButton(LoginController controller) {
    return Column(
      children: [
        controller.isFormValid
            ? CustomButtonPrimaryActive(label: 'Sign In', onTap: () {})
            : CustomButtonPrimaryDissable(label: 'Sign In'),
        SizedBox(height: 20.h),
        Image.asset(AppAssets.fingerprinteIcon, height: 65.h, width: 65.w),
        SizedBox(height: 14.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Don’t have an account?', style: AppTextStyles.caption2),
            SizedBox(width: 10.w),
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.SIGN_UP),
              child: Text(
                'Sign Up',
                style: AppTextStyles.title3.copyWith(color: AppColors.primary),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildForm(LoginController controller) {
    return Column(
      children: [
        CustomInputField(
          hint: 'Phone number',
          controller: controller.phoneController,
        ),
        SizedBox(height: 20.h),
        CustomInputField(
          hint: 'Password',
          controller: controller.passwordController,
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => Get.toNamed(AppRoutes.FORGOT_PASSWORD),
              child: Text(
                'Forgot password?',
                style: AppTextStyles.caption2.copyWith(color: AppColors.grey),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
