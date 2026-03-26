class BillPaymentResponseModel {
  final int? paymentId;
  final int? billId;
  final int? transactionId;
  final String? receiptNo;
  final String? status;
  final double? paidAmount;
  final String? currency;
  final String? referenceNumber;
  final String? paidAt;

  BillPaymentResponseModel({
    this.paymentId,
    this.billId,
    this.transactionId,
    this.receiptNo,
    this.status,
    this.paidAmount,
    this.currency,
    this.referenceNumber,
    this.paidAt,
  });

  factory BillPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    return BillPaymentResponseModel(
      paymentId: json['paymentId'] is int ? json['paymentId'] : int.tryParse(json['paymentId']?.toString() ?? ''),
      billId: json['billId'] is int ? json['billId'] : int.tryParse(json['billId']?.toString() ?? ''),
      transactionId: json['transactionId'] is int ? json['transactionId'] : int.tryParse(json['transactionId']?.toString() ?? ''),
      receiptNo: json['receiptNo']?.toString(),
      status: json['status']?.toString(),
      paidAmount: json['paidAmount']?.toDouble(),
      currency: json['currency']?.toString(),
      referenceNumber: json['referenceNumber']?.toString(),
      paidAt: json['paidAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'paymentId': paymentId,
      'billId': billId,
      'transactionId': transactionId,
      'receiptNo': receiptNo,
      'status': status,
      'paidAmount': paidAmount,
      'currency': currency,
      'referenceNumber': referenceNumber,
      'paidAt': paidAt,
    };
  }
}
