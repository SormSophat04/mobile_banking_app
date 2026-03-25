class TransactionModel {
  int? transactionId;
  String? transactionType;
  double? amount;
  String? description;
  String? status;
  String? createAt;
  String? referenceNumber;
  TransactionAccountModel? fromAccount;
  TransactionAccountModel? toAccount;

  // Parsed from nested fromAccountId.customer / toAccountId.customer objects
  int? senderAccountId;
  String? senderName;
  String? senderAccountNumber;
  String? senderPhone;
  int? receiverAccountId;
  String? receiverName;
  String? receiverAccountNumber;
  String? receiverPhone;
  String? senderCurrency;
  String? receiverCurrency;
  String? currency;

  TransactionModel({
    this.transactionId,
    this.transactionType,
    this.amount,
    this.description,
    this.status,
    this.createAt,
    this.referenceNumber,
    this.fromAccount,
    this.toAccount,
    this.senderAccountId,
    this.senderName,
    this.senderAccountNumber,
    this.senderPhone,
    this.receiverAccountId,
    this.receiverName,
    this.receiverAccountNumber,
    this.receiverPhone,
    this.senderCurrency,
    this.receiverCurrency,
    this.currency,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    final normalized = _normalizeTransactionJson(json);
    final fromMap = _asMap(
      normalized['fromAccountId'] ??
          normalized['fromAccount'] ??
          normalized['from'],
    );
    final toMap = _asMap(
      normalized['toAccountId'] ?? normalized['toAccount'] ?? normalized['to'],
    );
    final fromCustomerMap = _asMap(
      fromMap?['customer'] ??
          normalized['fromCustomer'] ??
          normalized['sender'] ??
          normalized['fromUser'],
    );
    final toCustomerMap = _asMap(
      toMap?['customer'] ??
          normalized['toCustomer'] ??
          normalized['receiver'] ??
          normalized['toUser'],
    );

    final fromAccount = fromMap != null
        ? TransactionAccountModel.fromJson(fromMap)
        : null;
    final toAccount = toMap != null
        ? TransactionAccountModel.fromJson(toMap)
        : null;

    return TransactionModel(
      transactionId: _asInt(
        normalized['transactionId'] ??
            normalized['id'] ??
            normalized['transactionID'],
      ),
      transactionType:
          normalized['type']?.toString() ??
          normalized['transactionType']?.toString(),
      amount: _asDouble(normalized['amount']),
      description:
          normalized['description']?.toString() ??
          normalized['remark']?.toString(),
      status: normalized['status']?.toString(),
      createAt:
          normalized['createAt']?.toString() ??
          normalized['createdAt']?.toString() ??
          normalized['transactionDate']?.toString(),
      referenceNumber:
          normalized['referenceNumber']?.toString() ??
          normalized['referenceNo']?.toString(),
      fromAccount: fromAccount,
      toAccount: toAccount,
      currency: _resolveCurrency(
        normalized['currency'] ?? fromAccount?.currency ?? toAccount?.currency,
      ),
      // Sender
      senderAccountId:
          fromAccount?.accountId ??
          _asInt(normalized['senderAccountId'] ?? normalized['fromAccountId']),
      senderName: _firstNonBlank([
        fromAccount?.customer?.fullName,
        _fullNameFromMap(fromCustomerMap),
        _fullNameFromMap(_asMap(normalized['sender'])),
        _fullNameFromMap(_asMap(normalized['fromCustomer'])),
        normalized['senderName'],
        normalized['fromCustomerName'],
        normalized['fromName'],
        normalized['senderFullName'],
        normalized['senderDisplayName'],
      ]),
      senderAccountNumber: _firstNonBlank([
        fromAccount?.accountNumber,
        normalized['senderAccountNumber'],
        normalized['fromAccountNumber'],
        normalized['fromAccountNo'],
        normalized['senderAccountNo'],
      ]),
      senderPhone: _firstNonBlank([
        fromAccount?.customer?.phone,
        _phoneFromMap(fromCustomerMap),
        _phoneFromMap(_asMap(normalized['sender'])),
        _phoneFromMap(_asMap(normalized['fromCustomer'])),
        normalized['senderPhone'],
        normalized['fromPhone'],
        normalized['fromPhoneNumber'],
        normalized['senderPhoneNumber'],
        normalized['phoneNumber'],
        normalized['phone'],
      ]),
      senderCurrency: _resolveCurrency(
        fromAccount?.currency ??
            normalized['senderCurrency'] ??
            normalized['fromCurrency'],
      ),
      // Receiver
      receiverAccountId:
          toAccount?.accountId ??
          _asInt(normalized['receiverAccountId'] ?? normalized['toAccountId']),
      receiverName: _firstNonBlank([
        toAccount?.customer?.fullName,
        _fullNameFromMap(toCustomerMap),
        _fullNameFromMap(_asMap(normalized['receiver'])),
        _fullNameFromMap(_asMap(normalized['toCustomer'])),
        normalized['receiverName'],
        normalized['toCustomerName'],
        normalized['toName'],
        normalized['receiverFullName'],
        normalized['receiverDisplayName'],
      ]),
      receiverAccountNumber: _firstNonBlank([
        toAccount?.accountNumber,
        normalized['receiverAccountNumber'],
        normalized['toAccountNumber'],
        normalized['toAccountNo'],
        normalized['receiverAccountNo'],
      ]),
      receiverPhone: _firstNonBlank([
        toAccount?.customer?.phone,
        _phoneFromMap(toCustomerMap),
        _phoneFromMap(_asMap(normalized['receiver'])),
        _phoneFromMap(_asMap(normalized['toCustomer'])),
        normalized['receiverPhone'],
        normalized['toPhone'],
        normalized['toPhoneNumber'],
        normalized['receiverPhoneNumber'],
      ]),
      receiverCurrency: _resolveCurrency(
        toAccount?.currency ??
            normalized['receiverCurrency'] ??
            normalized['toCurrency'],
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionId': transactionId,
    'type': transactionType,
    'transactionType': transactionType,
    'amount': amount,
    'description': description,
    'status': status,
    'createAt': createAt,
    'referenceNumber': referenceNumber,
    'fromAccountId': fromAccount?.toJson() ?? senderAccountId,
    'toAccountId': toAccount?.toJson() ?? receiverAccountId,
    'currency': currency,
    'senderAccountId': senderAccountId,
    'senderName': senderName,
    'senderAccountNumber': senderAccountNumber,
    'senderPhone': senderPhone,
    'senderCurrency': senderCurrency,
    'receiverAccountId': receiverAccountId,
    'receiverName': receiverName,
    'receiverAccountNumber': receiverAccountNumber,
    'receiverPhone': receiverPhone,
    'receiverCurrency': receiverCurrency,
  };
}

class TransactionAccountModel {
  int? accountId;
  String? accountNumber;
  String? currency;
  TransactionCustomerModel? customer;

  TransactionAccountModel({
    this.accountId,
    this.accountNumber,
    this.currency,
    this.customer,
  });

  factory TransactionAccountModel.fromJson(Map<String, dynamic> json) {
    return TransactionAccountModel(
      accountId: _asInt(json['accountId']),
      accountNumber: json['accountNumber']?.toString(),
      currency: _resolveCurrency(json['currency']),
      customer: _asMap(json['customer']) != null
          ? TransactionCustomerModel.fromJson(_asMap(json['customer'])!)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'accountNumber': accountNumber,
      'currency': currency,
      'customer': customer?.toJson(),
    };
  }
}

class TransactionCustomerModel {
  int? customerId;
  String? firstName;
  String? lastName;
  String? phone;

  TransactionCustomerModel({
    this.customerId,
    this.firstName,
    this.lastName,
    this.phone,
  });

  factory TransactionCustomerModel.fromJson(Map<String, dynamic> json) {
    return TransactionCustomerModel(
      customerId: _asInt(json['customerId']),
      firstName: _firstNonBlank([
        json['firstName'],
        json['firstname'],
        json['givenName'],
      ]),
      lastName: _firstNonBlank([
        json['lastName'],
        json['lastname'],
        json['familyName'],
      ]),
      phone: _firstNonBlank([
        json['phone'],
        json['phoneNumber'],
        json['mobile'],
        json['mobileNumber'],
        json['msisdn'],
      ]),
    );
  }

  String? get fullName {
    final first = firstName?.trim();
    final last = lastName?.trim();
    if (first != null && first.isNotEmpty && last != null && last.isNotEmpty) {
      return '$first $last';
    }
    if (first != null && first.isNotEmpty) return first;
    if (last != null && last.isNotEmpty) return last;
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'customerId': customerId,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
    };
  }
}

int? _asInt(dynamic value) {
  if (value is int) return value;
  return int.tryParse(value?.toString() ?? '');
}

double? _asDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

Map<String, dynamic>? _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) {
    return value.map((key, dynamic item) => MapEntry(key.toString(), item));
  }
  return null;
}

