import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/transfer_controller.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/card/custom_add_new_card.dart';
import 'package:mobile_banking_app/widgets/card/custom_transfer_card.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class TransferView extends StatelessWidget {
  const TransferView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransferController>(
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
      child: SafeArea(child: CustomPopBar(text: 'Transfer')),
    );
  }

  Widget _buildBody(TransferController controller) {
    return SingleChildScrollView(
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
            child: Text(
              'Choose transaction',
              style: AppTextStyles.caption1.copyWith(
                color: AppColors.grey,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          _buildScrollTransaction(controller),
          SizedBox(height: 16.h),
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
          SizedBox(height: 16.h),
          _buildFormCardTransfer(controller),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildScrollTransaction(TransferController controller) {
    return SizedBox(
      height: 130.h,
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.dg),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 25),
          child: GestureDetector(
            onTap: () => controller.selectTransaction(index),
            child: CustomTransferCard(
              isSelected: controller.selectedTransactionIndex == index,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScrollBeneficiary(TransferController controller) {
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

  Widget _buildFormCardTransfer(TransferController controller) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.dg, vertical: 24.dg),
      margin: EdgeInsets.symmetric(horizontal: 24.dg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        children: [
          CustomInputField(
            hint: 'Name',
            controller: controller.nameController,
            keybaordType: TextInputType.name,
          ),
          SizedBox(height: 24.h),
          CustomInputField(
            hint: 'Card number',
            controller: controller.cardNumberController,
            keybaordType: TextInputType.number,
          ),
          SizedBox(height: 24.h),
          CustomInputField(
            hint: 'Amount',
            controller: controller.amountController,
            keybaordType: TextInputType.number,
          ),
          SizedBox(height: 24.h),
          CustomInputField(
            hint: 'Content',
            controller: controller.contentController,
            keybaordType: TextInputType.text,
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: controller.toggleSaveToBeneficiary,
            child: Row(
              children: [
                Container(
                  height: 24.h,
                  width: 24.w,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(
                        controller.saveToBeneficiary
                            ? AppAssets.checkBox2
                            : AppAssets.checkBox1,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Text( 
                  'Save to beneficiary ',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          controller.isFormValid
              ? CustomButtonPrimaryActive(
                  label: 'Confirm',
                  onTap: () => Get.toNamed(AppRoutes.CONFIRM_TRANSFER),
                )
              : CustomButtonPrimaryDissable(
                  label: 'Confirm',
                  onTap: () => Get.toNamed(AppRoutes.CONFIRM_TRANSFER),
                ),
        ],
      ),
    );
  }
}
