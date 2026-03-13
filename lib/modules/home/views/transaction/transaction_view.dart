import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/transaction_controller.dart';
import 'package:mobile_banking_app/modules/home/widgets/custom_credit_card.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class TransactionView extends StatelessWidget {
  const TransactionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(
        child: CustomPopBar(text: 'Transaction report', bg: true),
      ),
    );
  }

  Widget _buildBody() {
    return Stack(
      children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          margin: EdgeInsets.only(top: 100.h),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(26.dg),
              topRight: Radius.circular(26.dg),
            ),
          ),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(top: 120.h, bottom: 24.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.dm),
                    decoration: BoxDecoration(boxShadow: AppShadows.card),
                    child: Image.asset(AppAssets.chart),
                  ),
                  SizedBox(height: 22.h),
                  Padding(
                    padding: EdgeInsets.only(left: 24.dg),
                    child: Text(
                      'Today',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GetBuilder<TransactionController>(
                    builder: (controller) => ListView.builder(
                      itemCount: controller.transactions.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 24.dg),
                      itemBuilder: (context, index) {
                        final transaction = controller.transactions[index];
                        return _buildItem(
                          transaction['title'] ?? 'Transaction',
                          transaction['subtitle'] ?? '',
                          transaction['amount'] ?? '',
                          transaction['icon'] ?? AppAssets.transaction,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(top: -18, left: 0, right: 0, child: CustomCreditCard()),
      ],
    );
  }

  Widget _buildItem(String title, String subtitle, String amount, String icon) {
    final isNegativeAmount = amount.trim().startsWith('-');

    return Container(
      height: 52.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.backgroundGrey)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40.h,
            width: 40.w,
            child: Image.asset(icon, fit: BoxFit.cover),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.black,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: AppTextStyles.caption1.copyWith(color: AppColors.grey),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: AppTextStyles.title3.copyWith(
              color: isNegativeAmount ? AppColors.danger : AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
