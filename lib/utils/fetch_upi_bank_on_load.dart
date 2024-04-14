import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../provider/user_provider.dart';

Future<void> getUpi(context) async {
  const apiUrl = 'https://rmmatka.com/app/api/get-upi';
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  try {
    var response = await http.post(Uri.parse(apiUrl), body: {
      'user_id': userProvider.user.id,
      'type': 'PayTm Upi',
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      if (data['error'] == false) {
        final upi = data['data']['upi_id'];

        userProvider.user.upi = upi;
      }
    } else {}
  } catch (e) {}
}

Future<void> getBankDetails(context) async {
  const apiUrl = 'https://rmmatka.com/app/api/get-bank-details';
  final userProvider = Provider.of<UserProvider>(context, listen: false);

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

        userProvider.user.bankAccountNumber = bankAccountNumber;
        userProvider.user.bankAddress = bankAddress;
        userProvider.user.bankName = name;
        userProvider.user.ifscCode = ifsc;
        userProvider.user.bankName = bankName;
      }
    } else {}
  } catch (e) {}
}
