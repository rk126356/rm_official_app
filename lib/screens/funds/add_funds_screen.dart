// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:easy_upi_payment/easy_upi_payment.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/const/colors.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:rm_official_app/widgets/heading_logo_widget.dart';
import 'package:http/http.dart' as http;

import '../../provider/user_provider.dart';
import '../../widgets/success_snackbar_widget.dart';
import '../navigation/bottom_navigation.dart';

class AddFundsScreen extends StatefulWidget {
  const AddFundsScreen({Key? key}) : super(key: key);

  @override
  State<AddFundsScreen> createState() => _AddFundsScreenState();
}

class PaymentMethod {
  final String name;
  final String imagePath;

  PaymentMethod({required this.name, required this.imagePath});
}

class _AddFundsScreenState extends State<AddFundsScreen> {
  String? selectedPaymentMethod;
  int amount = 0;
  bool _isButtonLoading = false;
  int minimumDeposit = 10;
  String merchantId = '';
  String merchantName = '';

  List<PaymentMethod> paymentMethods = [
    PaymentMethod(name: 'PAYTM', imagePath: 'assets/images/paytm.png'),
    PaymentMethod(name: 'PHONEPE', imagePath: 'assets/images/phonepe.png'),
    PaymentMethod(name: 'GPAY', imagePath: 'assets/images/gpay.png'),
    PaymentMethod(name: 'OTHERS', imagePath: 'assets/images/other_upi.png'),
  ];

  void fetchWalletSettings() async {
    const apiUrl = 'https://rmmatka.com/ravan/api/wallet-setting';

    setState(() {
      _isButtonLoading = true;
    });

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
          minimumDeposit = int.parse(data['data']['minimum_deposit']);
          setState(() {
            _isButtonLoading = false;
          });
        }
      } else {
        showCoolSuccessSnackbar(context, 'Error fetching wallet settings');
      }
    } catch (e) {
      showCoolSuccessSnackbar(context, 'Error: $e');
    }
  }

  void fetchUpiSettings() async {
    const apiUrl = 'https://rmmatka.com/ravan/api/upi-setting';

    setState(() {
      _isButtonLoading = true;
    });

    try {
      var response = await http.get(
        Uri.parse(apiUrl),
      );

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
          merchantId = data['data']['merchant_id'];
          merchantName = data['data']['marchant_name'];

          setState(() {
            _isButtonLoading = false;
          });
        }
      } else {
        showCoolSuccessSnackbar(context, 'Error fetching wallet settings');
      }
    } catch (e) {
      showCoolSuccessSnackbar(context, 'Error: $e');
    }
  }

  Future<void> addBalanceApi(String amount, String merchant) async {
    const apiUrl = 'https://rmmatka.com/ravan/api/add-balance';
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      var response = await http.post(Uri.parse(apiUrl), headers: {
        'Userid': userProvider.user.id,
        'Token': '',
      }, body: {
        'user_id': userProvider.user.id,
        'amount': amount,
        'merchant_id': merchant,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const NavigationBarApp(),
            ),
          );
          showCoolSuccessSnackbar(context, data['message']);
        } else {
          showCoolSuccessSnackbar(context, data['message']);
        }
      } else {
        showCoolSuccessSnackbar(context, 'Error adding UPI details');
      }
    } catch (e) {
      showCoolSuccessSnackbar(context, 'Error: $e');
    }
  }

  Future<void> addBalance() async {
    if (amount < minimumDeposit) {
      showCoolErrorSnackbar(context, 'Minimum amount is 500');
      return;
    }
    if (selectedPaymentMethod != null) {
      setState(() {
        _isButtonLoading = true;
      });
      try {
        final res = await EasyUpiPaymentPlatform.instance.startPayment(
          EasyUpiPaymentModel(
            payeeVpa: merchantId,
            payeeName: merchantName,
            amount: amount.toDouble(),
            description: "For Today's Food",
          ),
        );

        if (res != null && res.responseCode == '0') {
          await addBalanceApi(res.amount ?? amount.toString(),
              res.transactionRefId ?? 'No Ref ID');
        } else {
          showCoolErrorSnackbar(context, 'Failed to add balance');
        }
      } on EasyUpiPaymentException {
        showCoolErrorSnackbar(context, 'Failed to add balance');
      }
      setState(() {
        _isButtonLoading = false;
      });
    } else {
      showCoolErrorSnackbar(context, 'Please select a payment method');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWalletSettings();
    fetchUpiSettings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.redType,
        title: const Text(
          'Add Funds',
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
                            'ENTER AMOUNT TO DEPOSIT',
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
                            readOnly: _isButtonLoading ? true : false,
                            onChanged: (value) {
                              setState(() {
                                amount = int.parse(value);
                              });
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
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                              color: selectedPaymentMethod == method.name
                                  ? Colors.grey
                                  : Colors.white,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(left: 10),
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
                                    padding: const EdgeInsets.only(right: 18),
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
                  const SizedBox(height: 20),
                  _isButtonLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: addBalance,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: const Text(
                            'ADD BALANCE',
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
