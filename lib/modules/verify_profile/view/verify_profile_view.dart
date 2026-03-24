import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/verify_profile/controller/verify_profile_controller.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class VerifyProfileView extends StatelessWidget {
  const VerifyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<VerifyProfileController>(
      init: VerifyProfileController(),
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.primaryLight,
        body: Column(
          children: [
            SizedBox(height: 40),
            CustomPopBar(bg: true, text: 'Verify Profile'),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(left: 24.w, right: 24.w),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(28),
                    topRight: Radius.circular(28),
                  ),
                  color: AppColors.white,
                ),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 32.h),
                      Text(
                        'Confirm Details',
                        style: AppTextStyles.title1.copyWith(color: AppColors.primary),
                      ),
                      Text(
                        'Please verify your personal information',
                        style: AppTextStyles.caption2.copyWith(color: AppColors.black),
                      ),
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
          ],
        ),
      ),
    );
  }

  Widget _buildForm(VerifyProfileController controller) {
    return Column(
      children: [
        CustomInputField(hint: 'First Name', controller: controller.firstNameController),
        SizedBox(height: 20.h),
        CustomInputField(hint: 'Last Name', controller: controller.lastNameController),
        SizedBox(height: 20.h),
        CustomInputField(hint: 'National ID', controller: controller.nationalIdController),
        SizedBox(height: 20.h),
        CustomInputField(hint: 'Birth Date (YYYY-MM-DD)', controller: controller.birthDateController),
      ],
    );
  }

  Widget _buildButton(VerifyProfileController controller) {
    return Column(
      children: [
        if (controller.isLoading) 
           const CircularProgressIndicator()
        else controller.isFormValid
            ? CustomButtonPrimaryActive(
                label: 'Verify Profile',
                onTap: () => controller.submit(),
              )
            : const CustomButtonPrimaryDissable(label: 'Verify Profile'),
      ],
    );
  }
}
