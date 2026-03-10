import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/widgets/custom_grid_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(_) {
    return Scaffold(
      backgroundColor: AppColors.primaryLight,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130.h),
        child: _buildHeader(),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(top: 45.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildUserImage(),
          SizedBox(width: 16.w),
          _buildUserName(),
          Spacer(),
          _buildIconNotification(),
        ],
      ),
    );
  }

  Widget _buildUserImage() {
    return Container(
      width: 60.w,
      height: 60.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey,
        image: DecorationImage(image: AssetImage(AppAssets.userProfile)),
      ),
    );
  }

  Widget _buildUserName() {
    return Text('Hi, Ronaldo', style: AppTextStyles.title1);
  }

  Widget _buildIconNotification() {
    return SizedBox(
      width: 40.w,
      height: 40.h,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              AppAssets.notification,
              fit: BoxFit.cover,
              color: AppColors.white,
            ),
          ),
          Positioned(
            top: 0,
            right: 4,
            child: Container(
              width: 18.w,
              height: 18.h,
              decoration: BoxDecoration(
                color: AppColors.danger,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  "2",
                  style: TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      margin: EdgeInsets.only(top: 14.h),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10.h),
            _buildCreditCard(),
            CustomGridView(),
            SizedBox(height: 28.h),
          ],
        ),
      ),
    );
  }

  Widget _buildCreditCard() {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(AppAssets.multiCard),
    );
  }
}
