import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_strings.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/core/network/models/transaction_model.dart';

class TransferSuccessView extends StatelessWidget {
  const TransferSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    // Attempt to get transaction from arguments
    final transaction = Get.arguments is TransactionModel
        ? Get.arguments as TransactionModel
        : null;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
                child: Column(
                  children: [
                    // Success Icon/Header
                    Container(
                      height: 64.h,
                      width: 64.w,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.green,
                        size: 48.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      AppStrings.transferSuccess,
                      style: AppTextStyles.title2.copyWith(
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 32.h),

                    // Receipt Card
                    if (transaction != null) _buildReceiptCard(transaction),
                  ],
                ),
              ),
            ),
            // Bottom Button
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: CustomButtonPrimaryActive(
                label: AppStrings.confirm,
                onTap: () => Get.offAllNamed(AppRoutes.MAIN_LAYOUT),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReceiptCard(TransactionModel tx) {
    String dateStr = '';
    if (tx.createAt != null) {
      try {
        final dt = DateTime.parse(tx.createAt!).toLocal();
        dateStr =
            '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
      } catch (_) {
        dateStr = tx.createAt!;
      }
    }

    // Since it's a transfer success, the user is the sender.
    // The receiver is the context of "Name" and "Phone number".
    final otherName = tx.receiverName ?? tx.senderName;
    final otherPhone = tx.receiverPhone ?? tx.senderPhone;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Transfer Details',
            style: AppTextStyles.title3.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 24.h),
          _buildRow('Name', otherName ?? 'N/A'),
          SizedBox(height: 16.h),
          _buildRow('Phone number', otherPhone ?? 'N/A'),
          SizedBox(height: 16.h),
          _buildRow(
            'Code',
            tx.referenceNumber != null ? '#${tx.referenceNumber}' : 'N/A',
          ),
          SizedBox(height: 16.h),
          _buildRow('Date', dateStr),
          SizedBox(height: 16.h),
          if (tx.description != null && tx.description!.isNotEmpty) ...[
            _buildRow('Description', tx.description!),
            SizedBox(height: 16.h),
          ],
          _buildRow('Status', tx.status ?? 'SUCCESS', valueColor: Colors.green),
          // SizedBox(height: 16.h),
          // _buildRow(
          //   'Amount',
          //   '\$${tx.amount?.toStringAsFixed(2) ?? '0.00'}',
          //   valueColor: AppColors.primary,
          // ),
          SizedBox(height: 24.h),
          Divider(color: Colors.grey.shade300, thickness: 1),
          SizedBox(height: 24.h),
          _buildRow(
            'Amount',
            '${tx.senderCurrency ?? tx.currency ?? '\$'}${tx.amount?.toStringAsFixed(2) ?? '0.00'}',
            isTotal: true,
            valueColor: AppColors.danger,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    String value, {
    bool isTotal = false,
    Color? valueColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.grey,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              fontSize: isTotal ? 16.sp : 14.sp,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: AppTextStyles.body1.copyWith(
              color: valueColor ?? AppColors.black,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              fontSize: isTotal ? 20.sp : 14.sp,
            ),
          ),
        ),
      ],
    );
  }
}
