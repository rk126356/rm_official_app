// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/models/transaction_history_model.dart';
import 'package:rm_official_app/widgets/app_bar_widget.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';

import '../../const/colors.dart';
import '../../controllers/fetch_balance_controller.dart';
import '../../models/grouped_transaction_history_model.dart';
import '../../provider/user_provider.dart';
import '../../utils/find_biggest_number.dart';
import '../../utils/find_small_amount.dart';
import '../../widgets/heading_logo_widget.dart';
import '../../widgets/rgb_small_box_text_widget.dart';
import '../../widgets/transaction_history_loop_widget.dart';
import '../../widgets/white_side_heading_widget.dart';
import '../navigation/drawer_nav_bar.dart';
import 'package:http/http.dart' as http;

import 'transaction_history_popup_widget.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key, required this.isRoute});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();

  final bool isRoute;
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  String startDate = '2024-1-7';
  String endDate = '2024-1-7';
  bool _isLoading = false;
  String totalPlayed = '0';
  String totalWithdrawal = '0';
  String totalDeposit = '0';
  String totalWin = '0';
  List<TransactionHistory> list = [];
  List<GroupedTransactionHistory> groupedTransactions = [];

  void filterTransactionHistoryList() {
    groupedTransactions.clear();
    setState(() {
      _isLoading = true;
    });
    // Create a map to store groups using a unique key
    Map<String, GroupedTransactionHistory> groupsMap = {};

    for (TransactionHistory transaction in list) {
      // Create a unique key based on createdAt, amountType, and remark
      String key =
          '${transaction.createdAt}_${transaction.amountType}_${transaction.remark}';

      // Check if a group already exists for the key
      if (groupsMap.containsKey(key)) {
        // If exists, add the transaction to the existing group
        groupsMap[key]!.transactions.add(transaction);
        // Update totalAmount and totalBalanceAmount for the group
        updateTotals(groupsMap[key]!);
      } else {
        // If not, create a new group
        GroupedTransactionHistory newGroup = GroupedTransactionHistory(
          createdAt: transaction.createdAt,
          amountType: transaction.amountType,
          remark: transaction.remark,
          transactions: [transaction],
          totalAmount: transaction.amount,
        );

        // Add the new group to the map
        groupsMap[key] = newGroup;
      }
    }

    // Add all groups from the map to the groupedTransactions list
    groupedTransactions.addAll(groupsMap.values);

    setState(() {
      _isLoading = false;
    });
  }

  void updateTotals(GroupedTransactionHistory group) {
    // Calculate totalAmount and totalBalanceAmount for the group
    double totalAmount = group.transactions
        .map((transaction) => double.parse(transaction.amount))
        .reduce((value, element) => value + element);

    // Convert to String without the decimal point
    group.totalAmount = totalAmount
        .toStringAsFixed(totalAmount.truncateToDouble() == totalAmount ? 0 : 2);
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        startDate = DateFormat('yyyy-M-d').format(picked);
      });
      fetchApi();
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != DateTime.now()) {
      setState(() {
        endDate = DateFormat('yyyy-M-d').format(picked);
      });
      fetchApi();
    }
  }

  void fetchApi() async {
    const apiUrl = "https://rmmatka.com/app/api/wallet-history";
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isLoading = true;
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: {
        "user_id": userProvider.user.id,
        "from_date": startDate,
        "end_date": endDate,
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('data') && jsonResponse['error'] == false) {
        final transactions = jsonResponse['data']['transactions'];

        setState(() {
          totalPlayed = jsonResponse['data']['totalPlayed'].toString();
          totalWithdrawal = jsonResponse['data']['totalWithdrawal'].toString();
          totalDeposit = jsonResponse['data']['totalDeposit'].toString();
          totalWin = jsonResponse['data']['totalWin'].toString();
        });

        if (transactions != null) {
          List<TransactionHistory> transactionList =
              List<TransactionHistory>.from(
            transactions.map((model) => TransactionHistory.fromJson(model)),
          );
          setState(() {
            list = transactionList;
          });
          filterTransactionHistoryList();
        } else {
          setState(() {
            _isLoading = false;
          });
          if (kDebugMode) {
            print('Transactions data is null');
          }
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        if (kDebugMode) {
          print('No data in the response');
        }
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (kDebugMode) {
        print('Failed to load data. Status code: ${response.statusCode}');
      }
      showCoolErrorSnackbar(context, 'Check your internet connection');
    }
  }

  @override
  void initState() {
    super.initState();
    startDate = DateFormat('yyyy-M-d').format(DateTime.now());
    // startDate = '2024-1-16';
    endDate = DateFormat('yyyy-M-d').format(DateTime.now());
    fetchBalance(context);
    fetchApi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      drawer: widget.isRoute ? null : const NavBar(),
      appBar: const AppBarWidget(
        title: 'TRANSACTION HISTORY',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeadingLogo(),
            const SizedBox(
              height: 18,
            ),
            Image.asset('assets/images/gifs/transaction_history.gif'),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _selectStartDate(context),
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Start Date\n$startDate',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () => _selectEndDate(context),
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Colors.white,
                  ),
                  label: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'End Date\n$endDate',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.green),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            OutlinedButton(
              onPressed: fetchApi,
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                side: const BorderSide(color: Colors.blue, width: 2),
                backgroundColor: Colors.blue
                    .withOpacity(0.1), // Background color when pressed
              ),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  'SUBMIT',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    color: AppColors.redType,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('DATE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: AppColors.redType,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('TOTAL',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: AppColors.redType,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('AMOUNT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: AppColors.redType,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('REMARK',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Container(
                    color: AppColors.redType,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('BALANCE',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          )),
                    ),
                  ),
                )
              ],
            ),
            _isLoading
                ? const CircularProgressIndicator()
                : list.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('No History'),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (list.isNotEmpty && !_isLoading)
                            for (int i = 0; i < groupedTransactions.length; i++)
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      border: BorderDirectional(
                                        top: BorderSide(
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),
                                    child: Container(
                                      height: 60,
                                      color: const Color.fromARGB(
                                          255, 253, 238, 188),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    DateFormat('dd-MM-yy')
                                                        .format(
                                                      DateFormat(
                                                              'dd-MM-yyyy hh:mm a')
                                                          .parse(
                                                        groupedTransactions[i]
                                                            .createdAt,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          12, // Adjusted font size
                                                    ),
                                                  ),
                                                  Text(
                                                    DateFormat('hh:mm a')
                                                        .format(
                                                      DateFormat(
                                                              'dd-MM-yyyy hh:mm a')
                                                          .parse(
                                                        groupedTransactions[i]
                                                            .createdAt,
                                                      ),
                                                    ),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize:
                                                          12, // Adjusted font size
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(
                                            color: Colors.black12,
                                            width: 1,
                                            thickness: 2,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'TRANS: ${groupedTransactions[i].transactions.length}',
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize:
                                                          12, // Adjusted font size
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return TransactionHistoryPopup(
                                                            transactionList:
                                                                groupedTransactions[
                                                                        i]
                                                                    .transactions,
                                                          );
                                                        },
                                                      );
                                                    },
                                                    child: const Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          'SEE',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontStyle: FontStyle
                                                                .italic,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 4,
                                                        ),
                                                        Icon(
                                                          Icons.remove_red_eye,
                                                          color: AppColors
                                                              .pinkType,
                                                          size: 14,
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(
                                            color: Colors.black12,
                                            width: 1,
                                            thickness: 2,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4,
                                                top: 4,
                                                bottom: 4,
                                                right: 8,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    groupedTransactions[i]
                                                        .totalAmount,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize:
                                                          13, // Adjusted font size
                                                      color: groupedTransactions[
                                                                      i]
                                                                  .amountType ==
                                                              'debit'
                                                          ? Colors.red
                                                          : const Color
                                                              .fromARGB(
                                                              255, 25, 125, 29),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    groupedTransactions[i]
                                                        .amountType
                                                        .toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize:
                                                          12, // Adjusted font size
                                                      fontStyle:
                                                          FontStyle.italic,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(
                                            color: Colors.black12,
                                            width: 1,
                                            thickness: 2,
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4,
                                                top: 4,
                                                bottom: 4,
                                                right: 8,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    groupedTransactions[i]
                                                        .remark
                                                        .toUpperCase(),
                                                    textAlign: TextAlign.center,
                                                    style: const TextStyle(
                                                      fontSize:
                                                          10, // Adjusted font size
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const VerticalDivider(
                                            color: Colors.black12,
                                            width: 1,
                                            thickness: 2,
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 4,
                                                top: 4,
                                                bottom: 4,
                                                right: 8,
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    groupedTransactions[i]
                                                                .amountType ==
                                                            'credit'
                                                        ? findBiggestBalance(
                                                            groupedTransactions[
                                                                    i]
                                                                .transactions)
                                                        : findSmallestBalance(
                                                            groupedTransactions[
                                                                    i]
                                                                .transactions),
                                                    style: const TextStyle(
                                                      fontSize:
                                                          13, // Adjusted font size
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 2,
                                  )
                                ],
                              ),
                        ],
                      ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RbgSmallBoxText(
                  text: "Total Deposit",
                ),
                RbgSmallBoxText(
                  text: totalDeposit.toString(),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RbgSmallBoxText(
                  text: "Total Withdraw",
                ),
                RbgSmallBoxText(
                  text: totalWithdrawal.toString(),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RbgSmallBoxText(
                  text: "Total Played",
                ),
                RbgSmallBoxText(
                  text: totalPlayed.toString(),
                ),
              ],
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RbgSmallBoxText(
                  text: "Total Win",
                ),
                RbgSmallBoxText(
                  text: totalWin.toString(),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const BottomContact()
          ],
        ),
      ),
    );
  }
}
