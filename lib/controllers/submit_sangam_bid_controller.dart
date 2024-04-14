import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/models/sangam_bid_model.dart';

Future<Map<String, dynamic>> submitSangamBid({
  required SangamBidModel bid,
  required String isOpen,
  required String title,
  required String marketId,
  required String userId,
}) async {
  const apiUrl = 'https://rmmatka.com/app/api/Market-bids';
  Map<String, String> requestBody;
  if (title == 'HALF SANGAM') {
    requestBody = {
      'bid_point': bid.betAmount.toString(),
      'open_digit': bid.open.toString(),
      'close_pana': bid.close.toString(),
      'market_id': marketId,
      'session': isOpen.toLowerCase(),
      'type': title.toLowerCase(),
      'user_id': userId,
      'game_category': title,
    };
  } else {
    requestBody = {
      'bid_point': bid.betAmount.toString(),
      'open_pana': bid.open.toString(),
      'close_pana': bid.close.toString(),
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
