import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';
import 'dart:convert';

class QrPaymentController extends GetxController {
  final ApiClient _apiClient = Get.find<ApiClient>();

  final accountController = TextEditingController();
  final amountController = TextEditingController();
  final remarkController = TextEditingController();

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isSubmitting = false.obs;
  bool get isSubmitting => _isSubmitting.value;

  final accounts = <AccountModel>[].obs;
  final selectedAccount = Rxn<AccountModel>();

  // Recipient details from QR
  final recipientName = ''.obs;
  final recipientAccountNumber = ''.obs;

  @override
  void onInit() {
    super.onInit();
    amountController.addListener(_updateFormValidState);
    fetchAccounts();
    parseQrData();
  }

  void _updateFormValidState() {
    update(); // Rebuild UI to update "Pay Now" button state
  }

  void parseQrData() {
    final payload = Get.arguments;
    String? qrString;
    if (payload is String) {
      qrString = payload;
    } else if (payload is Map && payload.containsKey('payload')) {
      qrString = payload['payload'];
    }

    if (qrString == null || qrString.isEmpty) return;

    // 1. Try JSON
    try {
      if (qrString.trim().startsWith('{')) {
        final data = jsonDecode(qrString);
        recipientAccountNumber.value = data['accountNumber']?.toString() ?? '';
        recipientName.value = data['accountName']?.toString() ?? 'Unknown Recipient';
        if (data['amount'] != null) amountController.text = data['amount'].toString();
        return;
      }
    } catch (_) {}

    // 2. Try KHQR/EMVCo
    final accMatch = RegExp(r'29\d{2}00\d{2}[\w\d]+01(\d{2})(\d+)').firstMatch(qrString);
    if (accMatch != null) {
      recipientAccountNumber.value = accMatch.group(2) ?? '';
      recipientName.value = 'KHQR Recipient';
      // Amount (Tag 54)
      final amtMatch = RegExp(r'54(\d{2})(\d+\.?\d*)').firstMatch(qrString);
      if (amtMatch != null) amountController.text = amtMatch.group(2) ?? '';
      return;
    }

    // 3. Fallback
    recipientAccountNumber.value = qrString.trim();
    recipientName.value = 'Recipient';
  }

  Future<void> fetchAccounts() async {
    _isLoading.value = true;
    try {
      final customerId = await _apiClient.getCustomerId();
      if (customerId == null) return;
      
      final response = await _apiClient.getAccount(customerId);
      if (response.isOk && response.body != null) {
        final data = response.body is String ? jsonDecode(response.body) : response.body;
        if (data is List) {
          accounts.value = data.map((e) => AccountModel.fromJson(e)).toList();
        } else if (data is Map<String, dynamic>) {
          accounts.value = [AccountModel.fromJson(data)];
        }
        
        if (accounts.isNotEmpty) {
          selectAccount(accounts.first);
        }
      }
    } catch (e) {
      print('Error fetching accounts: $e');
    } finally {
      _isLoading.value = false;
    }
  }

  void selectAccount(AccountModel account) {
    selectedAccount.value = account;
    accountController.text = '${account.accountType} (${account.accountNumber})';
  }

  bool get isFormValid =>
      selectedAccount.value != null &&
      amountController.text.isNotEmpty &&
      recipientAccountNumber.value.isNotEmpty;

  Future<void> submitPayment() async {
    if (!isFormValid) return;

    _isSubmitting.value = true;
    try {
      final from = selectedAccount.value!.accountNumber!;
      final to = recipientAccountNumber.value;
      final amt = double.parse(amountController.text);
      final desc = remarkController.text.trim();

      final res = await _apiClient.post('transactions/transfer', {
        "fromAccountNumber": from,
        "toAccountNumber": to,
        "amount": amt,
        "description": desc,
      });

      if (res.isOk) {
        Get.back(); // Go back to Home
        Get.snackbar('Success', 'Payment of \$${amt.toStringAsFixed(2)} to $to successful!', snackPosition: SnackPosition.BOTTOM);
        
        // Optional: Send push notification
        _notify(to, amt, from).catchError((e) => print('Push notification failed: $e'));
      } else {
        Get.snackbar('Error', res.bodyString ?? 'Payment failed', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      _isSubmitting.value = false;
    }
  }

  Future<void> _notify(String to, double amt, String from) async {
    final name = (await _apiClient.getCustomerName()) ?? from;
    final curr = selectedAccount.value?.currency ?? '\$';

    await _apiClient.sendPushNotification(
      toAccountNumber: to,
      title: 'Money Received From $name',
      body: 'You received $curr${amt.toStringAsFixed(2)} from $from.',
      data: {
        'type': 'transfer',
        'toAccountNumber': to,
        'amount': amt.toString(),
        'currency': curr,
        'fromAccountNumber': from,
        'senderDisplayName': name,
        'status': 'SUCCESS',
      },
    );
  }
}
