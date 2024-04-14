import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/models/family_bid_model.dart';

Future<Map<String, dynamic>> submitAllPana({
  required FamilyBids bids,
  required String isOpen,
  required String marketId,
  required String userId,
  required String api,
  String? type,
  required String title,
}) async {
  String apiUrl = api;

  String bidsJson = jsonEncode({
    'bids': [
      {
        "type": type ?? 'patta_group',
        "number": bids.digit.toString(),
        "bid_point": bids.amount.toString(),
        'game_category': title,
      }
    ],
  });

  if (api == 'https://rmmatka.com/app/api/cycle-bids') {
    bidsJson = jsonEncode({
      'bids': [
        {
          // "type": 'panna',
          "num_cycle": bids.digit.toString(),
          "bid_point": bids.amount.toString(),
          'game_category': title,
        }
      ],
    });
  }

  try {
    print(bidsJson);

    final httpResponse = await http.post(
      Uri.parse(apiUrl),
      body: {
        'bids': bidsJson,
        'market_id': marketId,
        'user_id': userId,
        'session': isOpen.toLowerCase(),
      },
    );

    if (httpResponse.statusCode == 200) {
      final responseData = json.decode(httpResponse.body);
      return responseData;
    } else {
      if (kDebugMode) {
        print('Error calling API. Status code: ${httpResponse.statusCode}');
      }
      return {
        'error': true,
        'message': 'Error calling API',
        'data': null,
      };
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error calling API: $e');
    }
    return {
      'error': true,
      'message': 'Error calling API',
      'data': null,
    };
  }
}
