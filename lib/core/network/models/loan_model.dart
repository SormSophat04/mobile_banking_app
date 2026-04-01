class LoanModel {
  final int? loanId;
  final LoanCustomerModel? customer;
  final double? loanAmount;
  final String? currency;
  final double? interestRate;
  final int? durationMonths;
  final double? monthlyPayment;
  final double? principal;
  final double? totalInterest;
  final double? totalRepayment;
  final String? createAt;
  final String? updateAt;

  LoanModel({
    this.loanId,
    this.customer,
    this.loanAmount,
    this.currency,
    this.interestRate,
    this.durationMonths,
    this.monthlyPayment,
    this.principal,
    this.totalInterest,
    this.totalRepayment,
    this.createAt,
    this.updateAt,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    final rawCustomer = json['customer'];

    return LoanModel(
      loanId: _toInt(json['loanId']),
      customer: rawCustomer is Map
          ? LoanCustomerModel.fromJson(Map<String, dynamic>.from(rawCustomer))
          : null,
      loanAmount: _toDouble(json['loanAmount']),
      currency: json['currency']?.toString(),
      interestRate: _toDouble(json['interestRate']),
      durationMonths: _toInt(json['durationMonths']),
      monthlyPayment: _toDouble(json['monthlyPayment']),
      principal: _toDouble(json['principal']),
      totalInterest: _toDouble(json['total_interest'] ?? json['totalInterest']),
      totalRepayment: _toDouble(json['totalRepayment']),
      createAt: json['createAt']?.toString(),
      updateAt: json['updateAt']?.toString(),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    return int.tryParse(value.toString());
  }

  static double? _toDouble(dynamic value) {
    if (value == null) {
      return null;
    }
    if (value is double) {
      return value;
    }
    if (value is num) {
      return value.toDouble();
    }
    return double.tryParse(value.toString());
  }
}

class LoanCustomerModel {
  final int? customerId;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;

  LoanCustomerModel({
    this.customerId,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
  });

  factory LoanCustomerModel.fromJson(Map<String, dynamic> json) {
    return LoanCustomerModel(
      customerId: LoanModel._toInt(json['customerId']),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      phone: json['phone']?.toString(),
      email: json['email']?.toString(),
    );
  }

  String get fullName {
    final first = firstName?.trim() ?? '';
    final last = lastName?.trim() ?? '';
    final combined = '$first $last'.trim();
    return combined.isEmpty ? 'N/A' : combined;
  }
}
