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
import 'package:mobile_banking_app/widgets/card/custom_user_card.dart';
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
        body: _buildBody(context, controller),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(child: CustomPopBar(text: 'Transfer')),
    );
  }

  Widget _buildBody(BuildContext context, TransferController controller) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 18.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.dg),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.dg, vertical: 16.dg),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(15.r),
                boxShadow: AppShadows.card,
              ),
              child: CustomInputField(
                hint: 'Choose account/card',
                controller: controller.accountController,
                keybaordType: TextInputType.number,
                isReadOnly: true,
                onTap: () {
                  if (controller.accounts.isNotEmpty) {
                    _showAccountPicker(context, controller);
                  } else if (controller.isLoadingAccounts) {
                    Get.snackbar('Notice', 'Fetching accounts...');
                  } else {
                    // trigger fetch again if it failed
                    controller.fetchAccounts();
                    Get.snackbar(
                      'Notice',
                      'No accounts available! Trying to fetch again...',
                    );
                  }
                },
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
          ),
          SizedBox(height: 20.h),
          _buildQrActionButtons(controller),
          SizedBox(height: 16.h),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24),
          //   child: Text(
          //     'Choose transaction',
          //     style: AppTextStyles.caption1.copyWith(
          //       color: AppColors.grey,
          //       fontSize: 14.sp,
          //       fontWeight: FontWeight.w600,
          //     ),
          //   ),
          // ),
          // SizedBox(height: 16.h),
          // _buildScrollTransaction(controller),
          // SizedBox(height: 16.h),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 24),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Choose beneficiary',
          //         style: AppTextStyles.caption1.copyWith(
          //           color: AppColors.grey,
          //           fontSize: 14.sp,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //       Text(
          //         'Find beneficiary',
          //         style: AppTextStyles.caption1.copyWith(
          //           color: AppColors.primary,
          //           fontSize: 14.sp,
          //           fontWeight: FontWeight.w600,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 4.h),
          // _buildScrollBeneficiary(controller),
          // SizedBox(height: 16.h),
          _buildFormCardTransfer(controller),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }

  Widget _buildQrActionButtons(TransferController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.dg),
      child: Row(
        children: [
          Expanded(
            child: _buildQrActionCard(
              icon: Icons.qr_code_2_rounded,
              title: 'QR',
              subtitle: 'Share',
              onTap: () {
                if (!controller.canGenerateQr) {
                  Get.snackbar(
                    'Select account',
                    'Please choose source account first.',
                  );
                  return;
                }
                Get.toNamed(AppRoutes.TRANSFER_GENERATE_QR);
              },
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildQrActionCard(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Scan QR',
              subtitle: 'Fill account',
              onTap: () => Get.toNamed(AppRoutes.TRANSFER_SCAN_QR),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.primaryBackground,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 38.w,
              height: 38.h,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22.sp),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.black,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.body3.copyWith(
                      color: AppColors.grey,
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScrollTransaction(TransferController controller) {
    return SizedBox(
      height: 130.h,
      child: ListView.builder(
        itemCount: controller.transactionTypes.length,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 16.dg),
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(top: 15, bottom: 25),
          child: GestureDetector(
            onTap: () => controller.selectTransaction(index),
            child: CustomTransferCard(
              icon: controller.transactionTypes[index]['icon']!,
              title: controller.transactionTypes[index]['title']!,
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
            child: index == 0
                ? CustomAddNewCard(
                    isSelected: controller.selectedBeneficiaryIndex == index,
                  )
                : CustomUserCard(
                    isSelected: controller.selectedBeneficiaryIndex == index,
                  ),
          ),
        ),
      ),
    );
  }

  void _showAccountPicker(BuildContext context, TransferController controller) {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Source Account', style: AppTextStyles.title2),
            SizedBox(height: 16.h),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: controller.accounts.length,
              itemBuilder: (context, index) {
                final account = controller.accounts[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 16.h),
                  padding: EdgeInsets.symmetric(horizontal: 16.dg),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: AppShadows.card,
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      account.accountType ?? 'Account',
                      style: AppTextStyles.title3.copyWith(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      account.accountNumber ?? 'No Account Number Found',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.grey,
                        fontSize: 14.sp,
                      ),
                    ),
                    trailing: Text(
                      '${account.currency ?? '\$'}${account.balance?.toStringAsFixed(2) ?? '0.00'}',
                      style: AppTextStyles.title3.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    onTap: () {
                      controller.selectAccount(account);
                      Get.back(); // close the sheet
                    },
                  ),
                );
              },
            ),
          ],
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
          // CustomInputField(
          //   hint: 'Name',
          //   controller: controller.nameController,
          //   keybaordType: TextInputType.name,
          // ),
          // SizedBox(height: 24.h),
          CustomInputField(
            hint: 'To Account number',
            controller: controller.cardNumberController,
            keybaordType: TextInputType.number,
            suffixWidget: IconButton(
              onPressed: () => Get.toNamed(AppRoutes.TRANSFER_SCAN_QR),
              icon: Icon(
                Icons.qr_code_scanner_rounded,
                color: AppColors.primary,
                size: 22.sp,
              ),
            ),
          ),
          SizedBox(height: 24.h),
          CustomInputField(
            hint: 'Amount',
            controller: controller.amountController,
            keybaordType: TextInputType.number,
          ),
          SizedBox(height: 24.h),
          CustomInputField(
            hint: 'Transfer Note',
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
          GetBuilder<TransferController>(
            builder: (controller) => controller.isTransferring
                ? const Center(child: CircularProgressIndicator())
                : controller.isFormValid
                ? CustomButtonPrimaryActive(
                    label: 'Transfer',
                    onTap: () => controller.submitTransfer(),
                  )
                : CustomButtonPrimaryDissable(label: 'Transfer', onTap: () {}),
          ),
        ],
      ),
    );
  }
}
