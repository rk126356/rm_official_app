import '../models/transaction_history_model.dart';

String findSmallestBalance(List<TransactionHistory> transactionList) {
  // Check if the list is empty
  if (transactionList.isEmpty) {
    return "List is empty";
  }

  // Convert the first TransactionHistory's balanceAmount to a number for comparison
  num smallestBalance = int.parse(transactionList[0].balanceAmount);

  // Iterate through the rest of the TransactionHistory objects
  for (int i = 1; i < transactionList.length; i++) {
    try {
      // Convert the current TransactionHistory's balanceAmount to a number
      num currentBalance = int.parse(transactionList[i].balanceAmount);

      // Compare and update the smallestBalance if needed
      if (currentBalance < smallestBalance) {
        smallestBalance = currentBalance;
      }
    } catch (e) {
      // Handle parsing errors (e.g., if balanceAmount is not a valid number)
      return "Invalid input: balanceAmount of TransactionHistory at index $i is not a valid number";
    }
  }

  // Convert the smallest balanceAmount back to a string and return it
  return smallestBalance.toString();
}
