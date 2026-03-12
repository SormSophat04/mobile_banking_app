import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/core/constants/app_shadows.dart';
import 'package:mobile_banking_app/core/constants/app_text_styles.dart';
import 'package:mobile_banking_app/modules/home/controllers/save_online_controller.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class SaveOnlineView extends StatelessWidget {
  const SaveOnlineView({super.key});

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
      child: SafeArea(child: CustomPopBar(text: 'Save Online')),
    );
  }

  Widget _buildBody() {
    return GetBuilder<SaveOnlineController>(
      builder: (controller) => ListView.builder(
        itemCount: controller.saveOnline.length,
        padding: EdgeInsets.symmetric(horizontal: 24.dg),
        itemBuilder: (context, index) => _buildItem(
          controller.saveOnline[index]['title'],
          controller.saveOnline[index]['subtitle'],
          controller.saveOnline[index]['icon'],
          ontap: () => Get.toNamed(
            controller.saveOnline[index]['route'],
            arguments: controller.saveOnline[index]['title'],
          ),
        ),
      ),
    );
  }

  Widget _buildItem(String title, subtitle, image, {void Function()? ontap}) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        height: 110.h,
        padding: EdgeInsets.all(16.dg),
        margin: EdgeInsets.only(top: 16.h),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15.dg),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.title2.copyWith(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppTextStyles.caption1.copyWith(
                      color: AppColors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Image.asset(image),
          ],
        ),
      ),
    );
  }
}
