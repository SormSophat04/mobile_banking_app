import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class VerifyProfileController extends GetxController {
  final ApiClient apiClient = Get.put(ApiClient());
  
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController nationalIdController = TextEditingController();
  final TextEditingController birthDateController = TextEditingController();
  
  bool isFormValid = false;
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    firstNameController.addListener(_updateFormState);
    lastNameController.addListener(_updateFormState);
    nationalIdController.addListener(_updateFormState);
    birthDateController.addListener(_updateFormState);
  }

  @override
  void onClose() {
    firstNameController.dispose();
    lastNameController.dispose();
    nationalIdController.dispose();
    birthDateController.dispose();
    super.onClose();
  }

  void _updateFormState() {
    final bool next = firstNameController.text.trim().isNotEmpty &&
        lastNameController.text.trim().isNotEmpty &&
        nationalIdController.text.trim().isNotEmpty &&
        birthDateController.text.trim().isNotEmpty;

    if (next != isFormValid) {
      isFormValid = next;
      update();
    }
  }

  Future<void> submit() async {
    if (!isFormValid) return;
    
    isLoading = true;
    update();

    try {
      final response = await apiClient.verifyProfile(
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        nationalIdController.text.trim(),
        birthDateController.text.trim(),
      );

      if (response.isOk) {
        Get.snackbar('Success', 'Profile verified successfully');
        Get.offNamed(AppRoutes.MAIN_LAYOUT);
      } else {
        Get.snackbar('Error', response.body?['message'] ?? 'Failed to verify profile');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred');
    } finally {
      isLoading = false;
      update();
    }
  }
}
