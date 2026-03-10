import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class ExchageRateView extends StatelessWidget {
  const ExchageRateView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: AppColors.white, body: _buildBody());
  }

  Widget _buildBody() {
    return SafeArea(
      child: Column(
        children: [
          CustomPopBar(text: 'Exchange rate'),
          SizedBox(height: 12.h),
          _buildHeader(),
          SizedBox(height: 24.h),
          Expanded(
            child: ListView.builder(
              itemCount: 20,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              itemBuilder: (context, index) => _buildExchangeItems(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExchangeItems() {
    return Container(
      height: 34.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.5, color: AppColors.backgroundGrey),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(AppAssets.flagUs1, width: 24.w, height: 24.h),
              SizedBox(width: 12.w),
              Text(
                "United States",
                style: TextStyle(
                  color: AppColors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Spacer(),
          Text(
            "1.0224",
            style: TextStyle(
              color: AppColors.black,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(width: 24.w),
          Text(
            "1.3243",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Text(
            "Currency",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Spacer(),
          Text(
            "Buy",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 44.w),
          Text(
            "Sell",
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
