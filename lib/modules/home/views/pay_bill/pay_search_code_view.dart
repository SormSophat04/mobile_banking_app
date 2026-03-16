import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class PaySearchCodeView extends StatelessWidget {
  const PaySearchCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: ScreenUtil.defaultSize,
        child: SafeArea(child: CustomPopBar(text: 'Pay the bill')),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 40, left: 24, right: 24),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.dg, vertical: 16.dg),

        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Type internet bill code',
              style: AppTextStyles.body3.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 6.h),
            CustomInputField(hint: 'Bill code'),
            SizedBox(height: 24.h),
            Text(
              'Please enter the correct bill code to check information.',
              style: AppTextStyles.body3,
            ),
            SizedBox(height: 20.h),
            CustomButtonPrimaryActive(
              label: 'Check',
              onTap: () => Get.toNamed(AppRoutes.PAY_RECIEPT),
            ),
          ],
        ),
      ),
    );
  }
}
