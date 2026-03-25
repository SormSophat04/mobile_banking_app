class BillModel {
  int? billId;
  String? billType;
  String? billCode;
  String? customerName;
  String? address;
  String? phoneNumber;
  String? periodFrom;
  String? periodTo;
  double? feeAmount;
  double? taxAmount;
  double? totalAmount;
  String? currency;
  String? status;
  String? dueDate;

  BillModel({
    this.billId,
    this.billType,
    this.billCode,
    this.customerName,
    this.address,
    this.phoneNumber,
    this.periodFrom,
    this.periodTo,
    this.feeAmount,
    this.taxAmount,
    this.totalAmount,
    this.currency,
    this.status,
    this.dueDate,
  });

  factory BillModel.fromJson(Map<String, dynamic> json) {
    return BillModel(
      billId: json['billId'] is int ? json['billId'] : int.tryParse(json['billId']?.toString() ?? ''),
      billType: json['billType']?.toString(),
      billCode: json['billCode']?.toString(),
      customerName: json['customerName']?.toString(),
      address: json['address']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      periodFrom: json['periodFrom']?.toString(),
      periodTo: json['periodTo']?.toString(),
      feeAmount: json['feeAmount']?.toDouble(),
      taxAmount: json['taxAmount']?.toDouble(),
      totalAmount: json['totalAmount']?.toDouble(),
      currency: json['currency']?.toString(),
      status: json['status']?.toString(),
      dueDate: json['dueDate']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'billId': billId,
      'billType': billType,
      'billCode': billCode,
      'customerName': customerName,
      'address': address,
      'phoneNumber': phoneNumber,
      'periodFrom': periodFrom,
      'periodTo': periodTo,
      'feeAmount': feeAmount,
      'taxAmount': taxAmount,
      'totalAmount': totalAmount,
      'currency': currency,
      'status': status,
      'dueDate': dueDate,
    };
  }
}
