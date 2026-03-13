import 'package:get/get.dart';

class TransactionController extends GetxController {
  final RxBool isLoading = false.obs;

  final List<Map<String, String>> transactions = [
    {
      'title': 'Wather Bill',
      'subtitle': 'Successfully',
      'amount': '-\$100',
      'icon': 'assets/images/Icon.png',
    },
    {
      'title': 'Income: Salary Oct',
      // 'subtitle': 'Unsuccessfully',
      'amount': '+\$3,000',
      'icon': 'assets/images/Icon-1.png',
    },
    {
      'title': 'Electric Bill',
      'subtitle': 'Successfully',
      'amount': '-\$200',
      'icon': 'assets/images/Icon-2.png',
    },
    {
      'title': 'Income : Jane transfers',
      // 'subtitle': 'Unsuccessfully',
      'amount': '+\$2,000',
      'icon': 'assets/images/Icon-3.png',
    },
    {
      'title': 'Internet Bill',
      'subtitle': 'Successfully',
      'amount': '-\$70',
      'icon': 'assets/images/Icon-4.png',
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadTransactions();
  }

  Future<void> _loadTransactions() async {
    isLoading.value = true;
    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 1));
    } finally {
      isLoading.value = false;
    }
  }

  void refreshTransactions() {
    _loadTransactions();
  }
}
