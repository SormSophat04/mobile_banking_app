import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_colors.dart';
import 'package:mobile_banking_app/modules/home/views/home_view.dart';
import 'package:mobile_banking_app/modules/main_layout/controller/main_layout_controller.dart';
import 'package:mobile_banking_app/modules/search/view/search_view.dart';
import 'package:mobile_banking_app/modules/setting/view/setting_view.dart';

class BottomNavItem {
  final String icon;
  final String activeIcon;
  final String label;

  BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}

class MainLayoutView extends StatelessWidget {
  MainLayoutView({super.key});

  final List _pages = [
    HomeView(),
    SearchView(),
    Container(color: Colors.green),
    SettingView(),
  ];

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainLayoutController>(
      builder: (controller) => Scaffold(
        body: _pages[controller.selectedIndex.value],
        bottomNavigationBar: _buildBottomNavigationBar(),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return GetBuilder<MainLayoutController>(
      builder: (controller) => GestureDetector(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.black.withAlpha(14),
                blurRadius: 10.r,
                offset: const Offset(0, -8),
              ),
            ],
          ),
          child: _buildItemNav(),
        ),
      ),
    );
  }

  Widget _buildItemNav() {
    return GetBuilder<MainLayoutController>(
      builder: (controller) => SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(controller.items.length, (index) {
            final item = controller.items[index];
            final isSelected = controller.selectedIndex.value == index;

            return GestureDetector(
              onTap: () => controller.onItemSelected(index),
              behavior: HitTestBehavior.opaque,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOutQuint,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(30.r),
                ),
                child: _buildIconsNav(item, isSelected),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildIconsNav(BottomNavItem item, bool isSelected) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          isSelected ? item.activeIcon : item.icon,
          color: isSelected ? Colors.white : AppColors.grey,
          width: isSelected ? 20.sp : 24.sp,
          height: isSelected ? 20.sp : 24.sp,
        ), // AnimatedSize handles the smooth expansion of the pill shape
        AnimatedSize(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuint,
          child: isSelected
              ? Padding(
                  padding: EdgeInsets.only(left: 8.0.w),
                  child: Text(
                    item.label,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 14.sp,
                    ),
                  ),
                )
              : const SizedBox.shrink(), // Takes up 0 space when inactive
        ),
      ],
    );
  }
}
