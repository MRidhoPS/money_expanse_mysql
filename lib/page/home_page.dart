import 'package:flutter/material.dart';
import '../api/money_api.dart';
import '../model/money_model.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Expense>> futureExpenses;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void fetchExpenses() {
    futureExpenses = apiService.getExpenses(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: FutureBuilder<List<Expense>>(
        future: futureExpenses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses found'));
          } else {
            final expenses = snapshot.data ?? [];
            return ListView.builder(
              itemCount: expenses.length,
              itemBuilder: (BuildContext context, int index) {
                final expense = expenses[index];
                return ListTile(
                  title: Text(expense.description),
                  subtitle: Text('Amount: ${expense.amount}'),
                  trailing: Text(expense.date),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddPage(userId: widget.userId),
            ),
          );
          if (result == true) {
            setState(() {
              fetchExpenses(); // Fetch latest data when returning to the home page
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
