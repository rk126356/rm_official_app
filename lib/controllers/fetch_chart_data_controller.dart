import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/chart_model.dart';

Future<List<ChartItem>> fetchChartData(String marketId, String year) async {
  final response = await http
      .post(Uri.parse('https://rmmatka.com/app/api/get-chart'), body: {
    'market_id': marketId,
    'year': year,
  });

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonResult = json.decode(response.body);

    if (!jsonResult['error']) {
      List<dynamic> data = jsonResult['data'];
      return data.map((item) => ChartItem.fromJson(item)).toList();
    } else {
      throw Exception('Error fetching data: ${jsonResult['message']}');
    }
  } else {
    throw Exception('Failed to load data: ${response.statusCode}');
  }
}
