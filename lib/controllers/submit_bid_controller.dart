import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/calculate_bid_model.dart';

Future<Map<String, dynamic>> submitBid({
  required CalculateBid bid,
  required String isOpen,
  required String title,
  required String marketId,
  required String userId,
}) async {
  const apiUrl = 'https://rmmatka.com/ravan/api/Market-bids';
  final requestBody = {
    'bid_point': bid.betAmount.toString(),
    'triple_pana': title.toLowerCase() == 'jodi digit'
        ? bid.sNo.toString().padLeft(2, '0')
        : bid.sNo.toString(),
    'market_id': marketId,
    'session': isOpen.toLowerCase(),
    'type': title.toLowerCase(),
    'user_id': userId,
  };

  try {
    final httpResponse = await http.post(
      Uri.parse(apiUrl),
      body: requestBody,
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
