import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../models/today_market_model.dart';
import 'package:http/http.dart' as http;

Future<bool> fetchIsWalletOn(String userid) async {
  String apiUrl = 'https://rmmatka.com/app/api/today-markets';

  Map<String, String> body = {
    'user_id': userid,
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: body,
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonResponse = json.decode(response.body);

      if (jsonResponse.containsKey('error') && jsonResponse['error'] == false) {
        List<dynamic> dataList = jsonResponse['data'];

        for (var data in dataList) {
          final market = MarketList.fromJson(data);
          if (market.onWallet == '0') {
            return false;
          }
        }
      } else {
        if (kDebugMode) {
          print('Error: ${jsonResponse['message']}');
        }
      }
    } else {
      if (kDebugMode) {
        print('Request failed with status: ${response.statusCode}');
      }
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error: $error');
    }
  }
  return true;
}
