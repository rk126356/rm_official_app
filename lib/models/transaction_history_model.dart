class TransactionHistory {
  String id;
  String userId;
  String remark;
  String amountType;
  String amount;
  String balanceAmount;
  String win;
  String transactionNo;
  String createdAt;
  String updatedAt;
  String merchantId;
  dynamic payeeDetail;
  String color;

  TransactionHistory({
    required this.id,
    required this.userId,
    required this.remark,
    required this.amountType,
    required this.amount,
    required this.balanceAmount,
    required this.win,
    required this.transactionNo,
    required this.createdAt,
    required this.updatedAt,
    required this.merchantId,
    required this.payeeDetail,
    required this.color,
  });

  factory TransactionHistory.fromJson(Map<String, dynamic> json) {
    return TransactionHistory(
      id: json['id'] ?? "",
      userId: json['user_id'] ?? "",
      remark: json['remark'] ?? "",
      amountType: json['amount_type'] ?? "",
      amount: json['amount'] ?? "",
      balanceAmount: json['balance_amount'] ?? "",
      win: json['win'] ?? "",
      transactionNo: json['transaction_no'] ?? "",
      createdAt: json['created_at'] ?? "",
      updatedAt: json['updated_at'] ?? "",
      merchantId: json['merchant_id'] ?? "",
      payeeDetail: json['payee_detail'],
      color: json['color'] ?? "",
    );
  }
}
