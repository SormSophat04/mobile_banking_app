import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class ExchageView extends StatelessWidget {
  const ExchageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.white, body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            CustomPopBar(text: 'Exchange'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Image.asset(AppAssets.imageIll5),
            ),
            SizedBox(height: 24.h),
            _buildCardTransfer(),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCardTransfer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.dg, vertical: 16.dg),
      margin: EdgeInsets.symmetric(horizontal: 24.dm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          CustomInputField(
            label: 'From',
            keybaordType: TextInputType.number,
            suffixWidget: Container(
              width: 90.w,
              margin: EdgeInsets.symmetric(vertical: 6.dg),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.5.w, color: AppColors.grey),
                ),
              ),
              child: GestureDetector(
                onTap: () {},
                child: _buildSelectCurrency(),
              ),
            ),
          ),
          SizedBox(height: 24.h),
          Image.asset(AppAssets.arrowUpDown, height: 24.h),
          SizedBox(height: 8.h),
          CustomInputField(
            label: 'To',
            keybaordType: TextInputType.number,
            suffixWidget: Container(
              width: 90.w,
              margin: EdgeInsets.symmetric(vertical: 6.dg),
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(width: 1.5.w, color: AppColors.grey),
                ),
              ),
              child: GestureDetector(
                onTap: () {},
                child: _buildSelectCurrency(),
              ),
            ),
          ),
          SizedBox(height: 40.h),
          CustomButtonPrimaryActive(label: 'Exchange'),
        ],
      ),
    );
  }

  Widget _buildSelectCurrency() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'USD',
          style: AppTextStyles.title3.copyWith(color: AppColors.darkGrey),
        ),
        SizedBox(width: 6.w),
        Image.asset(AppAssets.arrowUnfold, height: 20.h, color: AppColors.grey),
      ],
    );
  }
}
