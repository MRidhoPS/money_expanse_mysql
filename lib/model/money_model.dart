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
