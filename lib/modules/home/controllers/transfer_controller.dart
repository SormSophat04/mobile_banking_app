import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';
import 'package:mobile_banking_app/core/network/models/transaction_model.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class TransferController extends GetxController {
  List<AccountModel> accounts = [];
  AccountModel? selectedAccountModel;
  bool isLoadingAccounts = false;
  bool isTransferring = false;
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
    fetchAccounts();
  }

  Future<void> fetchAccounts() async {
    isLoadingAccounts = true;
    update();
    try {
      final ApiClient apiClient = Get.put(ApiClient());
      final customerId = await apiClient.getCustomerId();
      if (customerId != null) {
        final response = await apiClient.getAccount(customerId);
        if (response.isOk && response.body != null) {
          var data = response.body;
          if (data is String) {
            try {
              data = jsonDecode(data);
            } catch (_) {}
          }
          if (data is List) {
            accounts = data.map((e) => AccountModel.fromJson(e)).toList();
          } else if (data is Map<String, dynamic>) {
            accounts = [AccountModel.fromJson(data)];
          }
        }
      }
    } catch (e) {
      debugPrint('Error fetching accounts for transfer: $e');
    } finally {
      isLoadingAccounts = false;
      update();
    }
  }

  void selectAccount(AccountModel account) {
    if (account.accountNumber != null) {
      selectedAccountModel = account;
      accountController.text =
          '${account.accountType ?? "Account"} - ${account.currency ?? "\$"}${account.balance?.toStringAsFixed(2) ?? "0.00"}';
      update();
    }
  }

  Future<void> submitTransfer() async {
    isTransferring = true;
    update();
    try {
      final ApiClient apiClient = Get.find<ApiClient>();

      final fromAccountNumber = selectedAccountModel?.accountNumber?.trim();
      if (fromAccountNumber == null || fromAccountNumber.isEmpty) {
        Get.snackbar('Transfer Failed', 'Please choose a source account first.');
        return;
      }

      final amount = double.tryParse(amountController.text.trim()) ?? 0.0;
      final toAccountNumber = cardNumberController.text
          .replaceAll(RegExp(r'\s+'), '')
          .trim();
      if (toAccountNumber.isEmpty) {
        Get.snackbar('Transfer Failed', 'Please enter the receiver account number.');
        return;
      }

      final response = await apiClient.post('transactions/transfer', {
        "fromAccountNumber": fromAccountNumber,
        "toAccountNumber": toAccountNumber,
        "amount": amount,
        "description": contentController.text.trim(),
      });

      if (response.isOk) {
        Get.snackbar('Success', 'Transfer completed successfully');

        // Extract transaction from the response
        final responseData = response.body;
        TransactionModel? transaction;
        String transactionId = '';
        if (responseData is String) {
          try {
            final decoded = jsonDecode(responseData);
            transaction = TransactionModel.fromJson(decoded);
            transactionId = transaction.transactionId?.toString() ?? decoded['id']?.toString() ?? '';
          } catch (_) {}
        } else if (responseData is Map<String, dynamic>) {
          transaction = TransactionModel.fromJson(responseData);
          transactionId = transaction.transactionId?.toString() ?? responseData['id']?.toString() ?? '';
        }

        // Ask backend to notify the receiver.
        // Backend looks up stored FCM token for this account number.
        try {
          final pushResponse = await apiClient.sendPushNotification(
            toAccountNumber: toAccountNumber,
            title:
                'Money Received From ${selectedAccountModel?.customer?.firstName} ${selectedAccountModel?.customer?.lastName}',
            body:
                'You received ${selectedAccountModel?.currency ?? "\$"}$amount from ${selectedAccountModel?.accountNumber ?? "your account"}.',
            data: {
              'type': 'transfer',
              'transactionId': transactionId,
              'toAccountNumber': toAccountNumber,
            },
          );
          if (!pushResponse.isOk) {
            debugPrint(
              'Transfer succeeded but push dispatch failed: ${pushResponse.statusCode} ${pushResponse.bodyString}',
            );
            Get.snackbar(
              'Transfer Completed',
              'Money sent, but push notification could not be delivered.',
            );
          }
        } catch (e) {
          debugPrint('Transfer succeeded but push dispatch threw error: $e');
          Get.snackbar(
            'Transfer Completed',
            'Money sent, but push notification could not be delivered.',
          );
        }

        Get.offAllNamed(AppRoutes.TRANSFER_SUCCESS, arguments: transaction);
      } else {
        Get.snackbar('Transfer Failed', response.bodyString ?? 'Unknown error');
      }
    } catch (e) {
      Get.snackbar('Error', 'Transfer resulted in an error.');
    } finally {
      isTransferring = false;
      update();
    }
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
        cardNumberController.text.trim().isNotEmpty &&
        amountController.text.trim().isNotEmpty &&
        contentController.text.trim().isNotEmpty;

    if (next != isFormValid) {
      isFormValid = next;
      update();
    }
  }
}
