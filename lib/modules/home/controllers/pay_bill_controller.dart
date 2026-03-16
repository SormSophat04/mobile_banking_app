import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class PayBillController extends GetxController {
  final List<Map<String, dynamic>> bills = [
    {
      'title': 'Electric Bill',
      'subtitle': 'Pay electric bill this month',
      'icon': AppAssets.electricBill,
      'route': AppRoutes.PAY_SEARCH_CODE,
      'status': 'electric',
    },
    {
      'title': 'Water Bill',
      'subtitle': 'Pay water bill this month',
      'icon': AppAssets.watherBill,
      'route': AppRoutes.PAY_SEARCH_CODE,
      'status': 'water',
    },
    {
      'title': 'Mobile Bill',
      'subtitle': 'Pay mobile bill this month',
      'icon': AppAssets.mobileBill,
      'route': AppRoutes.PAY_SEARCH_CODE,
      'status': 'mobile',
    },
    {
      'title': 'Internet Bill',
      'subtitle': 'Pay internet bill this month',
      'icon': AppAssets.internetBill,
      'route': AppRoutes.PAY_SEARCH_CODE,
      'status': 'internet',
    },
  ];
}
