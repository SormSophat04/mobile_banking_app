import 'package:get/get.dart';
import 'package:mobile_banking_app/modules/auth/views/forgot_password_view.dart';
import 'package:mobile_banking_app/modules/auth/views/login_view.dart';
import 'package:mobile_banking_app/modules/auth/views/reset_password_view.dart';
import 'package:mobile_banking_app/modules/auth/views/reset_success_view.dart';
import 'package:mobile_banking_app/modules/auth/views/sing_up_view.dart';
import 'package:mobile_banking_app/modules/auth/views/verify_code_view.dart';
import 'package:mobile_banking_app/modules/home/views/beneficiary/beneficiary_view.dart';
import 'package:mobile_banking_app/modules/home/views/prepaid/prepaid_success_view.dart';
import 'package:mobile_banking_app/modules/home/views/transfer/confirm_transfer_view.dart';
import 'package:mobile_banking_app/modules/home/views/transfer/transfer_success_view.dart';
import 'package:mobile_banking_app/modules/home/views/wallet/card_and_account_view.dart';
import 'package:mobile_banking_app/modules/home/views/credit_card/credit_card_view.dart';
import 'package:mobile_banking_app/modules/home/views/home_view.dart';
import 'package:mobile_banking_app/modules/home/views/pay_bill/pay_bill_view.dart';
import 'package:mobile_banking_app/modules/home/views/prepaid/prepaid_view.dart';
import 'package:mobile_banking_app/modules/home/views/save_online/save_online_view.dart';
import 'package:mobile_banking_app/modules/home/views/transaction/transaction_view.dart';
import 'package:mobile_banking_app/modules/home/views/transfer/transfer_view.dart';
import 'package:mobile_banking_app/modules/home/views/withdraw/withdraw_success_view.dart';
import 'package:mobile_banking_app/modules/home/views/withdraw/withdraw_view.dart';
import 'package:mobile_banking_app/modules/main_layout/view/main_layout_view.dart';
import 'package:mobile_banking_app/modules/message/view/message_view.dart';
import 'package:mobile_banking_app/modules/search/view/branch_view.dart';
import 'package:mobile_banking_app/modules/search/view/exchage_rate_view.dart';
import 'package:mobile_banking_app/modules/search/view/exchage_view.dart';
import 'package:mobile_banking_app/modules/search/view/interest_rate_view.dart';
import 'package:mobile_banking_app/modules/search/view/search_view.dart';
import 'package:mobile_banking_app/modules/setting/view/setting_view.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class AppPages {
  static final routes = [
    // Auth Screen
    GetPage(name: AppRoutes.LOGIN, page: () => const LoginView()),
    GetPage(name: AppRoutes.SIGN_UP, page: () => const SingUpView()),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
    ),
    GetPage(name: AppRoutes.VERIFY_CODE, page: () => const VerifyCodeView()),
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
    ),
    GetPage(
      name: AppRoutes.RESET_SUCCESS,
      page: () => const ResetSuccessView(),
    ),

    // Main Layout
    GetPage(name: AppRoutes.MAIN_LAYOUT, page: () => MainLayoutView()),
    GetPage(name: AppRoutes.HOME, page: () => const HomeView()),
    GetPage(name: AppRoutes.SEARCH, page: () => const SearchView()),
    GetPage(name: AppRoutes.MESSAGE, page: () => const MessageView()),
    GetPage(name: AppRoutes.SETTINGS, page: () => const SettingView()),

    // Home Screens
    GetPage(
      name: AppRoutes.CARD_AND_ACCOUNT,
      page: () => const CardAndAccountView(),
    ),
    GetPage(name: AppRoutes.TRANSFER, page: () => const TransferView()),
    GetPage(name: AppRoutes.WITHDRAW, page: () => const WithdrawView()),
    GetPage(name: AppRoutes.PREPAID, page: () => const PrepaidView()),
    GetPage(name: AppRoutes.PAY_BILL, page: () => const PayBillView()),
    // Pay Bill Screen <->
    GetPage(name: AppRoutes.ELECTRIC_BILL, page: () => const PayBillView()),
    GetPage(name: AppRoutes.WATER_BILL, page: () => const PayBillView()),
    GetPage(name: AppRoutes.MOBILE_BILL, page: () => const PayBillView()),
    GetPage(name: AppRoutes.INTERNET_BILL, page: () => const PayBillView()),

    GetPage(name: AppRoutes.SAVE_ONLINE, page: () => const SaveOnlineView()),
    GetPage(name: AppRoutes.CREDIT_CARD, page: () => const CreditCardView()),
    GetPage(name: AppRoutes.TRANSACTION, page: () => const TransactionView()),
    GetPage(name: AppRoutes.BENEFICIARY, page: () => const BeneficiaryView()),
    GetPage(
      name: AppRoutes.CONFIRM_TRANSFER,
      page: () => const ConfirmTransferView(),
    ),

    // Search Screens
    GetPage(name: AppRoutes.BRANCH, page: () => const BranchView()),
    GetPage(
      name: AppRoutes.INTEREST_RATE,
      page: () => const InterestRateView(),
    ),
    GetPage(name: AppRoutes.EXCHANGE_RATE, page: () => const ExchageRateView()),
    GetPage(name: AppRoutes.EXCHANGE, page: () => const ExchageView()),

    // Success Screen
    GetPage(
      name: AppRoutes.TRANSFER_SUCCESS,
      page: () => const TransferSuccessView(),
    ),
    GetPage(
      name: AppRoutes.WITHDRAW_SUCCESS,
      page: () => const WithdrawSuccessView(),
    ),
    GetPage(
      name: AppRoutes.PREPAID_SUCCESS,
      page: () => const PrepaidSuccessView(),
    ),
  ];
}
