import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class BeneficiaryView extends StatelessWidget {
  const BeneficiaryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(child: CustomPopBar(text: 'Beneficiary')),
    );
  }

  Widget _buildFloatingActionButton() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0, right: 12.0),
      child: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.ADD_USER_BENEFICIARY),
        shape: CircleBorder(),
        splashColor: AppColors.primaryLight,
        backgroundColor: AppColors.primary,
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(13.dg),
          child: Image.asset(AppAssets.add, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 24.dg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text(
            'Transfer via card number',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.grey,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.only(left: 16.dg, right: 16.dg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: AppColors.white,
              boxShadow: AppShadows.card,
            ),
            child: Builder(
              builder: (context) {
                final itemCount = 2;
                return ListView.builder(
                  itemCount: itemCount,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _buildItem(isLast: index == itemCount - 1),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Transfer via card number',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.grey,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.only(left: 16.dg, right: 16.dg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: AppColors.white,
              boxShadow: AppShadows.card,
            ),
            child: Builder(
              builder: (context) {
                final itemCount = 2;
                return ListView.builder(
                  itemCount: itemCount,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _buildItem(isLast: index == itemCount - 1),
                );
              },
            ),
          ),
          SizedBox(height: 24),
          Text(
            'Transfer via card number',
            style: AppTextStyles.body1.copyWith(
              color: AppColors.grey,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.only(left: 16.dg, right: 16.dg),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.r),
              color: AppColors.white,
              boxShadow: AppShadows.card,
            ),
            child: Builder(
              builder: (context) {
                final itemCount = 12;
                return ListView.builder(
                  itemCount: itemCount,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      _buildItem(isLast: index == itemCount - 1),
                );
              },
            ),
          ),
          SizedBox(height: 44.h),
        ],
      ),
    );
  }

  Widget _buildItem({required bool isLast}) {
    return Container(
      height: 52.h,
      margin: EdgeInsets.only(top: 16.h),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(bottom: BorderSide(color: AppColors.grey)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 40.h,
            width: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryLight,
              image: DecorationImage(image: AssetImage(AppAssets.userProfile)),
            ),
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Justin Bieber',
                style: AppTextStyles.body1.copyWith(
                  color: AppColors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '056475234',
                style: AppTextStyles.caption1.copyWith(
                  color: AppColors.grey,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
