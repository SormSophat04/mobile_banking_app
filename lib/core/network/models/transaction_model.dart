class TransactionModel {
  int? transactionId;
  String? transactionType;
  double? amount;
  String? description;
  String? status;
  String? createAt;
  String? referenceNumber;

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
    final from = json['fromAccountId'] as Map<String, dynamic>?;
    final to = json['toAccountId'] as Map<String, dynamic>?;

    final fromCustomer = from?['customer'] as Map<String, dynamic>?;
    final toCustomer = to?['customer'] as Map<String, dynamic>?;

    String? getName(Map<String, dynamic>? customer) {
      if (customer == null) return null;
      final fastName = customer['firstName']?.toString();
      final lastName = customer['lastName']?.toString();
      if (fastName != null && lastName != null) return '$fastName $lastName';
      return fastName ?? lastName;
    }

    String resolveCurrency(dynamic dbData) {
      final str = dbData?.toString();
      if (str == "0" || str?.toUpperCase() == "USD") return "\$";
      if (str == "1" || str?.toUpperCase() == "KHR") return "៛";
      return str ?? "\$"; // fallback
    }

    return TransactionModel(
      transactionId: json['transactionId'] is int
          ? json['transactionId']
          : int.tryParse(json['transactionId']?.toString() ?? ''),
      transactionType:
          json['type']?.toString() ?? json['transactionType']?.toString(),
      amount: (json['amount'] as num?)?.toDouble(),
      description: json['description']?.toString(),
      status: json['status']?.toString(),
      createAt: json['createAt']?.toString() ?? json['createdAt']?.toString(),
      referenceNumber: json['referenceNumber']?.toString(),
      currency: resolveCurrency(json['currency'] ?? from?['currency'] ?? to?['currency']),
      // Sender
      senderAccountId: from?['accountId'] is int
          ? from!['accountId']
          : int.tryParse(from?['accountId']?.toString() ?? ''),
      senderName: getName(fromCustomer),
      senderAccountNumber: from?['accountNumber']?.toString(),
      senderPhone: fromCustomer?['phone']?.toString(),
      senderCurrency: resolveCurrency(from?['currency']),
      // Receiver
      receiverAccountId: to?['accountId'] is int
          ? to!['accountId']
          : int.tryParse(to?['accountId']?.toString() ?? ''),
      receiverName: getName(toCustomer),
      receiverAccountNumber: to?['accountNumber']?.toString(),
      receiverPhone: toCustomer?['phone']?.toString(),
      receiverCurrency: resolveCurrency(to?['currency']),
    );
  }

  Map<String, dynamic> toJson() => {
    'transactionId': transactionId,
    'transactionType': transactionType,
    'amount': amount,
    'description': description,
    'status': status,
    'createAt': createAt,
    'referenceNumber': referenceNumber,
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
