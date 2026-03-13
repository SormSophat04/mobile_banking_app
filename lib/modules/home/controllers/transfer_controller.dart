import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransferController extends GetxController {
  int? selectedTransactionIndex;
  int? selectedBeneficiaryIndex;
  bool saveToBeneficiary = false;
  bool isFormValid = false;

  final TextEditingController accountController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final List<Map<String, String>> transactionTypes = [
    {'title': 'Transfer via card number', 'icon': 'assets/icons/34.png'},
    {'title': 'Transfer to the same bank', 'icon': 'assets/icons/09.png'},
    {'title': 'Transfer to another bank', 'icon': 'assets/icons/33.png'},
  ];

  @override
  void onInit() {
    super.onInit();
    accountController.addListener(_updateFormState);
    nameController.addListener(_updateFormState);
    cardNumberController.addListener(_updateFormState);
    amountController.addListener(_updateFormState);
    contentController.addListener(_updateFormState);
  }

  @override
  void onClose() {
    accountController.dispose();
    nameController.dispose();
    cardNumberController.dispose();
    amountController.dispose();
    contentController.dispose();
    super.onClose();
  }

  void selectTransaction(int index) {
    if (selectedTransactionIndex != index) {
      selectedTransactionIndex = index;
      update();
    }
  }

  void selectBeneficiary(int index) {
    if (selectedBeneficiaryIndex != index) {
      selectedBeneficiaryIndex = index;
      update();
    }
  }

  void toggleSaveToBeneficiary() {
    saveToBeneficiary = !saveToBeneficiary;
    update();
  }

  void _updateFormState() {
    final bool next =
        accountController.text.trim().isNotEmpty &&
        nameController.text.trim().isNotEmpty &&
        cardNumberController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty &&
        contentController.text.trim().isNotEmpty;

    if (next != isFormValid) {
      isFormValid = next;
      update();
    }
  }
}
