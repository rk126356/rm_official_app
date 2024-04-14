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
  const apiUrl = 'https://rmmatka.com/app/api/Market-bids';
  Map<String, String> requestBody;
  if (title == 'SINGLE DIGIT') {
    requestBody = {
      'bid_point': bid.betAmount.toString(),
      'single_digit': bid.sNo.toString(),
      'market_id': marketId,
      'session': isOpen.toLowerCase(),
      'type': title.toLowerCase(),
      'user_id': userId,
      'game_category': title,
    };
  } else if (title == 'JODI DIGIT') {
    requestBody = {
      'bid_point': bid.betAmount.toString(),
      'double_digit': title.toLowerCase() == 'jodi digit'
          ? bid.sNo.toString().padLeft(2, '0')
          : bid.sNo.toString(),
      'market_id': marketId,
      'session': isOpen.toLowerCase(),
      'type': title.toLowerCase(),
      'user_id': userId,
      'game_category': title,
    };
  } else if (title == 'SINGLE PANNA') {
    requestBody = {
      'bid_point': bid.betAmount.toString(),
      'single_pana': bid.sNo.toString(),
      'market_id': marketId,
      'session': isOpen.toLowerCase(),
      'type': title.toLowerCase(),
      'user_id': userId,
      'game_category': title,
    };
  } else if (title == 'DOUBLE PANNA') {
    requestBody = {
      'bid_point': bid.betAmount.toString(),
      'double_pana': bid.sNo.toString(),
      'market_id': marketId,
      'session': isOpen.toLowerCase(),
      'type': title.toLowerCase(),
      'user_id': userId,
      'game_category': title,
    };
  } else {
    requestBody = {
      'bid_point': bid.betAmount.toString(),
      'triple_pana': bid.sNo == 0 ? '000' : bid.sNo.toString(),
      'market_id': marketId,
      'session': isOpen.toLowerCase(),
      'type': title.toLowerCase(),
      'user_id': userId,
      'game_category': title,
    };
  }

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
