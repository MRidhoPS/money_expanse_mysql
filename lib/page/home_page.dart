import 'package:flutter/material.dart';
import 'package:money_expanse_mysql/model/money_model.dart';

import '../api/money_api.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({super.key, required this.userId});
  // const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Expense>> futureStudents;

  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    // futureStudents = apiService.getExpenses(widget.userId);
    futureStudents = apiService.getExpenses(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: FutureBuilder(
        future: futureStudents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No expenses found'));
          } else {
            final students = snapshot.data ?? [];
            return ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                final dataIndex = students[index];
                return ListTile(
                  title: Text(dataIndex.description),
                  subtitle: Text('Amount: ${dataIndex.amount}'),
                  // trailing: Text(dataIndex['date']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
