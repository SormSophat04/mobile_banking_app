import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/modules/setting/widgets/custom_setting_item.dart';

class SettingView extends StatelessWidget {
  const SettingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Stack(
        children: [
          Column(
            children: [
              SizedBox(height: 100.h),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(26.r),
                      topRight: Radius.circular(26.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 120.h),
                      Expanded(child: _buildItems()),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(top: 60, left: 0, right: 0, child: _buildProfile()),
        ],
      ),
    );
  }

  Widget _buildItems() {
    return ListView.builder(
      itemCount: 5,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      itemBuilder: (context, index) => CustomSettingItem(),
    );
  }

  Widget _buildProfile() {
    return Column(
      children: [
        Container(
          height: 100.h,
          width: 100.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.danger,
            image: DecorationImage(
              image: AssetImage(AppAssets.userProfile),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10.h),
        Text(
          'Setting',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