Map<String, dynamic> _normalizeTransactionJson(Map<String, dynamic> source) {
  var current = source;

  for (var i = 0; i < 4; i++) {
    if (_looksLikeTransactionMap(current)) {
      return current;
    }

    final nestedMap = _firstMap([
      current['data'],
      current['transaction'],
      current['result'],
      current['payload'],
      current['item'],
      current['content'],
    ]);
    if (nestedMap != null) {
      current = nestedMap;
      continue;
    }

    final nestedList = _firstList([
      current['data'],
      current['transactions'],
      current['items'],
      current['result'],
      current['content'],
      current['payload'],
    ]);
    if (nestedList != null && nestedList.isNotEmpty) {
      final first = _asMap(nestedList.first);
      if (first != null) {
        current = first;
        continue;
      }
    }

    break;
  }

  return current;
}

bool _looksLikeTransactionMap(Map<String, dynamic> map) {
  return map.containsKey('transactionId') ||
      map.containsKey('id') ||
      map.containsKey('amount') ||
      map.containsKey('fromAccountId') ||
      map.containsKey('fromAccount');
}

Map<String, dynamic>? _firstMap(List<dynamic> candidates) {
  for (final item in candidates) {
    final map = _asMap(item);
    if (map != null) return map;
  }
  return null;
}

