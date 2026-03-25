import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/pay_bill_controller.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/text_field/custom_text_field.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class PaySearchCodeView extends StatefulWidget {
  const PaySearchCodeView({super.key});

  @override
  State<PaySearchCodeView> createState() => _PaySearchCodeViewState();
}

class _PaySearchCodeViewState extends State<PaySearchCodeView> {
  final billCodeController = TextEditingController();

  @override
  void dispose() {
    billCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args = Get.arguments ?? {};
    final String title = args['title'] ?? 'Pay the bill';
    final String billType = args['status'] ?? '';

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(53.h),
        child: SafeArea(child: CustomPopBar(text: title)),
      ),
      body: _buildBody(billType),
    );
  }

  Widget _buildBody(String billType) {
    return GetBuilder<PayBillController>(
      builder: (controller) => SingleChildScrollView(
        padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.dg, vertical: 16.dg),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(24.r),
            boxShadow: AppShadows.card,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Type $billType bill code'.toLowerCase(),
                style: AppTextStyles.body3.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 6.h),
              CustomInputField(
                hint: 'Bill code',
                controller: billCodeController,
              ),
              SizedBox(height: 24.h),
              Text(
                'Please enter the correct bill code to check information.',
                style: AppTextStyles.body3,
              ),
              SizedBox(height: 20.h),
              CustomButtonPrimaryActive(
                label: controller.isLoading ? 'Checking...' : 'Check',
                onTap: controller.isLoading
                    ? null
                    : () {
                        if (billCodeController.text.isNotEmpty) {
                          controller.fetchBillDetails(
                            billType,
                            billCodeController.text.trim(),
                          );
                        } else {
                          Get.snackbar('Error', 'Please enter bill code');
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
