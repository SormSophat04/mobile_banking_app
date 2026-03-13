import 'package:get/get.dart';
import 'package:mobile_banking_app/core/middleware/security_middleware.dart';
import 'package:mobile_banking_app/modules/auth/views/forgot_password_view.dart';
import 'package:mobile_banking_app/modules/auth/views/login_view.dart';
import 'package:mobile_banking_app/modules/auth/views/reset_password_view.dart';
import 'package:mobile_banking_app/modules/auth/views/reset_success_view.dart';
import 'package:mobile_banking_app/modules/auth/views/sing_up_view.dart';
import 'package:mobile_banking_app/modules/auth/views/verify_code_view.dart';
import 'package:mobile_banking_app/modules/home/views/beneficiary/add_user_beneficiary.dart';
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
import 'package:mobile_banking_app/modules/security/view/blocked_view.dart';
import 'package:mobile_banking_app/modules/setting/view/app_information/app_information_view.dart';
import 'package:mobile_banking_app/modules/setting/view/password/password_view.dart';
import 'package:mobile_banking_app/modules/setting/view/setting_view.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class AppPages {
  static final _securityMiddleware = SecurityMiddleware();

  static final routes = [
    GetPage(name: AppRoutes.SECURITY_BLOCKED, page: () => const BlockedView()),

    // Auth Screen
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.SIGN_UP,
      page: () => const SingUpView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.FORGOT_PASSWORD,
      page: () => const ForgotPasswordView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.VERIFY_CODE,
      page: () => const VerifyCodeView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.RESET_PASSWORD,
      page: () => const ResetPasswordView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.RESET_SUCCESS,
      page: () => const ResetSuccessView(),
      middlewares: [_securityMiddleware],
    ),

    // Main Layout
    GetPage(
      name: AppRoutes.MAIN_LAYOUT,
      page: () => MainLayoutView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomeView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.SEARCH,
      page: () => const SearchView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.MESSAGE,
      page: () => const MessageView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.SETTINGS,
      page: () => const SettingView(),
      middlewares: [_securityMiddleware],
    ),

    // Home Screens
    GetPage(
      name: AppRoutes.CARD_AND_ACCOUNT,
      page: () => const CardAndAccountView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.TRANSFER,
      page: () => const TransferView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.WITHDRAW,
      page: () => const WithdrawView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.PREPAID,
      page: () => const PrepaidView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.PAY_BILL,
      page: () => const PayBillView(),
      middlewares: [_securityMiddleware],
    ),
    // Pay Bill Screen <->
    GetPage(
      name: AppRoutes.ELECTRIC_BILL,
      page: () => const PayBillView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.WATER_BILL,
      page: () => const PayBillView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.MOBILE_BILL,
      page: () => const PayBillView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.INTERNET_BILL,
      page: () => const PayBillView(),
      middlewares: [_securityMiddleware],
    ),

    GetPage(
      name: AppRoutes.SAVE_ONLINE,
      page: () => const SaveOnlineView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.CREDIT_CARD,
      page: () => const CreditCardView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.TRANSACTION,
      page: () => const TransactionView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.BENEFICIARY,
      page: () => const BeneficiaryView(),
      middlewares: [_securityMiddleware],
    ),
    // Beneficaiary Screen
    GetPage(
      name: AppRoutes.ADD_USER_BENEFICIARY,
      page: () => const AddUserBeneficiary(),
      middlewares: [_securityMiddleware],
    ),

    GetPage(
      name: AppRoutes.CONFIRM_TRANSFER,
      page: () => const ConfirmTransferView(),
      middlewares: [_securityMiddleware],
    ),

    // Search Screens
    GetPage(
      name: AppRoutes.BRANCH,
      page: () => const BranchView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.INTEREST_RATE,
      page: () => const InterestRateView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.EXCHANGE_RATE,
      page: () => const ExchageRateView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.EXCHANGE,
      page: () => const ExchageView(),
      middlewares: [_securityMiddleware],
    ),

    // Setting Screen
    GetPage(
      name: AppRoutes.PASSWORD,
      page: () => const PasswordView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.SECURITY,
      page: () => const SettingView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.LANGUAGE,
      page: () => const SettingView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.APP_INFORMATION,
      page: () => const AppInformationView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.CUSTOMER_CARE,
      page: () => const SettingView(),
      middlewares: [_securityMiddleware],
    ),

    // Success Screen
    GetPage(
      name: AppRoutes.TRANSFER_SUCCESS,
      page: () => const TransferSuccessView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.WITHDRAW_SUCCESS,
      page: () => const WithdrawSuccessView(),
      middlewares: [_securityMiddleware],
    ),
    GetPage(
      name: AppRoutes.PREPAID_SUCCESS,
      page: () => const PrepaidSuccessView(),
      middlewares: [_securityMiddleware],
    ),
  ];
}