List<dynamic>? _firstList(List<dynamic> candidates) {
  for (final item in candidates) {
    if (item is List) return item;
  }
  return null;
}

String? _firstNonBlank(List<dynamic> values) {
  for (final value in values) {
    final normalized = value?.toString().trim();
    if (normalized == null || normalized.isEmpty) {
      continue;
    }
    final compact = normalized.toLowerCase();
    if (compact == 'null' || compact == 'n/a' || compact == 'na') {
      continue;
    }
    final words = compact.split(RegExp(r'\s+'));
    final allNullish =
        words.isNotEmpty &&
        words.every((word) => word == 'null' || word == 'n/a' || word == 'na');
    if (allNullish) {
      continue;
    }
    return normalized;
  }
  return null;
}

String? _fullNameFromMap(Map<String, dynamic>? map) {
  if (map == null) return null;

  final direct = _firstNonBlank([
    map['fullName'],
    map['name'],
    map['displayName'],
    map['customerName'],
    map['senderName'],
    map['receiverName'],
  ]);
  if (direct != null) return direct;

  final first = _firstNonBlank([
    map['firstName'],
    map['firstname'],
    map['givenName'],
  ]);
  final last = _firstNonBlank([
    map['lastName'],
    map['lastname'],
    map['familyName'],
  ]);

  if (first != null && last != null) return '$first $last';
  return first ?? last;
}

String? _phoneFromMap(Map<String, dynamic>? map) {
  if (map == null) return null;
  return _firstNonBlank([
    map['phone'],
    map['phoneNumber'],
    map['mobile'],
    map['mobileNumber'],
    map['msisdn'],
  ]);
}

String _resolveCurrency(dynamic dbData) {
  final str = dbData?.toString();
  if (str == '0' || str?.toUpperCase() == 'USD') return '\$';
  if (str == '1' || str?.toUpperCase() == 'KHR') return '៛';
  return str ?? '\$'; // fallback
}
