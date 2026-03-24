class BankCardModel {
  String? createAt;
  String? updateAt;
  String? createBy;
  String? updateBy;
  int? cardId;
  String? cardNumber;
  String? expiryDate;
  String? cvv;
  String? cardType;
  String? status;
  int? accountId;
  String? accountNumber;
  String? accountType;
  double? balance;
  String? currency;

  BankCardModel({
    this.createAt,
    this.updateAt,
    this.createBy,
    this.updateBy,
    this.cardId,
    this.cardNumber,
    this.expiryDate,
    this.cvv,
    this.cardType,
    this.status,
    this.accountId,
    this.accountNumber,
    this.accountType,
    this.balance,
    this.currency,
  });

  factory BankCardModel.fromJson(Map<String, dynamic> json) {
    final account = json['account'];
    final Map<String, dynamic> accountMap =
        account is Map<String, dynamic>
        ? account
        : account is Map
        ? Map<String, dynamic>.from(account)
        : const <String, dynamic>{};

    return BankCardModel(
      createAt: json['createAt']?.toString(),
      updateAt: json['updateAt']?.toString(),
      createBy: json['createBy']?.toString(),
      updateBy: json['updateBy']?.toString(),
      cardId: _toInt(json['cardId'] ?? json['id']),
      cardNumber: (json['cardNumber'] ?? json['number'] ?? json['pan'])
          ?.toString(),
      expiryDate: (json['expiryDate'] ?? json['expiredDate'] ?? json['expiry'])
          ?.toString(),
      cvv: json['cvv']?.toString(),
      cardType:
          (json['cardType'] ?? json['type'] ?? json['brand'])?.toString(),
      status: (json['status'] ?? accountMap['status'])?.toString(),
      accountId: _toInt(json['accountId'] ?? accountMap['accountId']),
      accountNumber:
          (json['accountNumber'] ?? accountMap['accountNumber'])?.toString(),
      accountType:
          (json['accountType'] ?? accountMap['accountType'])?.toString(),
      balance: _toDouble(
        json['balance'] ?? json['availableBalance'] ?? accountMap['balance'],
      ),
      currency: _resolveCurrency(json['currency'] ?? accountMap['currency']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createAt': createAt,
      'updateAt': updateAt,
      'createBy': createBy,
      'updateBy': updateBy,
      'cardId': cardId,
      'cardNumber': cardNumber,
      'expiryDate': expiryDate,
      'cvv': cvv,
      'cardType': cardType,
      'status': status,
      'accountId': accountId,
      'accountNumber': accountNumber,
      'accountType': accountType,
      'balance': balance,
      'currency': currency,
    };
  }

  String get last4 {
    final digits = (cardNumber ?? '').replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 4) return digits;
    return digits.substring(digits.length - 4);
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString());
  }

  static String? _resolveCurrency(dynamic value) {
    final str = value?.toString();
    if (str == null || str.isEmpty) return null;
    if (str == '0' || str.toUpperCase() == 'USD' || str == '\$') return '\$';
    if (str == '1' || str.toUpperCase() == 'KHR' || str == '៛') return '៛';
    return str;
  }
}
