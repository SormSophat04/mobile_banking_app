class AccountModel {
  String? createAt;
  String? updateAt;
  String? createBy;
  String? updateBy;
  int? accountId;
  String? accountNumber;
  String? accountType;
  double? balance;
  String? currency;
  String? status;
  CustomerModel? customer;

  AccountModel({
    this.createAt,
    this.updateAt,
    this.createBy,
    this.updateBy,
    this.accountId,
    this.accountNumber,
    this.accountType,
    this.balance,
    this.currency,
    this.status,
    this.customer,
  });

  factory AccountModel.fromJson(Map<String, dynamic> json) {
    String resolveCurrency(dynamic dbData) {
      final str = dbData?.toString();
      if (str == "0" || str?.toUpperCase() == "USD") return "\$";
      if (str == "1" || str?.toUpperCase() == "KHR") return "៛";
      return str ?? "\$"; // fallback
    }

    return AccountModel(
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      createBy: json['createBy'],
      updateBy: json['updateBy'],
      accountId: json['accountId'] is int ? json['accountId'] : int.tryParse(json['accountId']?.toString() ?? ''),
      accountNumber: json['accountNumber']?.toString(),
      accountType: json['accountType']?.toString(),
      balance: json['balance']?.toDouble(),
      currency: resolveCurrency(json['currency']),
      status: json['status'],
      customer: json['customer'] != null ? CustomerModel.fromJson(json['customer']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createAt': createAt,
      'updateAt': updateAt,
      'createBy': createBy,
      'updateBy': updateBy,
      'accountId': accountId,
      'accountNumber': accountNumber,
      'accountType': accountType,
      'balance': balance,
      'currency': currency,
      'status': status,
      'customer': customer?.toJson(),
    };
  }
}

class CustomerModel {
  String? createAt;
  String? updateAt;
  String? createBy;
  String? updateBy;
  int? customerId;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  int? nationalId;
  String? birthDate;
  String? status;

  CustomerModel({
    this.createAt,
    this.updateAt,
    this.createBy,
    this.updateBy,
    this.customerId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.nationalId,
    this.birthDate,
    this.status,
  });

  factory CustomerModel.fromJson(Map<String, dynamic> json) {
    return CustomerModel(
      createAt: json['createAt'],
      updateAt: json['updateAt'],
      createBy: json['createBy'],
      updateBy: json['updateBy'],
      customerId: json['customerId'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
      nationalId: json['nationalId'] is String ? int.tryParse(json['nationalId']) : json['nationalId'],
      birthDate: json['birthDate'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'createAt': createAt,
      'updateAt': updateAt,
      'createBy': createBy,
      'updateBy': updateBy,
      'customerId': customerId,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'email': email,
      'nationalId': nationalId,
      'birthDate': birthDate,
      'status': status,
    };
  }
}
