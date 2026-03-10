import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/modules/main_layout/view/main_layout_view.dart';

class MainLayoutController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void onItemSelected(int index) {
    selectedIndex.value = index;
    update();
  }

  final List<BottomNavItem> items = [
    BottomNavItem(
      icon: AppAssets.home,
      activeIcon: AppAssets.homeActive,
      label: 'Home',
    ),
    BottomNavItem(
      icon: AppAssets.search,
      activeIcon: AppAssets.searchActive,
      label: 'Search',
    ),
    BottomNavItem(
      icon: AppAssets.message,
      activeIcon: AppAssets.messageActive,
      label: 'Message',
    ),
    BottomNavItem(
      icon: AppAssets.settings,
      activeIcon: AppAssets.settingsActive,
      label: 'Setting',
    ),
  ];
}
