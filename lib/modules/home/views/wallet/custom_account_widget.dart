import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/card_and_account_controller.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class CustomAccountWidget extends StatelessWidget {
  const CustomAccountWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CardAndAccountController>(
      builder: (controller) {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.accounts.isEmpty) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(24.dm),
              child: Text(
                controller.errorMessage.isNotEmpty
                    ? controller.errorMessage
                    : 'No Accounts Found',
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return Container(
          margin: EdgeInsets.symmetric(horizontal: 22.dm),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: controller.accounts.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Get.toNamed(
                AppRoutes.TRANSACTION,
                arguments: controller.accounts[index],
              ),
              child: Container(
                margin: EdgeInsets.only(bottom: 16.dm),
                child: _buildAccountItem(controller.accounts[index]),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountItem(AccountModel account) {
    return Container(
      height: 100.h,
      padding: EdgeInsets.all(16.dg),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15.r),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                account.accountType ?? 'Account',
                style: AppTextStyles.title3.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  Text(
                    account.accountNumber ?? '000000',
                    style: AppTextStyles.title3.copyWith(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () {
                      final accStr = account.accountNumber ?? '000000';
                      Clipboard.setData(ClipboardData(text: accStr));
                      Get.snackbar(
                        'Copied',
                        'Account number copied to clipboard',
                        snackPosition: SnackPosition.BOTTOM,
                        margin: EdgeInsets.all(16.dm),
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Icon(Icons.copy_rounded, size: 16.sp, color: AppColors.primary),
                  ),
                  SizedBox(width: 8.w),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.KHQR, arguments: account),
                    child: Icon(Icons.qr_code_rounded, size: 20.sp, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available balance',
                style: AppTextStyles.caption2.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${account.currency} ${account.balance ?? 0.0}',
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Currency',
                style: AppTextStyles.caption2.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                account.currency ?? 'USD',
                style: AppTextStyles.caption2.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
