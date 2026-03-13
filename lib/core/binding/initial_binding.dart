import 'package:get/get.dart';
import 'package:mobile_banking_app/modules/auth/controller/forgot_password_controller.dart';
import 'package:mobile_banking_app/modules/auth/controller/login_controlller.dart';
import 'package:mobile_banking_app/modules/auth/controller/reset_password_controller.dart';
import 'package:mobile_banking_app/modules/auth/controller/sing_up_controller.dart';
import 'package:mobile_banking_app/modules/auth/controller/verify_code_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/beneficiary_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/credit_card_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/card_and_account_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/home_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/pay_bill_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/prepain_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/save_online_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/transaction_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/transfer_controller.dart';
import 'package:mobile_banking_app/modules/home/controllers/withdraw_controller.dart';
import 'package:mobile_banking_app/modules/main_layout/controller/main_layout_controller.dart';
import 'package:mobile_banking_app/modules/message/controller/message_controller.dart';
import 'package:mobile_banking_app/modules/search/controller/search_menu_controller.dart';
import 'package:mobile_banking_app/modules/security/controller/security_controller.dart';
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

    // Auth
    Get.lazyPut<LoginController>(() => LoginController(), fenix: true);
    Get.lazyPut<SingUpController>(() => SingUpController(), fenix: true);
    Get.lazyPut<ForgotPasswordController>(
      () => ForgotPasswordController(),
      fenix: true,
    );
    Get.lazyPut<VerifyCodeController>(
      () => VerifyCodeController(),
      fenix: true,
    );
    Get.lazyPut<ResetPasswordController>(
      () => ResetPasswordController(),
      fenix: true,
    );

    // Under Home
    Get.lazyPut<CreditCardController>(
      () => CreditCardController(),
      fenix: true,
    );
    Get.lazyPut<CardAndAccountController>(
      () => CardAndAccountController(),
      fenix: true,
    );
    Get.lazyPut<TransferController>(() => TransferController(), fenix: true);
    Get.lazyPut<WithdrawController>(() => WithdrawController(), fenix: true);
    Get.lazyPut<PrepainController>(() => PrepainController(), fenix: true);
    Get.lazyPut<PayBillController>(() => PayBillController(), fenix: true);
    Get.lazyPut<SaveOnlineController>(
      () => SaveOnlineController(),
      fenix: true,
    );
    Get.lazyPut<BeneficiaryController>(
      () => BeneficiaryController(),
      fenix: true,
    );
    Get.lazyPut<TransactionController>(
      () => TransactionController(),
      fenix: true,
    );

    Get.lazyPut<SecurityController>(() => SecurityController(), fenix: true);
  }
}
