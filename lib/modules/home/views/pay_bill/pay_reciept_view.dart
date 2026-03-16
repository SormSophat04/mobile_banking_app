import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/bill/custom_bill.dart';
import 'package:mobile_banking_app/widgets/button/custom_button_primary_active.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

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
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.dg),
      child: Column(
        children: [
          Image.asset(AppAssets.imageIll5),
          SizedBox(height: 20),
          Text(
            '02/10/2025-0/12',
            style: AppTextStyles.caption1.copyWith(
              color: AppColors.darkGrey,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          SizedBox(height: 20),
          BillReceiptCard(
            name: 'Name',
            address: 'pp',
            phoneNumber: '09283423',
            code: '222',
            fromDate: '11-10-2025',
            toDate: '11-11-2025',
            electricFee: 12,
            tax: 1,
            total: 13,
          ),
          SizedBox(height: 20),
          CustomButtonPrimaryActive(
            label: 'Pay the bill',
            onTap: () => Get.toNamed(AppRoutes.PAY_SUCCESS),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }
}
