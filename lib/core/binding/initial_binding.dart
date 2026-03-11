import 'package:get/get.dart';
import 'package:mobile_banking_app/modules/home/controllers/credit_card_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/card_and_account_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/home_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/withdraw_controller.dart';
import 'package:mobile_banking_app/modules/main_layout/controller/main_layout_controller.dart';
import 'package:mobile_banking_app/modules/message/controller/message_controller.dart';
import 'package:mobile_banking_app/modules/search/controller/search_menu_controller.dart';
import 'package:mobile_banking_app/modules/setting/controller/setting_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainLayoutController>(
      () => MainLayoutController(),
      fenix: true,
    );
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<SearchMenuController>(
      () => SearchMenuController(),
      fenix: true,
    );
    Get.lazyPut<MessageController>(() => MessageController(), fenix: true);
    Get.lazyPut<SettingController>(() => SettingController(), fenix: true);

    // Under Home
    Get.lazyPut<CreditCardController>(
      () => CreditCardController(),
      fenix: true,
    );
    Get.lazyPut<CardAndAccountController>(
      () => CardAndAccountController(),
      fenix: true,
    );
    Get.lazyPut<WithdrawController>(
      () => WithdrawController(),
      fenix: true,
    );
  }
}
