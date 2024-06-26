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
      Uri.parse(configapp.loginUrl),
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
      await prefs.setString('name', responData['username']);
      return responData;
    } else {
      print("Login failed: ${response.body}");
      throw Exception('Failed to login');
    }
  }

  Future<dynamic> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<dynamic> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('name');
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    // Remove userId and other related data
    await prefs.remove('userId');
    await prefs.remove('name');
    // Add any other data that needs to be cleared
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

  Future<double> getTotalExpenses(int userId) async {
    final response = await http
        .get(Uri.parse('${configapp.baseUrl}/expenses/total/$userId'));

    if (response.statusCode == 200) {
      // Mengambil dan memeriksa data dari respons API
      Map<String, dynamic> data = jsonDecode(response.body);

      if (data.containsKey('total_expenses') &&
          data['total_expenses'] != null) {
        final total = double.parse(data['total_expenses']);
        return total;
      } else {
        return 0.0;
      }
    } else {
      // Jika respons API gagal, lemparkan pengecualian
      throw Exception('Failed to load total expenses');
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

  Future<void> deleteExpense(int userId, int expenseId) async {
    final response = await http.delete(
      Uri.parse('${configapp.deleteExpenseUrl}/$userId/$expenseId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete data');
    }
  }

  Future<void> editExpense(int userId, int expenseId, Expense expense) async {
    final response = await http.put(
        Uri.parse("${configapp.updateExpenseUrl}/$userId/$expenseId"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(expense.editJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to update student');
    } else {
      print(response.body);
    }
  }
}
