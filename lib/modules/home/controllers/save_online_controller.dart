import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class SaveOnlineController extends GetxController {
  final List<Map<String, dynamic>> saveOnline = [
    {
      'title': 'Add',
      'subtitle': 'Add new save online account',
      'icon': AppAssets.electricBill,
      'route': AppRoutes.ELECTRIC_BILL,
    },
    {
      'title': 'Management',
      'subtitle': 'Manage your save online account',
      'icon': AppAssets.watherBill,
      'route': AppRoutes.WATER_BILL,
    },
  ];
}
