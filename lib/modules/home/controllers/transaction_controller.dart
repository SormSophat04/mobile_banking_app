import 'dart:convert';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';
import 'package:mobile_banking_app/core/network/models/transaction_model.dart';

class TransactionController extends GetxController {
  final ApiClient apiClient = Get.find<ApiClient>();

  AccountModel? account;
  List<TransactionModel> transactions = [];
  bool isLoading = false;
  String errorMessage = '';

  @override
  void onInit() {
    super.onInit();
    // Receive the AccountModel passed via Get.toNamed arguments
    if (Get.arguments != null && Get.arguments is AccountModel) {
      account = Get.arguments as AccountModel;
    }
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    if (account?.accountId == null) {
      errorMessage = 'No account selected.';
      update();
      return;
    }

    isLoading = true;
    errorMessage = '';
    update();

    try {
      final response =
          await apiClient.getTransactions(account!.accountId!.toString());

      if (response.isOk && response.body != null) {
        var data = response.body;

        if (data is String) {
          try {
            data = jsonDecode(data);
          } catch (_) {}
        }

        if (data is List) {
          transactions =
              data.map((e) => TransactionModel.fromJson(e)).toList();
        } else if (data is Map<String, dynamic>) {
          // Handle paginated response e.g. { "content": [...] }
          if (data['content'] is List) {
            transactions = (data['content'] as List)
                .map((e) => TransactionModel.fromJson(e))
                .toList();
          } else {
            transactions = [TransactionModel.fromJson(data)];
          }
        } else {
          errorMessage = 'Unrecognized response format.';
        }

        // Sort: most recent date first
        transactions.sort((a, b) {
          final da = DateTime.tryParse(a.createAt ?? '') ?? DateTime(0);
          final db = DateTime.tryParse(b.createAt ?? '') ?? DateTime(0);
          return db.compareTo(da);
        });
      } else {
        errorMessage =
            'Failed to load transactions (${response.statusCode}).';
      }
    } catch (e) {
      errorMessage = 'Error: $e';
    } finally {
      isLoading = false;
      update();
    }
  }

  void refreshTransactions() {
    fetchTransactions();
  }
}
