import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';
import 'package:mobile_banking_app/modules/home/controllers/transfer_controller.dart';

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
    final TransferController controller = Get.find<TransferController>();

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
          CustomInputField(
            label: 'From',
            keybaordType: TextInputType.number,
            text: controller.accountController.text,
            isReadOnly: true,
          ),
          SizedBox(height: 18.h),
          CustomInputField(
            label: 'To (Name)',
            text: controller.nameController.text,
            isReadOnly: true,
          ),
          SizedBox(height: 18.h),
          CustomInputField(
            label: 'Card/Account number',
            keybaordType: TextInputType.number,
            text: controller.cardNumberController.text,
            isReadOnly: true,
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
            text: '0.0', // Fee mock
            isReadOnly: true,
          ),
          SizedBox(height: 18.h),
          CustomInputField(
            label: 'Content / Note',
            keybaordType: TextInputType.text,
            text: controller.contentController.text,
            isReadOnly: true,
          ),
          SizedBox(height: 18.h),
          CustomInputField(
            label: 'Amount',
            keybaordType: TextInputType.number,
            text: '\$${controller.amountController.text}',
            isReadOnly: true,
          ),
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
          GetBuilder<TransferController>(
            builder: (controller) => controller.isTransferring
                ? const Center(child: CircularProgressIndicator())
                : CustomButtonPrimaryActive(
                    label: 'Confirm',
                    onTap: () => controller.submitTransfer(),
                  ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}
