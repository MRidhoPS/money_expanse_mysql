import 'package:flutter/material.dart';
import 'package:money_expanse_mysql/page/splash_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 248, 252, 255),
        appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 248, 252, 255)),
      ),
      home: const SplashScreen(),
    );
  }
}
