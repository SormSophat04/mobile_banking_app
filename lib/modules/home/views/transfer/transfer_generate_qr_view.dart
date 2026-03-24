import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/transfer_controller.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TransferGenerateQrView extends StatelessWidget {
  const TransferGenerateQrView({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TransferController>(
      builder: (controller) => Scaffold(
        backgroundColor: AppColors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(53.h),
          child: SafeArea(child: CustomPopBar(text: 'My Scan Pay QR')),
        ),
        body: controller.canGenerateQr
            ? _buildQrContent(controller)
            : _buildMissingAccountContent(),
      ),
    );
  }

  Widget _buildQrContent(TransferController controller) {
    final account = controller.selectedAccountModel;
    final qrPayload = controller.buildScanPayQrPayload();

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Let payer scan this QR to auto-fill your account number.',
            style: AppTextStyles.body2.copyWith(
              color: AppColors.grey,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              children: [
                Text(
                  account?.accountType ?? 'Account',
                  style: AppTextStyles.title3.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  account?.accountNumber ?? '-',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.grey,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 18.h),
                DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(color: AppColors.lightGrey, width: 1.2),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: QrImageView(
                      data: qrPayload,
                      version: QrVersions.auto,
                      size: 220.w,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: AppColors.black,
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: AppColors.black,
                      ),
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          CustomButtonPrimaryActive(
            label: 'Copy Account Number',
            onTap: () async {
              await Clipboard.setData(ClipboardData(text: qrPayload));
              Get.snackbar('Copied', 'Account number copied to clipboard');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMissingAccountContent() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.all(18.w),
            decoration: BoxDecoration(
              color: AppColors.primaryBackground,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Text(
              'Please select a source account in Transfer screen before generating QR.',
              style: AppTextStyles.body2.copyWith(
                color: AppColors.black,
                fontSize: 14.sp,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          CustomButtonPrimaryActive(label: 'Back To Transfer', onTap: Get.back),
        ],
      ),
    );
  }
}
