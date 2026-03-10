import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';

class HomeController extends GetxController {
  final List<Map<String, String>> menuItems = [
    {'icon': AppAssets.wallet, 'label': 'Wallet'},
    {'icon': AppAssets.transfer, 'label': 'Transfer'},
    {'icon': AppAssets.withdraw, 'label': 'Withdraw'},
    {'icon': AppAssets.prepain, 'label': 'Prepaid'},
    {'icon': AppAssets.payBill, 'label': 'Pay Bill'},
    {'icon': AppAssets.saveOnline, 'label': 'Save Online'},
    {'icon': AppAssets.creditCard, 'label': 'Credit Card'},
    {'icon': AppAssets.transaction, 'label': 'Transaction'},
    {'icon': AppAssets.beneficiary, 'label': 'Beneficiary'},
  ];
}
