import 'package:flutter/material.dart';
// import 'package:money_expanse_mysql/widget/format_app.dart';
import '../api/money_api.dart';
import '../model/money_model.dart';

class AddPage extends StatefulWidget {
  final int userId;
  const AddPage({super.key, required this.userId});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  double? amountC;
  final _formKey = GlobalKey<FormState>();

  ApiService apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Add Data")),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: amountController,
                // keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Amount'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an amount';
                  }
                  // if (double.tryParse(value) == null) {
                  //   return 'Please enter a valid number';
                  // }
                  return null;
                },
              ),
              TextFormField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                child: const Text('Add Data'),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    setState(() {});

                    final expense = Expense(
                      userId: widget.userId,
                      amount: double.parse(amountController.text),
                      description: descriptionController.text,
                      date: DateTime.now().toIso8601String(),
                    );

                    try {
                      await apiService.addEXpenses(expense, widget.userId);
                      Navigator.pop(context, true);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to add Data')),
                      );
                    }
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
