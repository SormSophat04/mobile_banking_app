import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/khqr_controller.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class KhqrView extends GetView<KhqrController> {
  const KhqrView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('KHQR', style: AppTextStyles.title3.copyWith(color: Colors.white)),
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Text(
              controller.errorMessage,
              style: AppTextStyles.caption1.copyWith(color: Colors.red),
            ),
          );
        }

        final khqr = controller.khqrData;
        if (khqr == null) {
          return const Center(child: Text('No KHQR data available'));
        }

        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(24.dm),
            child: Column(
              children: [
                Screenshot(
                  controller: controller.screenshotController,
                  child: Container(
                    padding: EdgeInsets.all(24.dm),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          controller.account.accountType ?? 'Account',
                          style: AppTextStyles.title3.copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          controller.account.accountNumber ?? '',
                          style: AppTextStyles.caption1.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 16.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Column(
                            children: [
                              CustomInputField(
                                hint: 'Bakong ID (e.g. name@bank)',
                                controller: controller.bakongIdController,
                                prefixWidget: const Icon(Icons.account_balance_rounded, color: AppColors.primary),
                              ),
                              SizedBox(height: 12.h),
                              CustomInputField(
                                hint: 'Enter Amount (Optional)',
                                controller: controller.amountController,
                                keybaordType: TextInputType.number,
                                prefixWidget: const Icon(Icons.attach_money, color: AppColors.primary),
                                suffixWidget: IconButton(
                                  icon: const Icon(Icons.refresh, color: AppColors.primary),
                                  onPressed: () => controller.generateKhqr(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 24.h),
                        QrImageView(
                          data: khqr.payload ?? '',
                          version: QrVersions.auto,
                          size: 250.0,
                          gapless: false,
                          embeddedImage: const AssetImage('assets/icons/logo.png'),
                          embeddedImageStyle: const QrEmbeddedImageStyle(
                            size: Size(40, 40),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Scan to pay',
                          style: AppTextStyles.caption1.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 32.h),
                ElevatedButton.icon(
                  onPressed: controller.isSaving ? null : () => controller.saveQrCode(),
                  icon: controller.isSaving 
                    ? SizedBox(width: 20.w, height: 20.h, child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.download_rounded),
                  label: Text(controller.isSaving ? 'Saving...' : 'Save QR Code'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: Size(double.infinity, 50.h),
                    shape: RoundedRectanglePlatform.borderRadius(12.r),
                    disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class RoundedRectanglePlatform {
  static RoundedRectangleBorder borderRadius(double r) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(r));
}
