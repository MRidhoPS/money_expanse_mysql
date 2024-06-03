// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:money_expanse_mysql/model/money_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${configapp.baseUrl}/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      print("Login successful");
      final responData = jsonDecode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('userId', responData['user_id']);
      return responData;
    } else {
      print("Login failed: ${response.body}");
      throw Exception('Failed to login');
    }
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<List<Expense>> getExpenses(int userID) async {
    final response = await http.get(
      Uri.parse('${configapp.baseUrl}/expenses/$userID'),
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Expense> expenses =
          body.map((dynamic item) => Expense.fromList(item)).toList();
      return expenses;
    } else {
      throw Exception('Failed to load expenses');
    }
  }

  Future<void> addEXpenses(Expense expense, int userId) async {
    final response = await http.post(
        Uri.parse('${configapp.addExpenseUrl}/$userId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        // jsonEncode mengubah dari dart object menjadi sebuah format json untuk input data, karena data yang di input harus berupa json
        body: jsonEncode(expense.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to add student');
    }
  }
}
