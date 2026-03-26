import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/pay_bill_controller.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';

class PaySuccessView extends StatelessWidget {
  const PaySuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: GetBuilder<PayBillController>(
        builder: (controller) {
          final res = controller.billPaymentResponse.value;
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24.dg),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 80.h),
                  Image.asset(AppAssets.imageSuccess, width: 150.w),
                  SizedBox(height: 20.h),
                  Text(
                    'Payment Successful!',
                    style: AppTextStyles.body1.copyWith(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Your bill has been paid successfully.',
                    style: AppTextStyles.caption1.copyWith(color: AppColors.darkGrey),
                  ),
                  SizedBox(height: 30.h),
                  _buildDetailRow('Receipt No', res?.receiptNo ?? 'N/A'),
                  _buildDetailRow('Transaction ID', res?.transactionId?.toString() ?? 'N/A'),
                  _buildDetailRow('Paid Amount', '${res?.paidAmount ?? 0.0} ${res?.currency ?? "USD"}'),
                  _buildDetailRow('Reference', res?.referenceNumber ?? 'N/A'),
                  _buildDetailRow('Paid At', res?.paidAt ?? 'N/A'),
                  SizedBox(height: 50.h),
                  CustomButtonPrimaryActive(
                    label: 'Back to Home',
                    onTap: () => Get.offAllNamed(AppRoutes.MAIN_LAYOUT),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.caption1.copyWith(color: AppColors.darkGrey)),
          Text(value, style: AppTextStyles.body1.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
