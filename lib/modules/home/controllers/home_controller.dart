import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class HomeController extends GetxController {
  final List<Map<String, String>> menuItems = [
    {
      'icon': AppAssets.wallet,
      'label': 'Wallet',
      'route': AppRoutes.CARD_AND_ACCOUNT,
    },
    {
      'icon': AppAssets.transfer,
      'label': 'Transfer',
      'route': AppRoutes.TRANSFER,
    },
    {
      'icon': AppAssets.withdraw,
      'label': 'Withdraw',
      'route': AppRoutes.WITHDRAW,
    },
    {
      'icon': AppAssets.prepain,
      'label': 'Prepaid',
      'route': AppRoutes.PREPAID,
    },
    {
      'icon': AppAssets.payBill,
      'label': 'Pay Bill',
      'route': AppRoutes.PAY_BILL,
    },
    {
      'icon': AppAssets.saveOnline,
      'label': 'Save Online',
      'route': AppRoutes.SAVE_ONLINE,
    },
    {
      'icon': AppAssets.creditCard,
      'label': 'Credit Card',
      'route': AppRoutes.CREDIT_CARD,
    },
    {
      'icon': AppAssets.transaction,
      'label': 'Transaction',
      'route': AppRoutes.TRANSACTION,
    },
    {
      'icon': AppAssets.beneficiary,
      'label': 'Beneficiary',
      'route': AppRoutes.BENEFICIARY,
    },
  ];
}
