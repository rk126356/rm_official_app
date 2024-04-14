import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:rm_official_app/models/pana_data_model.dart';

Future<PannaResponse?> getFamilyNumber(
    int num, String table, String api) async {
  try {
    final response = await http.post(
      Uri.parse(api),
      body: {
        'number': num.toString(),
        'table': table,
      },
    );

    if (response.statusCode == 200) {
      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        final data = PannaResponse.fromJson(responseData);

        return data;
      } else {
        if (kDebugMode) {
          print('Error: Response body is empty or null');
        }
      }
    } else {
      if (kDebugMode) {
        print('Error: ${response.statusCode}');
      }
      if (kDebugMode) {
        print('Message: ${response.body}');
      }
      return null;
    }
  } catch (error) {
    if (kDebugMode) {
      print('Error: $error');
    }
    return null;
  }

  return null;
}
