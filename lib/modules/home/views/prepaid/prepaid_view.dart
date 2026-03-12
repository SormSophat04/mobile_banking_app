import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/prepain_controller.dart';
import 'package:mobile_banking_app/modules/home/widgets/custom_grid_choose_amount.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/card/custom_add_new_card.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class PrepaidView extends StatelessWidget {
  const PrepaidView({super.key});

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
      child: SafeArea(child: CustomPopBar(text: 'Mobile Prepaid')),
    );
  }

  Widget _buildBody() {
    return GetBuilder<PrepainController>(
      builder: (controller) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.dg),
              child: CustomInputField(
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
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Choose beneficiary',
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.grey,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Find beneficiary',
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.primary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4.h),
            _buildScrollBeneficiary(controller),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.dg),
              child: CustomInputField(
                hint: '(+855) XXX XXX XXX',
                label: 'Phone number',
                controller: controller.phoneController,
                keybaordType: TextInputType.number,
              ),
            ),
            SizedBox(height: 18.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.dg),
              child: Text(
                'Choose amount',
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.grey,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 24.dg),
              child: Column(
                children: [
                  SizedBox(height: 6.h),
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
                          onTap: () => Get.toNamed(AppRoutes.PREPAID_SUCCESS),
                        )
                      : CustomButtonPrimaryDissable(label: 'Verify'),
                  SizedBox(height: 26.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollBeneficiary(PrepainController controller) {
    return SizedBox(
      height: 150.h,
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.dg),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 25),
          child: GestureDetector(
            onTap: () => controller.selectBeneficiary(index),
            child: CustomAddNewCard(
              isSelected: controller.selectedBeneficiaryIndex == index,
            ),
          ),
        ),
      ),
    );
  }
}
