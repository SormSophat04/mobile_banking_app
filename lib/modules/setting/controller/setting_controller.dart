import 'package:get/get.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class SettingController extends GetxController {
  final List<Map<String, String>> settingsItems = [
    {'title': 'Password', 'route': AppRoutes.PASSWORD},
    {'title': 'Security', 'route': AppRoutes.SECURITY},
    {'title': 'Language', 'route': AppRoutes.LANGUAGE},
    {'title': 'App information', 'route': AppRoutes.APP_INFORMATION},
    {'title': 'Customer care', 'route': AppRoutes.CUSTOMER_CARE},
  ].obs;

  final List<Map<String, String>> appInformationItems = [
    {'title': 'Date of manufacture', 'value': 'Nov 1999'},
    {'title': 'Version', 'value': '1.0.0'},
    {'title': 'Langauge', 'value': 'English'},
  ].obs;
}
