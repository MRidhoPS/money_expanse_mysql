import 'package:flutter/material.dart';
import '../api/money_api.dart';
import '../model/money_model.dart';
import '../widget/format_app.dart';
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
                  Container(
                      height: MediaQuery.of(context).size.height / 4.5,
                      width: MediaQuery.of(context).size.width / 2.5,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(5, 4)),
                          ]),
                      child: FutureBuilder(
                        future: totalExpense,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            double total = snapshot.data ?? 0.0;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Total Expenses:'),
                                Text(formatCurrency(total))
                              ],
                            );
                          }
                        },
                      )),
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
                            margin: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.amber,
                            ),
                            child: ListTile(
                              title: Text(expense.description),
                              subtitle: Text('Amount: ${formatCurrency(expense.amount)}'),
                              // subtitle: Text(
                              //     'Amount: ${formatCurrency(expense.amount)}'),
                              trailing: Text(expense.date),
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
