import 'package:flutter/material.dart';

import '../models/transaction_history_model.dart';

class TransactionHistoryWidget extends StatelessWidget {
  final TransactionHistory transaction;

  const TransactionHistoryWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: ListTile(
        title: Text(transaction.remark.toUpperCase()),
        subtitle: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Amount: ${transaction.amount}'),
              Text('Balance Amount: ${transaction.balanceAmount}'),
              Text('Transaction Type: ${transaction.amountType}'),
              Text('Date: ${transaction.createdAt}'),
            ],
          ),
        ),
        // trailing: Text(
        //   transaction.win == '1' ? 'Win' : 'Loss',
        //   style: TextStyle(
        //     color: transaction.win == '1' ? Colors.green : Colors.red,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
      ),
    );
  }
}
