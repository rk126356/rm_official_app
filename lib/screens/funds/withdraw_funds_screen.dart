// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/screens/funds/add_funds_screen.dart';
import 'package:rm_official_app/screens/funds/withdraw_accounts_screen.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';

import '../../const/colors.dart';
import '../../provider/user_provider.dart';
import '../../widgets/heading_logo_widget.dart';
import '../../widgets/success_snackbar_widget.dart';
import '../navigation/bottom_navigation.dart';
import 'package:http/http.dart' as http;

class WithdrawFundsScreen extends StatefulWidget {
  const WithdrawFundsScreen({super.key});

  @override
  State<WithdrawFundsScreen> createState() => _WithdrawFundsScreenState();
}

class _WithdrawFundsScreenState extends State<WithdrawFundsScreen> {
  String? selectedPaymentMethod;
  bool _isButtonLoading = false;
  String amount = '0';

  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
        name: 'UPI ACCOUNT', imagePath: 'assets/images/other_upi.png'),
    PaymentMethod(name: 'BANK ACCOUNT', imagePath: 'assets/images/bank.png'),
  ];

  void checkPaymentMethod() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user.upi.isEmpty) {
      paymentMethods.removeWhere((element) => element.name == 'UPI ACCOUNT');
    }
    if (userProvider.user.bankAccountNumber.isEmpty) {
      paymentMethods.removeWhere((element) => element.name == 'BANK ACCOUNT');
    }
  }

  void getAvailablePaymentMethods() async {
    if (int.parse(amount) < 5000) {
      paymentMethods.removeWhere((element) => element.name == 'BANK ACCOUNT');
      paymentMethods.removeWhere((element) => element.name == 'UPI ACCOUNT');
      paymentMethods.add(PaymentMethod(
          name: 'UPI ACCOUNT', imagePath: 'assets/images/other_upi.png'));
    }
    if (int.parse(amount) >= 5000) {
      paymentMethods.removeWhere((element) => element.name == 'UPI ACCOUNT');
      paymentMethods.removeWhere((element) => element.name == 'BANK ACCOUNT');
      paymentMethods.add(PaymentMethod(
          name: 'BANK ACCOUNT', imagePath: 'assets/images/bank.png'));
    }
    checkPaymentMethod();
  }

  void withdrawFunds() async {
    const apiUrl = 'https://rmmatka.com/ravan/api/withdraw-amount';
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user.upi.isEmpty &&
        userProvider.user.bankAccountNumber.isEmpty) {
      showCoolErrorSnackbar(context, 'You have not added any payment method');
    }

    setState(() {
      _isButtonLoading = true;
    });

    try {
      var response = await http.post(Uri.parse(apiUrl), body: {
        'user_id': userProvider.user.id,
        'amount': amount,
        'upi_type': selectedPaymentMethod == 'UPI ACCOUNT'
            ? 'PayTm Upi'
            : userProvider.user.bankName.toUpperCase(),
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
          print(data);

          showCoolSuccessSnackbar(context, data['message']);
        } else {
          showCoolErrorSnackbar(context, data['message']);
        }
      } else {
        print(response.statusCode);
        showCoolErrorSnackbar(context, 'Error: Check your internet connection');
      }
    } catch (e) {
      showCoolErrorSnackbar(context, 'Error: $e');
    }

    setState(() {
      _isButtonLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkPaymentMethod();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        actions: [
          ElevatedButton.icon(
            style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              backgroundColor: MaterialStateProperty.all(AppColors.redType),
            ),
            onPressed: () {},
            icon: const Icon(
              Icons.wallet,
              color: Colors.white,
            ),
            label: Text(
              userProvider.user.balance.toString(),
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.redType,
        title: const Text(
          'Withdraw Funds',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeadingLogo(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 12,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 36, vertical: 12),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 42, 104, 44),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: const Text(
                      'WITHDRAWAL 11:AM TO 03:00 and 03:00 PM TO 06:00 PM AVAILABLE',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12))),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ENTER AMOUNT TO WITHDRAW',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              setState(() {
                                amount = value;
                              });
                              getAvailablePaymentMethods();
                            },
                            decoration: const InputDecoration(
                              labelText: 'Amount',
                              prefixIcon: Icon(Icons.currency_rupee),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              disabledBorder: InputBorder.none,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Column(
                            children: paymentMethods
                                .map(
                                  (method) => GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedPaymentMethod = method.name;
                                      });
                                    },
                                    child: Container(
                                      color:
                                          selectedPaymentMethod == method.name
                                              ? Colors.grey
                                              : Colors.white,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                left: BorderSide(
                                                  color: Colors.black,
                                                  width: 3.0,
                                                ),
                                              ),
                                            ),
                                            child: Radio<String>(
                                              value: method.name,
                                              groupValue: selectedPaymentMethod,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  selectedPaymentMethod = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Text(method.name),
                                          const SizedBox(width: 10),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 18),
                                            child: Image.asset(
                                              method.imagePath,
                                              height: 30,
                                              width: 30,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _isButtonLoading
                      ? const Center(child: CircularProgressIndicator())
                      : paymentMethods.isEmpty
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const WithdrawAccountsScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: const Text(
                                'ADD WITHDRAW ACCOUNT',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: withdrawFunds,
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                              ),
                              child: const Text(
                                'SEND REQUEST',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                ],
              ),
            ),
            const BottomContact()
          ],
        ),
      ),
    );
  }
}
