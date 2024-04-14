import 'transaction_history_model.dart';

class GroupedTransactionHistory {
  String createdAt;
  String amountType;
  String remark;
  List<TransactionHistory> transactions;
  String totalAmount;

  GroupedTransactionHistory({
    required this.createdAt,
    required this.amountType,
    required this.remark,
    required this.transactions,
    required this.totalAmount,
  });
}
