import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/modules/setting/controller/setting_controller.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class PasswordView extends StatelessWidget {
  const PasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(child: CustomPopBar(text: 'Change Password')),
    );
  }

  Widget _buildBody() {
    return GetBuilder<SettingController>(
      builder: (controller) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.dg),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.dg),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.r),
                color: AppColors.white,
                boxShadow: AppShadows.card,
              ),
              child: Column(
                children: [
                  CustomInputField(
                    hint: 'Recent password',
                    label: 'Recent password',
                  ),
                  SizedBox(height: 20.h),
                  CustomInputField(hint: 'New password', label: 'New password'),
                  SizedBox(height: 20.h),
                  CustomInputField(
                    hint: 'Confirm password',
                    label: 'Confirm password',
                  ),
                  SizedBox(height: 28.h),
                  CustomButtonPrimaryActive(label: 'Change password'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
