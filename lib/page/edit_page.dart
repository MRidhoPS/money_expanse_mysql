import 'package:flutter/material.dart';
import 'package:money_expanse_mysql/api/money_api.dart';
import 'package:money_expanse_mysql/model/money_model.dart';
import 'package:money_expanse_mysql/page/home_page.dart';

class EditPage extends StatefulWidget {
  final int userId;
  final int expenseId;
  final Expense? expense;

  const EditPage(
      {super.key, this.expense, required this.userId, required this.expenseId});

  @override
  State<EditPage> createState() => _EditPage();
}

class _EditPage extends State<EditPage> {
  TextEditingController _amountC = TextEditingController();
  TextEditingController _descC = TextEditingController();

  ApiService apiService = ApiService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _amountC = TextEditingController(text: (widget.expense!.amount.toString()));
    _descC = TextEditingController(text: widget.expense!.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Form(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _amountC,
              ),
              TextFormField(
                controller: _descC,
              ),
              ElevatedButton(
                child: const Text("Update"),
                onPressed: () async {
                  // print("The amount is: ${_amountC.text}");
                  // print("The desc is: ${_descC.text}");
                  setState(() {});
                  try {
                    final result = Expense(
                        userId: widget.expense!.userId,
                        amount: double.parse(_amountC.text),
                        description: _descC.text,
                        date: DateTime.now().toIso8601String());
                    await apiService.editExpense(
                        widget.userId, widget.expenseId, result);
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => HomePage(userId: widget.userId),
                        ),
                        (route) => false);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text(
                              'Failed to update on ${widget.userId} and ${widget.expenseId}')),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
