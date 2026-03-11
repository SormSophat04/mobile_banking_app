import 'package:get/get.dart';

class WithdrawController extends GetxController {
  final List<String> amounts = const [
    '\$10',
    '\$50',
    '\$100',
    '\$150',
    '\$200',
    'Other',
  ];

  int? selectedIndex;

  bool get isOtherSelected =>
      selectedIndex != null && amounts[selectedIndex!] == 'Other';

  void selectAmount(int index) {
    if (index < 0 || index >= amounts.length) return;
    selectedIndex = index;
    update();
  }
}
