import 'package:flutter/material.dart';
import 'package:money_expanse_mysql/page/edit_page.dart';
import '../api/money_api.dart';
import '../model/money_model.dart';
import '../widgets/format_app.dart';
import '../widgets/widget_total.dart';
import 'add_page.dart';

class HomePage extends StatefulWidget {
  final int userId;

  const HomePage({super.key, required this.userId});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Expense>> futureExpenses;
  late Future<dynamic> totalExpense;
  ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    fetchExpenses();
  }

  void fetchExpenses() {
    futureExpenses = apiService.getExpenses(widget.userId);
    totalExpense = apiService.getTotalExpenses(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Money Tracking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  WidgetTotal(totalExpense: totalExpense),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                // color: Colors.cyan[50],
                child: FutureBuilder<List<Expense>>(
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
                          return Container(
                            margin: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(7),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                      offset: Offset(5, 4)),
                                ]),
                            child: ListTile(
                              leading: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => EditPage(
                                          userId: widget.userId,
                                          expenseId: expense.expenseId!,
                                          expense: expense,
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.edit)),
                              title: Text(expense.description,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 18),
                              ),
                              subtitle: Text(
                                'Amount: ${formatCurrency(expense.amount)}',
                                style: const TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                              trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () async {
                                    try {
                                      await apiService.deleteExpense(
                                          widget.userId, expense.expenseId!);
                                      // Refresh the list or update the UI to reflect the deletion
                                      setState(() {
                                        fetchExpenses();
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Expense deleted successfully')),
                                      );
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to delete expense: $e')),
                                      );
                                    }
                                  }),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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
