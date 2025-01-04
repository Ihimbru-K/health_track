import 'dart:convert';
import 'package:flutter/services.dart';

class ApiService {
  Future<String> fetchMotivationalMessage() async {
    final String data = await rootBundle.loadString('assets/motivational_messages.json');
    final Map<String, dynamic> json = jsonDecode(data);
    return json['message'];
  }
}
