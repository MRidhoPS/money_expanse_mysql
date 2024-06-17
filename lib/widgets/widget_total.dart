import 'package:flutter/material.dart';

import 'format_app.dart';

class WidgetTotal extends StatelessWidget {
  const WidgetTotal({
    super.key,
    required this.totalExpense,
  });

  final Future totalExpense;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 4.5,
        width: MediaQuery.of(context).size.width / 2.5,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                  color: Colors.black12, blurRadius: 5, offset: Offset(5, 4)),
            ]),
        child: FutureBuilder(
          future: totalExpense,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              double total = snapshot.data;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Total Expenses:',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 30),
                  ),
                  Text(
                    formatCurrency(total),
                    style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              );
            }
          },
        ));
  }
}
