import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/setting/controller/setting_controller.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class AppInformationView extends StatelessWidget {
  const AppInformationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(53.h),
      child: SafeArea(child: CustomPopBar(text: 'App Information')),
    );
  }

  Widget _buildBody() {
    return GetBuilder<SettingController>(
      builder: (controller) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 24.dg),
        child: Column(
          children: [
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Cambodia Banking App',
                  style: AppTextStyles.title2.copyWith(color: AppColors.black),
                ),
              ],
            ),
            SizedBox(height: 30.h),
            ListView.builder(
              itemCount: controller.appInformationItems.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) => _buildItem(
                controller.appInformationItems[index]['title']!,
                controller.appInformationItems[index]['value']!,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, String value) {
    return Container(
      height: 36.h,
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.lightGrey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.body1.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
