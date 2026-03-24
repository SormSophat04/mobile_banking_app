import 'package:get/get.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';

class SettingController extends GetxController {
  String customerName = 'Username';
  
  @override
  void onInit() {
    super.onInit();
    _loadCustomerName();
  }

  Future<void> _loadCustomerName() async {
    final client = Get.put(ApiClient());
    final name = await client.getCustomerName();
    if (name != null && name.isNotEmpty) {
      customerName = name;
      update();
    }
  }

  final List<Map<String, String>> settingsItems = [
    {'title': 'Verify Profile', 'route': AppRoutes.VERIFY_PROFILE},
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
