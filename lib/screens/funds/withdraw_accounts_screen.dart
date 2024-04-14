// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rm_official_app/widgets/bottom_contact_widget.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:rm_official_app/widgets/heading_logo_widget.dart';
import 'package:rm_official_app/widgets/success_snackbar_widget.dart';

import '../../const/colors.dart';
import '../../provider/user_provider.dart';
import '../../widgets/app_bar_widget.dart';

class WithdrawAccountsScreen extends StatefulWidget {
  const WithdrawAccountsScreen({super.key});

  @override
  State<WithdrawAccountsScreen> createState() => _WithdrawAccountsScreenState();
}

class _WithdrawAccountsScreenState extends State<WithdrawAccountsScreen> {
  TextEditingController upiController = TextEditingController();
  TextEditingController beneficiaryNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();
  TextEditingController bankAddressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _isButtonLoading = false;
  bool _upiButtonLoading = false;

  Future<void> updateUpi() async {
    if (upiController.text.length < 4) {
      showCoolErrorSnackbar(context, 'Please enter a valid UPI details');
      return;
    }
    const apiUrl = 'https://rmmatka.com/app/api/update-upi';
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _upiButtonLoading = true;
    });

    try {
      var response = await http.post(Uri.parse(apiUrl), body: {
        'user_id': userProvider.user.id,
        'type': 'PayTm Upi',
        'upi_id': upiController.text,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
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

    setState(() {
      _upiButtonLoading = false;
    });
  }

  Future<void> getUpi() async {
    const apiUrl = 'https://rmmatka.com/app/api/get-upi';
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _upiButtonLoading = true;
    });

    try {
      var response = await http.post(Uri.parse(apiUrl), body: {
        'user_id': userProvider.user.id,
        'type': 'PayTm Upi',
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
          final upi = data['data']['upi_id'];

          upiController.text = upi;
          userProvider.user.upi = upi;
        }
      } else {
        showCoolSuccessSnackbar(context, 'Error fetching UPI details');
      }
    } catch (e) {
      showCoolSuccessSnackbar(context, 'Error: $e');
    }

    setState(() {
      _upiButtonLoading = false;
    });
  }

  Future<void> updateBankDetails() async {
    const apiUrl = 'https://rmmatka.com/app/api/add-bank-details';
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isButtonLoading = true;
      });

      try {
        var response = await http.post(Uri.parse(apiUrl), body: {
          'user_id': userProvider.user.id,
          'customer_name': beneficiaryNameController.text,
          'bank_name': bankNameController.text,
          'bank_account_number': bankAccountNumberController.text,
          'ifsc_code': ifscCodeController.text,
          'bank_address': bankAddressController.text,
        });

        if (response.statusCode == 200) {
          Map<String, dynamic> data = json.decode(response.body);
          if (data['error'] == false) {
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

      setState(() {
        _isButtonLoading = false;
      });
    }
  }

  Future<void> getBankDetails() async {
    const apiUrl = 'https://rmmatka.com/app/api/get-bank-details';
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    setState(() {
      _isButtonLoading = true;
    });

    try {
      var response = await http.post(Uri.parse(apiUrl), body: {
        'user_id': userProvider.user.id,
      });

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        if (data['error'] == false) {
          final name = data['data']['customer_name'];
          final bankName = data['data']['bank_name'];
          final bankAccountNumber = data['data']['bank_account_number'];
          final ifsc = data['data']['ifsc_code'];
          final bankAddress = data['data']['bank_address'];

          beneficiaryNameController.text = name;
          bankNameController.text = bankName;
          bankAccountNumberController.text = bankAccountNumber;
          ifscCodeController.text = ifsc;
          bankAddressController.text = bankAddress;

          userProvider.user.bankAccountNumber = bankAccountNumber;
          userProvider.user.bankAddress = bankAddress;
          userProvider.user.bankName = name;
          userProvider.user.ifscCode = ifsc;
          userProvider.user.bankName = bankName;
        }
      } else {
        showCoolSuccessSnackbar(context, 'Error fetching UPI details');
      }
    } catch (e) {
      showCoolSuccessSnackbar(context, 'Error: $e');
    }

    setState(() {
      _isButtonLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getUpi();
    getBankDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: const AppBarWidget(
        title: 'WITHDRAW ACCOUNTS',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const HeadingLogo(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 239, 196, 110),
                      border: Border.all(color: Colors.black),
                      borderRadius: const BorderRadius.all(Radius.circular(12)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/other_upi.png',
                              width: 50,
                            ),
                            const Text(
                              'ENTER UPI DETAILS',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextField(
                            controller: upiController,
                            style: TextStyle(fontSize: 12),
                            decoration: const InputDecoration(
                              labelText: 'ENTER YOUR UPI ID',
                              labelStyle: TextStyle(fontSize: 12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        _upiButtonLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Center(
                                child: ElevatedButton(
                                  onPressed: updateUpi,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: const Text(
                                    'ADD UPI DETAILS',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Form(
                    key: _formKey,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 239, 196, 110),
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/images/bank.png',
                                width: 28,
                              ),
                              // SizedBox(
                              //   width: 12,
                              // ),
                              const Text(
                                'ENTER BANK DETAILS',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          _buildFormField(
                            controller: beneficiaryNameController,
                            labelText: 'BENEFICIARY NAME',
                          ),
                          const SizedBox(height: 4),
                          _buildFormField(
                            controller: bankNameController,
                            labelText: 'BANK NAME',
                          ),
                          const SizedBox(height: 4),
                          _buildFormField(
                            controller: bankAccountNumberController,
                            labelText: 'BANK ACCOUNT NUMBER',
                          ),
                          const SizedBox(height: 4),
                          _buildFormField(
                            controller: ifscCodeController,
                            labelText: 'IFSC CODE',
                          ),
                          const SizedBox(height: 4),
                          _buildFormField(
                            controller: bankAddressController,
                            labelText: 'BANK ADDRESS',
                          ),
                          const SizedBox(height: 8),
                          _isButtonLoading
                              ? const Center(child: CircularProgressIndicator())
                              : Center(
                                  child: ElevatedButton(
                                    onPressed: updateBankDetails,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                    child: const Text(
                                      'ADD BANK DETAILS',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
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

  Widget _buildFormField({
    required TextEditingController controller,
    required String labelText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: controller,
        style: TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: 12),
          border: InputBorder.none,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }
}
