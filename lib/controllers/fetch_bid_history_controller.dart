import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/bid_history_model.dart';

Future<List<BidHistory>> fetchHistory(String userId, String startDate,
    String endDate, String type, String table, String gameType) async {
  final response = await http.post(
    Uri.parse('https://rmmatka.com/ravan/api/history'),
    body: {
      'user_id': userId,
      'start_date': startDate,
      'end_date': endDate,
      'type': type,
      'table': table,
      'game_type': gameType,
    },
  );

  if (response.statusCode == 200) {
    final dynamic responseData = json.decode(response.body)['data'];

    if (responseData != null) {
      final List<dynamic> jsonData = responseData;

      return jsonData.map((json) => BidHistory.fromJson(json)).toList();
    } else {
      return [];
    }
  } else {
    throw Exception('Failed to load history');
  }
}
