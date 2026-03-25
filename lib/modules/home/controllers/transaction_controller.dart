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

      if (response.isOk) {
        if (response.statusCode == 204) {
          transactions = [];
          return;
        }

        final parsed = _parseTransactionsFromResponse(response.body);
        if (parsed.recognized) {
          transactions = parsed.items;
        } else {
          final fromBodyString = _parseTransactionsFromResponse(
            response.bodyString,
          );
          if (fromBodyString.recognized) {
            transactions = fromBodyString.items;
          } else {
            errorMessage = 'No transactions found in response.';
          }
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

  _ParsedTransactions _parseTransactionsFromResponse(dynamic source) {
    dynamic data = source;

    if (data == null) return const _ParsedTransactions([], false);

    if (data is String) {
      try {
        data = jsonDecode(data);
      } catch (_) {
        return const _ParsedTransactions([], false);
      }
    }

    if (data is List) {
      final items = data
          .whereType<Map>()
          .map(
            (e) => TransactionModel.fromJson(
              e.map((k, v) => MapEntry(k.toString(), v)),
            ),
          )
          .toList();
      return _ParsedTransactions(items, true);
    }

    if (data is Map<String, dynamic>) {
      final nestedList = _firstList([
        data['content'],
        data['data'],
        data['transactions'],
        data['items'],
        data['result'],
      ]);

      if (nestedList != null) {
        final items = nestedList
            .whereType<Map>()
            .map(
              (e) => TransactionModel.fromJson(
                e.map((k, v) => MapEntry(k.toString(), v)),
              ),
            )
            .toList();
        return _ParsedTransactions(items, true);
      }

      final nestedMap = _firstMap([
        data['data'],
        data['result'],
        data['transaction'],
      ]);

      if (nestedMap != null) {
        return _parseTransactionsFromResponse(
          nestedMap.map((k, v) => MapEntry(k.toString(), v)),
        );
      }

      // Single transaction object response.
      return _ParsedTransactions([TransactionModel.fromJson(data)], true);
    }

    if (data is Map) {
      return _parseTransactionsFromResponse(
        data.map((k, v) => MapEntry(k.toString(), v)),
      );
    }

    return const _ParsedTransactions([], false);
  }

  List<dynamic>? _firstList(List<dynamic> candidates) {
    for (final item in candidates) {
      if (item is List) return item;
    }
    return null;
  }

  Map<dynamic, dynamic>? _firstMap(List<dynamic> candidates) {
    for (final item in candidates) {
      if (item is Map) return item;
    }
    return null;
  }
}

class _ParsedTransactions {
  final List<TransactionModel> items;
  final bool recognized;

  const _ParsedTransactions(this.items, this.recognized);
}
