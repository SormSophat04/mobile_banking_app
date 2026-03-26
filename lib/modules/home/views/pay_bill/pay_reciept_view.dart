import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/pay_bill_controller.dart';
import 'package:mobile_banking_app/widgets/bill/custom_bill.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';
import 'package:mobile_banking_app/modules/home/controllers/card_and_account_controller.dart';

class PayRecieptView extends StatelessWidget {
  const PayRecieptView({super.key});

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
    return GetBuilder<PayBillController>(
      builder: (controller) {
        final bill = controller.selectedBill.value;
        if (bill == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.dg),
          child: Column(
            children: [
              SizedBox(height: 20.h),
              Text(
                'Due Date: ${bill.dueDate ?? "N/A"}',
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.darkGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              SizedBox(height: 20.h),
              BillReceiptCard(
                name: bill.customerName ?? 'N/A',
                address: bill.address ?? 'N/A',
                phoneNumber: bill.phoneNumber ?? 'N/A',
                code: bill.billCode ?? 'N/A',
                fromDate: bill.periodFrom ?? 'N/A',
                toDate: bill.periodTo ?? 'N/A',
                fee: bill.feeAmount ?? 0.0,
                tax: bill.taxAmount ?? 0.0,
                total: bill.totalAmount ?? 0.0,
                backgroundColor: AppColors.white,
              ),
              SizedBox(height: 20.h),
              CustomButtonPrimaryActive(
                label: controller.isLoading ? 'Processing...' : 'Pay the bill',
                onTap: controller.isLoading 
                    ? null 
                    : () {
                        final accountController = Get.find<CardAndAccountController>();
                        final fromAccount = accountController.accounts.isNotEmpty 
                            ? accountController.accounts.first.accountNumber ?? "001234"
                            : "001234";
                        controller.payBill(fromAccount);
                      },
              ),
              SizedBox(height: 60.h),
            ],
          ),
        );
      },
    );
  }
}
