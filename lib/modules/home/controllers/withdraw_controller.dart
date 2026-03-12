import 'package:flutter/material.dart';
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
  bool isFormValid = false;

  final TextEditingController accountController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController otherAmountController = TextEditingController();

  bool get isOtherSelected =>
      selectedIndex != null && amounts[selectedIndex!] == 'Other';

  @override
  void onInit() {
    super.onInit();
    accountController.addListener(_updateFormState);
    phoneController.addListener(_updateFormState);
    otherAmountController.addListener(_updateFormState);
  }

  @override
  void onClose() {
    accountController.dispose();
    phoneController.dispose();
    otherAmountController.dispose();
    super.onClose();
  }

  void selectAmount(int index) {
    if (index < 0 || index >= amounts.length) return;
    selectedIndex = index;
    _updateFormState(forceUpdate: true);
  }

  void _updateFormState({bool forceUpdate = false}) {
    final bool hasBase = accountController.text.trim().isNotEmpty &&
        phoneController.text.trim().isNotEmpty;

    bool next = false;
    if (hasBase) {
      if (isOtherSelected) {
        next = otherAmountController.text.trim().isNotEmpty;
      } else {
        next = selectedIndex != null;
      }
    }

    final bool changed = next != isFormValid;
    if (changed) {
      isFormValid = next;
    }
    if (forceUpdate || changed) {
      update();
    }
  }
}
