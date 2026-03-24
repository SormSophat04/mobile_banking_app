import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';
import 'package:mobile_banking_app/core/network/models/bank_card_model.dart';

class CardAndAccountController extends GetxController {
  final ApiClient apiClient = Get.put(ApiClient());
  late final PageController pageController;
  int currentIndex = 0;
  
  List<AccountModel> accounts = [];
  List<BankCardModel> cards = [];
  bool isLoading = true;
  bool isLoadingCards = false;
  bool isAddingCard = false;
  String errorMessage = '';
  String cardErrorMessage = '';

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
    isLoadingCards = true;
    cardErrorMessage = '';
    cards = [];
    update();

    try {
      final customerId = await apiClient.getCustomerId();
      if (customerId == null) {
        isLoading = false;
        isLoadingCards = false;
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

        if (accounts.isNotEmpty) {
          await fetchCardsByAccounts();
        } else {
          isLoadingCards = false;
        }
      } else {
        isLoadingCards = false;
        errorMessage = 'API Error ${response.statusCode}: ${response.bodyString}';
      }
    } catch (e) {
      debugPrint("Error fetching accounts: $e");
      isLoadingCards = false;
      errorMessage = 'Parse Error: $e';
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> fetchCardsByAccounts() async {
    isLoadingCards = true;
    cardErrorMessage = '';
    cards = [];
    update();

    final mergedCards = <BankCardModel>[];

    try {
      for (final account in accounts) {
        final accountId = account.accountId;
        if (accountId == null) continue;

        final response = await apiClient.getCardsByAccount(accountId.toString());
        if (response.isOk && response.body != null) {
          mergedCards.addAll(_parseCards(response.body));
        } else if (cardErrorMessage.isEmpty) {
          cardErrorMessage = 'API Error ${response.statusCode}: ${response.bodyString}';
        }
      }
      cards = mergedCards;
    } catch (e) {
      debugPrint("Error fetching cards: $e");
      cardErrorMessage = 'Parse Error: $e';
    } finally {
      isLoadingCards = false;
      update();
    }
  }

  Future<bool> createCard({
    required int accountId,
    required String cardType,
  }) async {
    if (isAddingCard) {
      return false;
    }

    isAddingCard = true;
    cardErrorMessage = '';
    update();

    try {
      final response = await apiClient.createCard(
        accountId: accountId,
        cardType: cardType,
      );

      if (response.isOk) {
        await fetchCardsByAccounts();
        return true;
      }

      cardErrorMessage = 'API Error ${response.statusCode}: ${response.bodyString}';
      return false;
    } catch (e) {
      debugPrint("Error creating card: $e");
      cardErrorMessage = 'Parse Error: $e';
      return false;
    } finally {
      isAddingCard = false;
      update();
    }
  }

  List<BankCardModel> _parseCards(dynamic responseBody) {
    final decoded = _decodeBody(responseBody);
    final rawList = _extractList(
      decoded,
      keys: const ['content', 'data', 'cards', 'items', 'results'],
    );

    final parsed = <BankCardModel>[];
    for (final item in rawList) {
      if (item is Map) {
        parsed.add(BankCardModel.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return parsed;
  }

  dynamic _decodeBody(dynamic body) {
    if (body is String) {
      try {
        return jsonDecode(body);
      } catch (_) {
        return body;
      }
    }
    return body;
  }

  List<dynamic> _extractList(dynamic data, {required List<String> keys}) {
    if (data is List) {
      return data;
    }

    if (data is Map) {
      for (final key in keys) {
        final value = data[key];
        if (value is List) {
          return value;
        }
      }
      return [data];
    }

    return const [];
  }
}
