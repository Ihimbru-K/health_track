import 'dart:convert';
import 'package:flutter/services.dart';

class ApiService {

  ///fetches message from motivational_messages.json
  Future<String> fetchMotivationalMessage() async {
    final String data = await rootBundle.loadString('lib/assets/motivational_messages.json');
    final Map<String, dynamic> json = jsonDecode(data);
    return json['message'];
  }


  ///fetches wearable data from wearable_data.json

  Future<Map<String, dynamic>> fetchHealthMetrics() async {
    final String data = await rootBundle.loadString('lib/assets/wearable_data.json');
    return jsonDecode(data);
  }

  Future<Map<String, dynamic>> fetchWearableData() async {
    try {
      final response = await rootBundle.loadString('lib/assets/wearable_data.json');
      return json.decode(response);
    } catch (e) {
      return {"steps": 7200, "heartRate": 0};
    }
  }
}
