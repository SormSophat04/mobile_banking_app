import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_banking_app/core/network/api_client.dart';
import 'package:mobile_banking_app/core/network/models/account_model.dart';
import 'package:mobile_banking_app/core/network/models/bank_card_model.dart';
import 'package:mobile_banking_app/widgets/card/custom_credit_card_widget.dart';

class CreditCardController extends GetxController {
  final ApiClient apiClient = Get.put(ApiClient());

  List<AccountModel> accounts = [];
  List<BankCardModel> cards = [];
  List<Widget> cardImages = [];

  int? selectedAccountId;
  int selectedCardIndex = -1;

  bool isLoadingAccounts = true;
  bool isLoadingCards = false;
  String errorMessage = '';
  String customerName = 'Card Holder';

  var currentIndex = 0.obs;
  var dragOverMap = false.obs;

  BankCardModel? get selectedCard {
    if (selectedCardIndex < 0 || selectedCardIndex >= cards.length) {
      return null;
    }
    return cards[selectedCardIndex];
  }

  @override
  void onInit() {
    super.onInit();
    fetchInitialData();
  }

  Future<void> fetchInitialData() async {
    isLoadingAccounts = true;
    errorMessage = '';
    update();

    try {
      customerName = await apiClient.getCustomerName() ?? customerName;
      final customerId = await apiClient.getCustomerId();
      if (customerId == null) {
        errorMessage =
            'Notice: Customer ID missing in cache. Please login again.';
        cards = [];
        cardImages = [];
        return;
      }

      final response = await apiClient.getAccount(customerId);
      if (!response.isOk || response.body == null) {
        errorMessage = 'API Error ${response.statusCode}: ${response.bodyString}';
        cards = [];
        cardImages = [];
        return;
      }

      accounts = _parseAccounts(response.body);
      if (accounts.isEmpty) {
        errorMessage = 'No account found.';
        cards = [];
        cardImages = [];
        return;
      }

      final initialAccountId = _resolveInitialAccountId();
      selectedAccountId = _findExistingAccountId(initialAccountId);

      if (selectedAccountId == null) {
        errorMessage = 'No valid account ID found.';
        cards = [];
        cardImages = [];
        return;
      }

      await fetchCardsForAccount(selectedAccountId!, clearError: false);
    } catch (e) {
      debugPrint('Error loading credit card data: $e');
      errorMessage = 'Parse Error: $e';
    } finally {
      isLoadingAccounts = false;
      update();
    }
  }

  Future<void> refreshCurrentData() async {
    final accountId = selectedAccountId;
    if (accountId == null) {
      await fetchInitialData();
      return;
    }
    await fetchCardsForAccount(accountId);
  }

  Future<void> onAccountSelected(int? accountId) async {
    if (accountId == null || accountId == selectedAccountId) {
      return;
    }
    selectedAccountId = accountId;
    selectedCardIndex = -1;
    await fetchCardsForAccount(accountId);
  }

  Future<void> fetchCardsForAccount(
    int accountId, {
    bool clearError = true,
  }) async {
    isLoadingCards = true;
    if (clearError) {
      errorMessage = '';
    }
    cards = [];
    cardImages = [];
    selectedCardIndex = -1;
    update();

    try {
      final response = await apiClient.getCardsByAccount(accountId.toString());
      if (!response.isOk || response.body == null) {
        errorMessage = 'API Error ${response.statusCode}: ${response.bodyString}';
        return;
      }

      cards = _parseCards(response.body);
      if (cards.isNotEmpty) {
        selectedCardIndex = 0;
      }
      _syncCardImages();
    } catch (e) {
      debugPrint('Error fetching cards: $e');
      errorMessage = 'Parse Error: $e';
    } finally {
      isLoadingCards = false;
      update();
    }
  }

  void selectCard(int index) {
    if (index < 0 || index >= cards.length) {
      return;
    }
    selectedCardIndex = index;
    update();
  }

  void onPageChanged(int index) {
    currentIndex.value = index;
  }

