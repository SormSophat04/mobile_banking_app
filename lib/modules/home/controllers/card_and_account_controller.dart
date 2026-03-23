import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';

class CardAndAccountController extends GetxController {
  final ApiClient apiClient = Get.put(ApiClient());
  late final PageController pageController;
  int currentIndex = 0;
  
  List<AccountModel> accounts = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void onInit() {
    super.onInit();
    pageController = PageController(initialPage: currentIndex);
    fetchAccounts();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onTabSelected(int index) {
    if (index == currentIndex) return;
    currentIndex = index;
    update();
    pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void onPageChanged(int index) {
    if (index == currentIndex) return;
    currentIndex = index;
    update();
  }

  Future<void> fetchAccounts() async {
    isLoading = true;
    errorMessage = '';
    update();

    try {
      final customerId = await apiClient.getCustomerId();
      if (customerId == null) {
        isLoading = false;
        errorMessage = 'Notice: Customer ID missing in cache. The JWT token might not contain it, or it was not saved during login.';
        update();
        return;
      }

      final response = await apiClient.getAccount(customerId);
      if (response.isOk && response.body != null) {
        var data = response.body;
        
        // If the server didn't set Content-Type correctly, GetConnect might return a String
        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {}
        }
        
        if (data is List) {
          accounts = data.map((e) => AccountModel.fromJson(e)).toList();
        } else if (data is Map<String, dynamic>) {
          accounts = [AccountModel.fromJson(data)];
        } else {
          errorMessage = 'Unrecognized JSON type: ${data.runtimeType}';
        }
      } else {
        errorMessage = 'API Error ${response.statusCode}: ${response.bodyString}';
      }
    } catch (e) {
      debugPrint("Error fetching accounts: $e");
      errorMessage = 'Parse Error: $e';
    } finally {
      isLoading = false;
      update();
    }
  }
}
