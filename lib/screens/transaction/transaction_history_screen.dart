import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/models/transaction_history_model.dart';
import 'package:rm_official_app/widgets/app_bar_widget.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';

import '../../const/colors.dart';
import '../../provider/user_provider.dart';
import '../../widgets/heading_logo_widget.dart';
import '../../widgets/rgb_small_box_text_widget.dart';
import '../../widgets/transaction_history_loop_widget.dart';
import '../../widgets/white_side_heading_widget.dart';
import '../navigation/drawer_nav_bar.dart';
import 'package:http/http.dart' as http;

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key, required this.isRoute});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();

  final bool isRoute;
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  List<TransactionHistory> list = [];
  String startDate = '2024-1-7';
  String endDate = '2024-1-7';
  bool _isLoading = false;
  String totalPlayed = '0';
  String totalWithdrawal = '0';
  String totalDeposit = '0';
  String totalWin = '0';

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
    const apiUrl = "https://rmmatka.com/ravan/api/wallet-history";
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
        } else {
          print('Transactions data is null');
        }
      } else {
        print('No data in the response');
      }
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    startDate = DateFormat('yyyy-M-d').format(DateTime.now());
    endDate = DateFormat('yyyy-M-d').format(DateTime.now());

    fetchApi();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      drawer: widget.isRoute ? null : const NavBar(),
      appBar: AppBarWidget(
        title: 'Welcome: ${userProvider.user.name}',
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
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'Start Date\n$startDate',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
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
                    padding: const EdgeInsets.all(2.0),
                    child: Text(
                      'End Date\n$endDate',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.black),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
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
                  borderRadius: BorderRadius.circular(2.0),
                ),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
              child: const Text(
                'SUBMIT',
                style: TextStyle(color: Colors.black),
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
                      child: Text('TYPE',
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
                    : Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.red,
                              AppColors.primaryColor,
                              AppColors.yellowType
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Column(
                          children: [
                            if (list.isNotEmpty && !_isLoading)
                              for (int i = 0; i < list.length; i++)
                                Column(
                                  children: [
                                    Container(
                                      decoration: const BoxDecoration(
                                          border: BorderDirectional(
                                              top: BorderSide(
                                        color: Colors.blueGrey,
                                      ))),
                                      child: Container(
                                        height: 60,
                                        color: AppColors.primaryColor,
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
                                                child: Text(
                                                  DateFormat('hh:mm a').format(
                                                      DateFormat(
                                                              'dd-MM-yyyy hh:mm a')
                                                          .parse(list[i]
                                                              .createdAt)),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color: Colors.blueGrey,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  list[i]
                                                      .amountType
                                                      .toUpperCase(),
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontStyle: FontStyle.italic,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color: Colors.blueGrey,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4,
                                                    top: 4,
                                                    bottom: 4,
                                                    right: 8),
                                                child: Text(
                                                  list[i].amount,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    color: list[i].amountType ==
                                                            'debit'
                                                        ? Colors.red
                                                        : const Color.fromARGB(
                                                            255, 25, 125, 29),
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color: Colors.blueGrey,
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4,
                                                    top: 4,
                                                    bottom: 4,
                                                    right: 8),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      list[i]
                                                          .remark
                                                          .toUpperCase(),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: 1,
                                              color: Colors.blueGrey,
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4,
                                                    top: 4,
                                                    bottom: 4,
                                                    right: 8),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      list[i]
                                                          .balanceAmount
                                                          .toUpperCase(),
                                                      style: const TextStyle(
                                                        fontSize: 12,
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
