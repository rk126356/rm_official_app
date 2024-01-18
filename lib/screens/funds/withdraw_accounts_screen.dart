// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:rm_official_app/widgets/error_snackbar_widget.dart';
import 'package:rm_official_app/widgets/success_snackbar_widget.dart';

import '../../const/colors.dart';
import '../../provider/user_provider.dart';

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
    const apiUrl = 'https://rmmatka.com/ravan/api/update-upi';
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
    const apiUrl = 'https://rmmatka.com/ravan/api/get-upi';
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
    const apiUrl = 'https://rmmatka.com/ravan/api/add-bank-details';
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
    const apiUrl = 'https://rmmatka.com/ravan/api/get-bank-details';
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
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppColors.redType,
        title: const Text(
          'Withdraw Accounts',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 16),
                decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(12))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'ENTER UPI DETAILS',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 16),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      TextField(
                        controller: upiController,
                        decoration: const InputDecoration(
                          labelText: 'ENTER YOUR UPI ID',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          disabledBorder: InputBorder.none,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _upiButtonLoading
                          ? const Center(child: CircularProgressIndicator())
                          : Center(
                              child: ElevatedButton(
                                onPressed: updateUpi,
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                                child: const Text(
                                  'ADD UPI DETAILS',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Form(
                key: _formKey,
                child: Container(
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
                          'ENTER BANK DETAILS',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 16),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: beneficiaryNameController,
                          decoration: const InputDecoration(
                            labelText: 'BENEFICIARY NAME',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter beneficiary name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: bankNameController,
                          decoration: const InputDecoration(
                            labelText: 'BANK NAME',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter bank name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: bankAccountNumberController,
                          decoration: const InputDecoration(
                            labelText: 'BANK ACCOUNT NUMBER',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter bank account number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: ifscCodeController,
                          decoration: const InputDecoration(
                            labelText: 'IFSC CODE',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter IFSC code';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        TextFormField(
                          controller: bankAddressController,
                          decoration: const InputDecoration(
                            labelText: 'BANK ADDRESS',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter bank address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        _isButtonLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Center(
                                child: ElevatedButton(
                                  onPressed: updateBankDetails,
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: Colors.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'ADD BANK DETAILS',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
