import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rm_official_app/provider/user_provider.dart';

import 'package:http/http.dart' as http;

void fetchBalance(context) async {
  final userProvider = Provider.of<UserProvider>(context, listen: false);
  String apiUrl = 'https://rmmatka.com/ravan/api/amount';
  Map<String, String> body = {
    'user_id': userProvider.user.id,
  };
  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: body,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse['error'] == false) {
        userProvider.setBalance(int.parse(jsonResponse['data']['amount']));
        if (kDebugMode) {
          print(jsonResponse['data']['amount']);
        }
      } else {
        if (kDebugMode) {
          print(jsonResponse['message']);
        }
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}
