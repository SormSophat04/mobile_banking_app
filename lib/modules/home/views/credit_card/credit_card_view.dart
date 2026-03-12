import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/modules/home/widgets/custom_credit_card.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class CreditCardView extends StatelessWidget {
  const CreditCardView({super.key});

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
      child: SafeArea(child: CustomPopBar(text: 'Withdraw', bg: true)),
    );
  }

  Widget _buildBody() {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.only(top: 14.h),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.dg),
          topRight: Radius.circular(24.dg),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 24.dg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [CustomCreditCard()],
      ),
    );
  }
}
