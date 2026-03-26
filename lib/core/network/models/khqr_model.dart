class KhqrModel {
  final int? accountId;
  final String? accountNumber;
  final String? bakongAccountId;
  final double? amount;
  final String? payload;
  final String? qrCodeBase64;

  KhqrModel({
    this.accountId,
    this.accountNumber,
    this.bakongAccountId,
    this.amount,
    this.payload,
    this.qrCodeBase64,
  });

  factory KhqrModel.fromJson(Map<String, dynamic> json) {
    return KhqrModel(
      accountId: json['accountId'] is int ? json['accountId'] : int.tryParse(json['accountId']?.toString() ?? ''),
      accountNumber: json['accountNumber']?.toString(),
      bakongAccountId: json['bakongAccountId']?.toString(),
      amount: json['amount']?.toDouble(),
      payload: json['payload'],
      qrCodeBase64: json['qrCodeBase64'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountId': accountId,
      'accountNumber': accountNumber,
      'bakongAccountId': bakongAccountId,
      'amount': amount,
      'payload': payload,
      'qrCodeBase64': qrCodeBase64,
    };
  }
}
