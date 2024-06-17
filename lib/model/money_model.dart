class Money {
  int? userid;
  String username;
  String email;
  String password;

  Money(
      {this.userid,
      required this.email,
      required this.username,
      required this.password});

  factory Money.fromJson(Map<String, dynamic> json) {
    return Money(
      userid: json['user_id'],
      email: json['email'],
      username: json['username'],
      password: json['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }
}

class Expense {
  final int? expenseId;
  final int userId;
  final double amount;
  final String description;
  final String date;

  Expense({
    this.expenseId,
    required this.userId,
    required this.amount,
    required this.description,
    required this.date,
  });

  factory Expense.fromList(List<dynamic> json) {

    return Expense(
      expenseId: json[0],
      userId: json[1],
      amount: json[2],
      description: json[3],
      date: json[4],
    );
  }

  Map<String, dynamic> toJson(){
    return {
      'amount': amount,
      'description': description,
      'date': date
    };
  }

   Map<String, dynamic> editJson() {
    return {
      'expense_id': expenseId,
      'user_id': userId,
      'amount': amount,
      'description': description,
      'date': date,
    };
  }

}
