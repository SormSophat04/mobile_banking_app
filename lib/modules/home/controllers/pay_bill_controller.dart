import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class PayBillController extends GetxController {
  final List<Map<String, dynamic>> bills = [
    {
      'title': 'Electric Bill',
      'subtitle': 'Pay electric bill this month',
      'icon': AppAssets.electricBill,
      'route': AppRoutes.ELECTRIC_BILL,
    },
    {
      'title': 'Water Bill',
      'subtitle': 'Pay water bill this month',
      'icon': AppAssets.watherBill,
      'route': AppRoutes.WATER_BILL,
    },
    {
      'title': 'Mobile Bill',
      'subtitle': 'Pay mobile bill this month',
      'icon': AppAssets.mobileBill,
      'route': AppRoutes.MOBILE_BILL,
    },
    {
      'title': 'Internet Bill',
      'subtitle': 'Pay internet bill this month',
      'icon': AppAssets.internetBill,
      'route': AppRoutes.INTERNET_BILL,
    },
  ];
}
