import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_strings.dart';
import 'package:mobile_banking_app/modules/auth/controller/reset_password_controller.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class ResetPasswordView extends StatelessWidget {
  const ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ResetPasswordController>(
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          children: [
            SizedBox(height: 40.h),
            CustomPopBar(text: AppStrings.changePassword),
            SizedBox(height: 10.h),
            _buildCard(controller),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(ResetPasswordController controller) {
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
          CustomInputField(
            hint: '************',
            label: AppStrings.typeNewPassword,
            keybaordType: TextInputType.phone,
            controller: controller.newPasswordController,
          ),
          SizedBox(height: 20.h),
          CustomInputField(
            hint: '************',
            label: AppStrings.confirmPassword,
            keybaordType: TextInputType.phone,
            controller: controller.confirmPasswordController,
          ),
          SizedBox(height: 50.h),
          controller.isFormValid
              ? CustomButtonPrimaryActive(
                  label: AppStrings.changePassword,
                  onTap: () => Get.toNamed(AppRoutes.RESET_SUCCESS),
                )
              : CustomButtonPrimaryDissable(
                  label: AppStrings.changePassword,
                ),
        ],
      ),
    );
  }
}
