import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
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
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 24.dm),
                    decoration: BoxDecoration(boxShadow: AppShadows.card),
                    child: Image.asset(AppAssets.chart),
                  ),
                  SizedBox(height: 16.h),
                  ListView.builder(
                    itemCount: 10,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 24.dg),
                    itemBuilder: (context, index) =>
                        Container(height: 52.h, color: Colors.amber),
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
}
