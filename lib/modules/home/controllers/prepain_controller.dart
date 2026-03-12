import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class PrepainController extends GetxController {
  final accountController = TextEditingController();
  final phoneController = TextEditingController();
  final otherAmountController = TextEditingController();

  int? selectedPrepaidIndex;
  int? selectedBeneficiaryIndex;
  int? selectedIndex;
  bool saveToBeneficiary = false;
  bool isFormValid = false;

  final List<String> amounts = const [
    '\$10',
    '\$50',
    '\$100',
    '\$150',
    '\$200',
    'Other',
  ];

  bool get isOtherSelected =>
      selectedIndex != null && amounts[selectedIndex!] == 'Other';

  @override
  void onInit() {
    super.onInit();
    accountController.addListener(_validateForm);
    phoneController.addListener(_validateForm);
    otherAmountController.addListener(_validateForm);
  }

  void selectAmount(int index) {
    if (index < 0 || index >= amounts.length) return;
    selectedIndex = index;
    _validateForm();
  }

  void _validateForm() {
    bool isValid =
        accountController.text.isNotEmpty && phoneController.text.isNotEmpty;

    if (isOtherSelected) {
      isValid = isValid && otherAmountController.text.isNotEmpty;
    }

    isFormValid = isValid;
    update();
  }

  @override
  void onClose() {
    accountController.dispose();
    phoneController.dispose();
    otherAmountController.dispose();
    super.onClose();
  }

  void selectPrepaid(int index) {
    if (selectedPrepaidIndex != index) {
      selectedPrepaidIndex = index;
      update();
    }
  }

  void selectBeneficiary(int index) {
    if (selectedBeneficiaryIndex != index) {
      selectedBeneficiaryIndex = index;
      update();
    }
  }
}
