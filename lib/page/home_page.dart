// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:money_expanse_mysql/page/account_login.dart';
// import 'package:money_expanse_mysql/page/edit_page.dart';
import '../api/money_api.dart';
import '../model/money_model.dart';
// import '../widgets/format_app.dart';
// import '../widgets/widget_total.dart';
// import 'add_page.dart';

class HomePage extends StatefulWidget {
  final int userId;
  final String? name;

  const HomePage({super.key, required this.userId, this.name});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Expense>> futureExpenses;
  late Future<List<Money>> futureMoney;
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
      body: Column(
        children: [
          Stack(
            alignment: AlignmentDirectional.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height / 3,
                decoration: const BoxDecoration(
                  color: Colors.amber,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(50),
                    bottomRight: Radius.circular(50),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 50, bottom: 30, right: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Hai,",
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            widget.name ?? "No Name",
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.account_circle_outlined,
                          color: Colors.white,
                          size: 70,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: -45,
                child: Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.height / 10,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 0.8,
                                spreadRadius: 0.4,
                                offset: Offset(1, 1))
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          )),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: MediaQuery.of(context).size.height / 10,
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                blurRadius: 0.8,
                                spreadRadius: 0.4,
                                offset: Offset(1, 1))
                          ],
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),

      // body: Padding(
      //   padding: const EdgeInsets.all(20.0),
      //   child: SingleChildScrollView(
      //     scrollDirection: Axis.vertical,
      //     child: Column(
      //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //       children: [
      //         Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           children: [
      //             WidgetTotal(totalExpense: totalExpense),
      //           ],
      //         ),
      //         const SizedBox(
      //           height: 10,
      //         ),
      //         SizedBox(
      //           width: MediaQuery.of(context).size.width,
      //           height: MediaQuery.of(context).size.height,
      //           // color: Colors.cyan[50],
      //           child: FutureBuilder<List<Expense>>(
      //             future: futureExpenses,
      //             builder: (context, snapshot) {
      //               if (snapshot.connectionState == ConnectionState.waiting) {
      //                 return const Center(child: CircularProgressIndicator());
      //               } else if (snapshot.hasError) {
      //                 return Center(child: Text('Error: ${snapshot.error}'));
      //               } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
      //                 return const Center(child: Text('No expenses found'));
      //               } else {
      //                 final expenses = snapshot.data ?? [];
      //                 return ListView.builder(
      //                   itemCount: expenses.length,
      //                   itemBuilder: (BuildContext context, int index) {
      //                     final expense = expenses[index];
      //                     return Container(
      //                       margin: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      //                       decoration: BoxDecoration(
      //                           borderRadius: BorderRadius.circular(7),
      //                           color: Colors.white,
      //                           boxShadow: const [
      //                             BoxShadow(
      //                                 color: Colors.black12,
      //                                 blurRadius: 5,
      //                                 offset: Offset(5, 4)),
      //                           ]),
      //                       child: ListTile(
      //                         leading: IconButton(
      //                             onPressed: () {
      //                               Navigator.push(
      //                                 context,
      //                                 MaterialPageRoute(
      //                                   builder: (context) => EditPage(
      //                                     userId: widget.userId,
      //                                     expenseId: expense.expenseId!,
      //                                     expense: expense,
      //                                   ),
      //                                 ),
      //                               );
      //                             },
      //                             icon: const Icon(Icons.edit)),
      //                         title: Text(expense.description,
      //                           style: const TextStyle(
      //                               color: Colors.black,
      //                               fontWeight: FontWeight.w500,
      //                               fontSize: 18),
      //                         ),
      //                         subtitle: Text(
      //                           'Amount: ${formatCurrency(expense.amount)}',
      //                           style: const TextStyle(
      //                             color: Colors.black87,
      //                             fontWeight: FontWeight.w400,
      //                             fontSize: 14,
      //                             fontStyle: FontStyle.italic,
      //                           ),
      //                         ),
      //                         trailing: IconButton(
      //                             icon: const Icon(Icons.delete),
      //                             onPressed: () async {
      //                               try {
      //                                 await apiService.deleteExpense(
      //                                     widget.userId, expense.expenseId!);
      //                                 // Refresh the list or update the UI to reflect the deletion
      //                                 setState(() {
      //                                   fetchExpenses();
      //                                 });
      //                                 ScaffoldMessenger.of(context)
      //                                     .showSnackBar(
      //                                   const SnackBar(
      //                                       content: Text(
      //                                           'Expense deleted successfully')),
      //                                 );
      //                               } catch (e) {
      //                                 ScaffoldMessenger.of(context)
      //                                     .showSnackBar(
      //                                   SnackBar(
      //                                       content: Text(
      //                                           'Failed to delete expense: $e')),
      //                                 );
      //                               }
      //                             }),
      //                       ),
      //                     );
      //                   },
      //                 );
      //               }
      //             },
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () async {
      //     final result = await Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => AddPage(userId: widget.userId),
      //       ),
      //     );
      //     if (result == true) {
      //       setState(() {
      //         fetchExpenses(); // Fetch latest data when returning to the home page
      //       });
      //     }
      //   },
      //   child: const Icon(Icons.add),
      // ),
    );
  }
}
