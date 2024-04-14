import '../models/transaction_history_model.dart';

String findBiggestBalance(List<TransactionHistory> transactionList) {
  // Check if the list is empty
  if (transactionList.isEmpty) {
    return "List is empty";
  }

  // Convert the first TransactionHistory's balanceAmount to a number for comparison
  num biggestBalance = int.parse(transactionList[0].balanceAmount);

  // Iterate through the rest of the TransactionHistory objects
  for (int i = 1; i < transactionList.length; i++) {
    try {
      // Convert the current TransactionHistory's balanceAmount to a number
      num currentBalance = int.parse(transactionList[i].balanceAmount);

      // Compare and update the biggestBalance if needed
      if (currentBalance > biggestBalance) {
        biggestBalance = currentBalance;
      }
    } catch (e) {
      // Handle parsing errors (e.g., if balanceAmount is not a valid number)
      return "Invalid input: balanceAmount of TransactionHistory at index $i is not a valid number";
    }
  }

  // Convert the biggest balanceAmount back to a string and return it
  return biggestBalance.toString();
}
