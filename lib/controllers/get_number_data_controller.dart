import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/number_data_model.dart';

Future<NumberDataModel?> getNumberData(
  bool isHalf,
) async {
  String url = 'https://rmmatka.com/app/api/full-sangam';

  if (isHalf) {
    url = 'https://rmmatka.com/app/api/half-sangam';
  }

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonMap = json.decode(response.body);
      return NumberDataModel.fromJson(jsonMap, isHalf);
    } else {
      print('Failed to load data. Status code: ${response.statusCode}');

      return null;
    }
  } catch (error) {
    print('Error: $error');
    return null;
  }
}
