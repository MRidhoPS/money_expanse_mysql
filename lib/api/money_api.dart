// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:money_expanse_mysql/model/money_model.dart';
import 'money_api_config.dart' as config_api;

class ApiService {
  final configapp = config_api.ApiConfig();

  Future<void> registerAccount(Money money) async {
    final response = await http.post(
      Uri.parse('${configapp.baseUrl}/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(money.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed Regist Account student');
    }
  }
}
