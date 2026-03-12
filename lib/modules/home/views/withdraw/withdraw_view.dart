import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/withdraw_controller.dart';
import 'package:mobile_banking_app/modules/home/widgets/custom_grid_choose_amount.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class WithdrawView extends StatelessWidget {
  const WithdrawView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WithdrawController>(
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: _buildAppBar(),
        body: _buildBody(controller),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(child: CustomPopBar(text: 'Withdraw')),
    );
  }

  Widget _buildBody(WithdrawController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.dg),
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppAssets.imageIll4),
            SizedBox(height: 54.h),
            CustomInputField(
              hint: 'Choose account/card',
              controller: controller.accountController,
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
            SizedBox(height: 20.h),
            CustomInputField(
              hint: 'Phone number',
              controller: controller.phoneController,
              keybaordType: TextInputType.phone,
            ),
            SizedBox(height: 24.h),
            Text(
              'Choose amount',
              style: AppTextStyles.title3.copyWith(color: AppColors.grey),
            ),
            SizedBox(height: 16.h),
            if (controller.isOtherSelected)
              CustomInputField(
                hint: 'Enter amount',
                controller: controller.otherAmountController,
                keybaordType: TextInputType.number,
              )
            else
              CustomGridChooseAmount(
                amounts: controller.amounts,
                selectedIndex: controller.selectedIndex,
                onSelect: controller.selectAmount,
              ),
            SizedBox(height: 24.h),
            controller.isFormValid
                ? CustomButtonPrimaryActive(
                    label: 'Verify',
                    onTap: () => Get.toNamed(AppRoutes.WITHDRAW_SUCCESS),
                  )
                : CustomButtonPrimaryDissable(label: 'Verify'),
            SizedBox(height: 26.h),
          ],
        ),
      ),
    );
  }
}
