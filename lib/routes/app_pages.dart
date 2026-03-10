import 'package:get/get.dart';
import 'package:mobile_banking_app/modules/auth/views/forgot_password_view.dart';
import 'package:mobile_banking_app/modules/auth/views/login_view.dart';
import 'package:mobile_banking_app/modules/auth/views/reset_password_view.dart';
import 'package:mobile_banking_app/modules/auth/views/reset_success_view.dart';
import 'package:mobile_banking_app/modules/auth/views/sing_up_view.dart';
import 'package:mobile_banking_app/modules/auth/views/verify_code_view.dart';
import 'package:mobile_banking_app/modules/home/views/home_view.dart';
import 'package:mobile_banking_app/modules/main_layout/view/main_layout_view.dart';
import 'package:mobile_banking_app/modules/search/view/search_view.dart';
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
    GetPage(name: AppRoutes.HOME, page: () => HomeView()),
    GetPage(name: AppRoutes.SEARCH, page: () => SearchView()),
    // GetPage(name: AppRoutes.MESSAGE, page: () => MainLayoutView()),
    // GetPage(name: AppRoutes.SETTINGS, page: () => MainLayoutView()),
  ];
}
