import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/qr_payment_controller.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_dissable.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class QrPaymentView extends GetView<QrPaymentController> {
  const QrPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(53.h),
        child: SafeArea(child: CustomPopBar(text: 'Quick Pay')),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: EdgeInsets.all(24.dg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildRecipientCard(),
              SizedBox(height: 24.h),
              Text('From Account', style: AppTextStyles.title3),
              SizedBox(height: 12.h),
              _buildAccountSelector(),
              SizedBox(height: 24.h),
              Text('Amount', style: AppTextStyles.title3),
              SizedBox(height: 12.h),
              CustomInputField(
                hint: '0.00',
                controller: controller.amountController,
                keybaordType: TextInputType.number,
                prefixWidget: Icon(Icons.attach_money, color: AppColors.primary),
              ),
              SizedBox(height: 24.h),
              Text('Remark (Optional)', style: AppTextStyles.title3),
              SizedBox(height: 12.h),
              CustomInputField(
                hint: 'Note for payment',
                controller: controller.remarkController,
              ),
              SizedBox(height: 48.h),
              controller.isSubmitting 
                ? const Center(child: CircularProgressIndicator())
                : controller.isFormValid 
                  ? CustomButtonPrimaryActive(
                      label: 'Pay Now',
                      onTap: () => controller.submitPayment(),
                    )
                  : CustomButtonPrimaryDissable(label: 'Pay Now', onTap: () {}),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildRecipientCard() {
    return Container(
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.dg),
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: Colors.white),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.recipientName.value,
                  style: AppTextStyles.title3.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  controller.recipientAccountNumber.value,
                  style: AppTextStyles.caption1.copyWith(color: AppColors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSelector() {
    return GestureDetector(
      onTap: () => _showAccountPicker(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet_outlined, color: AppColors.primary),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                controller.selectedAccount.value != null 
                  ? '${controller.selectedAccount.value!.accountType} (${controller.selectedAccount.value!.accountNumber})'
                  : 'Select Account',
                style: AppTextStyles.body2,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: AppColors.grey),
          ],
        ),
      ),
    );
  }

  void _showAccountPicker() {
    Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(24.dg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Account', style: AppTextStyles.title2),
            SizedBox(height: 16.h),
            ListView.builder(
              shrinkWrap: true,
              itemCount: controller.accounts.length,
              itemBuilder: (context, index) {
                final account = controller.accounts[index];
                return ListTile(
                  title: Text(account.accountType ?? 'Account'),
                  subtitle: Text(account.accountNumber ?? ''),
                  trailing: Text('\$${account.balance?.toStringAsFixed(2) ?? '0.00'}'),
                  onTap: () {
                    controller.selectAccount(account);
                    Get.back();
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
