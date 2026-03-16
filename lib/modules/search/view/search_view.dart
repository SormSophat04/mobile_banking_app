import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/modules/search/controller/search_menu_controller.dart';
import 'package:mobile_banking_app/modules/search/widgets/custom_search_card.dart';
import 'package:mobile_banking_app/widgets/topbar/custom_pop_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: PreferredSize(
        preferredSize: ScreenUtil.defaultSize,
        child: SafeArea(child: CustomPopBar(text: 'Search', icon: false)),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return GetBuilder<SearchMenuController>(
      builder: (controller) => SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10.h),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.cardItems.length,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    final route = controller.cardItems[index]['route'];
                    if (route != null) {
                      Get.toNamed(route);
                    }
                  },
                  child: CustomSearchCard(
                    title: controller.cardItems[index]['title']!,
                    subtitle: controller.cardItems[index]['subtitle']!,
                    image: controller.cardItems[index]['image']!,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
