import 'package:get/get.dart';
import 'package:mobile_banking_app/modules/home/controllers/home_controller.dart';
import 'package:mobile_banking_app/modules/main_layout/controller/main_layout_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainLayoutController>(
      () => MainLayoutController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
  }
}
