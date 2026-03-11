import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class SearchMenuController extends GetxController {
  final RxList<Map<String, String>> cardItems = <Map<String, String>>[
    {
      'title': 'Branch',
      'subtitle': 'Search for branch',
      'image': AppAssets.searchBrand,
      'route': AppRoutes.BRANCH,
    },
    {
      'title': 'Interest rate',
      'subtitle': 'Search for interest rate',
      'image': AppAssets.searchInterestRate,
      'route': AppRoutes.INTEREST_RATE,
    },
    {
      'title': 'Exchange rate',
      'subtitle': 'Search for exchange rate',
      'image': AppAssets.searchExchangeRate,
      'route': AppRoutes.EXCHANGE_RATE,
    },
    {
      'title': 'Exchange',
      'subtitle': 'Exchange amount of money',
      'image': AppAssets.searchExchange,
      'route': AppRoutes.EXCHANGE,
    },
  ].obs;
}
