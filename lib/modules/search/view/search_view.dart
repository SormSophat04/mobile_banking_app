import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/modules/search/controller/search_menu_controller.dart';
import 'package:mobile_banking_app/modules/search/widgets/custom_search_card.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      title: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'Search',
          style: TextStyle(
            color: AppColors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
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
