import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/beneficiary_controller.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/card/custom_transfer_card.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class AddUserBeneficiary extends StatelessWidget {
  const AddUserBeneficiary({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BeneficiaryController>(
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
      child: SafeArea(child: CustomPopBar(text: 'Add new')),
    );
  }

  Widget _buildBody(BeneficiaryController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildProfile(),
          SizedBox(height: 20.h),
          _buildCardTransfer(controller),
          SizedBox(height: 20.h),
          _buildFormCreate(),
          SizedBox(height: 50.h),
        ],
      ),
    );
  }

  Widget _buildFormCreate() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.dg),
      padding: EdgeInsets.symmetric(horizontal: 16.dg, vertical: 24.dg),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: AppShadows.card,
        color: AppColors.white,
      ),

      child: Column(
        children: [
          CustomInputField(
            hint: 'Choose bank',
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
          SizedBox(height: 24.h),
          CustomInputField(
            hint: 'Choose branch',
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
          SizedBox(height: 24.h),
          CustomInputField(hint: 'Transaction'),
          SizedBox(height: 24.h),
          CustomInputField(hint: 'Card number'),
          SizedBox(height: 24.h),
          CustomButtonPrimaryActive(label: 'Save to directory'),
        ],
      ),
    );
  }

  Widget _buildCardTransfer(BeneficiaryController controller) {
    return SizedBox(
      height: 130.h,
      child: ListView.builder(
        itemCount: controller.beneficiaryTypes.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.dg),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 25),
          child: GestureDetector(
            onTap: () {},
            child: CustomTransferCard(
              title: controller.beneficiaryTypes[index]['title']!,
              icon: controller.beneficiaryTypes[index]['icon']!,
            ), // Placeholder for actual item widget
          ),
        ),
      ),
    );
  }

  Widget _buildProfile() {
    return Container(
      alignment: Alignment.center,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 120.h,
                width: 120.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.backgroundGrey,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Username',
                style: AppTextStyles.title3.copyWith(color: AppColors.primary),
              ),
            ],
          ),
          Positioned(
            right: 0,
            bottom: 40,
            child: Container(
              height: 32.h,
              width: 32.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(AppAssets.add, color: AppColors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