  void checkDrag(
    Offset position,
    bool up, {
    required GlobalKey pointerKey,
    ValueChanged<bool>? onInteractionChanged,
  }) {
    final context = pointerKey.currentContext;
    if (context == null) {
      return;
    }

    if (!up) {
      final renderObject = context.findRenderObject();
      if (renderObject is! RenderBox) {
        return;
      }

      final boxOffset = renderObject.localToGlobal(Offset.zero);
      if (position.dy > boxOffset.dy &&
          position.dy < boxOffset.dy + renderObject.size.height) {
        setDragOverMap(true);
        onInteractionChanged?.call(true);
      }
    } else {
      setDragOverMap(false);
      onInteractionChanged?.call(false);
    }
  }

  void setDragOverMap(bool value) {
    dragOverMap.value = value;
    update();
  }

  String maskedCardNumber(String? rawCardNumber) {
    if (rawCardNumber == null || rawCardNumber.trim().isEmpty) {
      return '**** **** **** ****';
    }

    final digits = rawCardNumber.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.isEmpty) {
      return rawCardNumber;
    }

    if (digits.length <= 4) {
      return _groupBy4(digits);
    }

    final hidden = List.filled(digits.length - 4, '*').join();
    final masked = '$hidden${digits.substring(digits.length - 4)}';
    return _groupBy4(masked);
  }

  String formatBalance(double? balance, String? currency) {
    final amount = (balance ?? 0).toStringAsFixed(2);
    final symbol = _resolveCurrency(currency);

    if (symbol == null || symbol.isEmpty) {
      return amount;
    }
    if (symbol == '\$' || symbol == '៛') {
      return '$symbol$amount';
    }
    return '$amount $symbol';
  }

  String formatExpiryDate(String? rawDate) {
    if (rawDate == null || rawDate.trim().isEmpty) {
      return '';
    }
    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) {
      return rawDate;
    }
    final month = parsed.month.toString().padLeft(2, '0');
    final year = (parsed.year % 100).toString().padLeft(2, '0');
    return '$month/$year';
  }

  String resolveCardHolderName(BankCardModel card) {
    final fromCache = customerName.trim();
    if (fromCache.isNotEmpty) {
      return fromCache;
    }
    final accountNumber = card.accountNumber?.trim();
    if (accountNumber != null && accountNumber.isNotEmpty) {
      return 'Account $accountNumber';
    }
    return 'Card Holder';
  }

  List<AccountModel> _parseAccounts(dynamic responseBody) {
    final decoded = _decodeBody(responseBody);
    final rawList = _extractList(
      decoded,
      keys: const ['content', 'data', 'accounts', 'items', 'results'],
    );

    final parsed = <AccountModel>[];
    for (final item in rawList) {
      if (item is Map) {
        parsed.add(AccountModel.fromJson(Map<String, dynamic>.from(item)));
      }
    }
    return parsed;
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

  int? _resolveInitialAccountId() {
    final args = Get.arguments;
    if (args is AccountModel) {
      return args.accountId;
    }
    if (args is int) {
      return args;
    }
    if (args is String) {
      return int.tryParse(args);
    }
    if (args is Map) {
      final raw = args['accountId'] ?? args['id'];
      if (raw is int) {
        return raw;
      }
      if (raw is String) {
        return int.tryParse(raw);
      }
    }
    return null;
  }

  int? _findExistingAccountId(int? preferredId) {
    final availableIds = accounts
        .map((account) => account.accountId)
        .whereType<int>()
        .toSet();

    if (preferredId != null && availableIds.contains(preferredId)) {
      return preferredId;
    }

    for (final account in accounts) {
      if (account.accountId != null) {
        return account.accountId;
      }
    }
    return null;
  }

  String _groupBy4(String input) {
    final buffer = StringBuffer();
    for (int i = 0; i < input.length; i++) {
      buffer.write(input[i]);
      if ((i + 1) % 4 == 0 && i != input.length - 1) {
        buffer.write(' ');
      }
    }
    return buffer.toString();
  }

  String? _resolveCurrency(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    final upper = value.toUpperCase();
    if (upper == '0' || upper == 'USD' || value == '\$') {
      return '\$';
    }
    if (upper == '1' || upper == 'KHR' || value == '៛') {
      return '៛';
    }
    return value;
  }

  void _syncCardImages() {
    cardImages = cards
        .map(
          (card) => CustomCreditCardWidget(
            userName: resolveCardHolderName(card),
            cardNumber: maskedCardNumber(card.cardNumber),
            balance: formatBalance(card.balance, card.currency),
            cardType: card.cardType,
            marginTop: 0,
          ),
        )
        .toList();
  }
}
