import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/constants/app_assets.dart';
import 'package:mobile_banking_app/modules/branch/view/branch_view.dart';
import 'package:mobile_banking_app/modules/exchage/view/exchage_view.dart';
import 'package:mobile_banking_app/modules/exchange_rate/view/exchage_rate_view.dart';
import 'package:mobile_banking_app/modules/interest_rate/view/interest_rate.dart';

class SearchMenuController extends GetxController {
  final List<Widget> page = [
    const BranchView(),
    const InterestRate(),
    const ExchageRateView(),
    const ExchageView(),
  ].obs;

  final RxList<Map<String, String>> cardItems = <Map<String, String>>[
    {
      'title': 'Branch',
      'subtitle': 'Search for branch',
      'image': AppAssets.searchBrand,
    },
    {
      'title': 'Interest rate',
      'subtitle': 'Search for interest rate',
      'image': AppAssets.searchInterestRate,
    },
    {
      'title': 'Exchange rate',
      'subtitle': 'Search for exchange rate',
      'image': AppAssets.searchExchangeRate,
    },
    {
      'title': 'Exchange',
      'subtitle': 'Exchange amount of money',
      'image': AppAssets.searchExchange,
    },
  ].obs;
}
