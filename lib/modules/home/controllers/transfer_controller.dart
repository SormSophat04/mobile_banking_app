import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';
import 'package:mobile_banking_app/core/network/models/transaction_model.dart';
import 'package:mobile_banking_app/routes/app_routes.dart';

class TransferController extends GetxController {
  final ApiClient _api = Get.put(ApiClient());
  final accounts = <AccountModel>[].obs;
  final selectedAccount = Rxn<AccountModel>();
  bool isLoadingAccounts = false, isTransferring = false, saveToBeneficiary = false, isFormValid = false;

  final accountController = TextEditingController(), cardNumberController = TextEditingController(), amountController = TextEditingController(), contentController = TextEditingController();

  List<TextEditingController> get _controllers => [accountController, cardNumberController, amountController, contentController];

  @override
  void onInit() {
    super.onInit();
    for (var c in _controllers) { c.addListener(_updateFormState); }
    fetchAccounts();
  }

  @override
  void onClose() {
    for (var c in _controllers) { c.dispose(); }
    super.onClose();
  }

  Future<void> fetchAccounts() async {
    isLoadingAccounts = true; update();
    try {
      final id = await _api.getCustomerId();
      if (id == null) return;
      final res = await _api.getAccount(id);
      if (res.isOk) accounts.assignAll(_parseAccounts(res.body));
    } finally { isLoadingAccounts = false; update(); }
  }

  void selectAccount(AccountModel acc) {
    selectedAccount.value = acc;
    accountController.text = '${acc.accountType ?? "Account"} - ${acc.currency ?? "\$"}${acc.balance?.toStringAsFixed(2) ?? "0.00"}';
  }

  bool applyScannedQr(String payload) {
    final Map<String, dynamic> data = (payload.trim().startsWith('{')) ? jsonDecode(payload) : {'accountNumber': payload.trim()};
    final acc = data['accountNumber']?.toString().replaceAll(RegExp(r'\s+'), '');
    if (acc != null && acc.isNotEmpty) { cardNumberController.text = acc; return true; }
    return false;
  }

  Future<void> submitTransfer() async {
    if (!_validate()) return;
    isTransferring = true; update();
    try {
      final to = cardNumberController.text.replaceAll(RegExp(r'\s+'), '').trim();
      final amt = double.parse(amountController.text.trim());
      final res = await _api.post('transactions/transfer', {"fromAccountNumber": selectedAccount.value!.accountNumber, "toAccountNumber": to, "amount": amt, "description": contentController.text.trim()});

      if (res.isOk) {
        final tx = _parseTx(res.body);
        Get.offAllNamed(AppRoutes.TRANSFER_SUCCESS, arguments: tx);
        _notify(tx, to, amt).catchError((e) => debugPrint('Push failed: $e'));
      } else {
        Get.snackbar('Error', res.bodyString ?? 'Transfer failed');
      }
    } finally { isTransferring = false; update(); }
  }

  bool _validate() {
    if (selectedAccount.value == null) { Get.snackbar('Error', 'Choose source account'); return false; }
    if (cardNumberController.text.isEmpty) { Get.snackbar('Error', 'Enter receiver account'); return false; }
    if ((double.tryParse(amountController.text) ?? 0) <= 0) { Get.snackbar('Error', 'Invalid amount'); return false; }
    return true;
  }

  Future<void> _notify(TransactionModel? tx, String to, double amt) async {
    final from = selectedAccount.value!.accountNumber!;
    final name = (await _api.getCustomerName()) ?? from;
    final curr = selectedAccount.value?.currency ?? '\$';

    await _api.sendPushNotification(
      toAccountNumber: to,
      title: 'Money Received From $name',
      body: 'You received $curr${amt.toStringAsFixed(2)} from $from.',
      data: {
        'type': 'transfer', 'toAccountNumber': to, 'amount': amt.toString(), 'currency': curr,
        'fromAccountNumber': from, 'senderDisplayName': name, 'status': 'SUCCESS',
        if (tx?.transactionId != null) 'transactionId': tx!.transactionId.toString(),
      },
    );
  }

  List<AccountModel> _parseAccounts(dynamic body) {
    final data = body is String ? jsonDecode(body) : body;
    if (data is List) return data.map((e) => AccountModel.fromJson(e)).toList();
    if (data is Map<String, dynamic>) return [AccountModel.fromJson(data)];
    return [];
  }

  TransactionModel? _parseTx(dynamic body) {
    final data = (body is String ? jsonDecode(body) : body) as Map<String, dynamic>?;
    if (data == null) return null;
    final tx = data['transaction'] ?? data['data'] ?? data;
    return (tx is Map<String, dynamic>) ? TransactionModel.fromJson(tx) : null;
  }

  void toggleSaveToBeneficiary() { saveToBeneficiary = !saveToBeneficiary; update(); }
  void _updateFormState() {
    final valid = _controllers.every((c) => c.text.trim().isNotEmpty);
    if (valid != isFormValid) { isFormValid = valid; update(); }
  }
}
