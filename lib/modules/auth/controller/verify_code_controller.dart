import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyCodeController extends GetxController {
  final TextEditingController codeController = TextEditingController();
  bool isFormValid = false;

  @override
  void onInit() {
    super.onInit();
    codeController.addListener(_updateFormState);
  }

  @override
  void onClose() {
    codeController.dispose();
    super.onClose();
  }

  void _updateFormState() {
    final bool next = codeController.text.trim().isNotEmpty;
    if (next != isFormValid) {
      isFormValid = next;
      update();
    }
  }
}
