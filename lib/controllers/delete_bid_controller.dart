import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/bid_history_model.dart';

Future<bool> deleteBid(BidHistory bid, String userId) async {
  String apiUrl = 'https://rmmatka.com/ravan/api/delete-bid';

  Map<String, String> body = {
    'user_id': userId,
    'ticket_id': bid.ticketId,
    'type': bid.isWin.toString().isNotEmpty ? '2' : '1',
    'table': 'bids',
  };

  try {
    final response = await http.post(
      Uri.parse(apiUrl),
      body: body,
    );

    final Map<String, dynamic> data = json.decode(response.body);

    print(data);

    if (data['error'] == false) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    if (kDebugMode) {
      print('Error: $e');
    }
    return false;
  }
}
