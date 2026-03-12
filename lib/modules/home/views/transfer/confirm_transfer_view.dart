import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class ConfirmTransferView extends StatelessWidget {
  const ConfirmTransferView({super.key});

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
      child: SafeArea(child: CustomPopBar(text: 'Transfer')),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.dg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18.h),
          Text(
            'Confirm transaction information',
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          CustomInputField(label: 'From', keybaordType: TextInputType.number),
          SizedBox(height: 18.h),
          CustomInputField(label: 'To'),
          SizedBox(height: 18.h),
          CustomInputField(
            label: 'Card number',
            keybaordType: TextInputType.number,
            suffixWidget: Padding(
              padding: EdgeInsets.all(12.dg),
              child: Image.asset(
                AppAssets.arrowUnfold,
                height: 12.h,
                width: 12.w,
                color: AppColors.grey,
              ),
            ),
          ),
          SizedBox(height: 18.h),
          CustomInputField(
            label: 'Transfer fee',
            keybaordType: TextInputType.number,
          ),
          SizedBox(height: 18.h),
          CustomInputField(label: 'Content', keybaordType: TextInputType.text),
          SizedBox(height: 18.h),
          CustomInputField(label: 'Amount', keybaordType: TextInputType.number),
          SizedBox(height: 18.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: CustomInputField(
                  label: 'Verify OTP transaction',
                  hint: 'OTP',
                  keybaordType: TextInputType.number,
                ),
              ),
              SizedBox(width: 14.w),
              SizedBox(
                width: 100.w,
                child: CustomButtonPrimaryActive(label: 'Get OTP'),
              ),
            ],
          ),
          SizedBox(height: 30.h),
          CustomButtonPrimaryActive(
            label: 'Confirm',
            onTap: () => Get.offAndToNamed(AppRoutes.TRANSFER_SUCCESS),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
