import 'package:flutter/material.dart';
import 'package:rm_official_app/const/colors.dart';

import '../../models/transaction_history_model.dart';

class TransactionHistoryPopup extends StatelessWidget {
  final List<TransactionHistory> transactionList;

  TransactionHistoryPopup({required this.transactionList});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        height: 500,
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Transaction History',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: AppColors.blueType),
              ),
            ),
            const SizedBox(height: 12.0),
            Expanded(
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListView.builder(
                  itemCount: transactionList.length,
                  itemBuilder: (context, index) {
                    TransactionHistory transaction = transactionList[index];
                    return ListTile(
                      title: Text(
                        'Amount: ${transaction.amount}',
                        style: const TextStyle(fontSize: 16.0),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Remark: ${transaction.remark}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                          Text(
                            'Date: ${transaction.createdAt}',
                            style: const TextStyle(fontSize: 14.0),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12.0),
            Align(
              alignment: Alignment.center,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.pinkType,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Close',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
