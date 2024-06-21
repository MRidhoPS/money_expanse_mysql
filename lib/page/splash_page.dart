// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:money_expanse_mysql/page/home_page.dart';
// import 'package:money_expanse_mysql/page/onboarding_page.dart';

import '../api/money_api.dart';
import 'account_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
/**/
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    final userId = await apiService.getUserId();
    final username = await apiService.getUsername();
    if (!mounted) return;
    if (userId != null && username != null) {
      // Navigator.pushAndRemoveUntil(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => HomePage(userId: userId),
      //     ),
      //     (route) => false);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    userId: userId,
                    name: username,
                  )),
          (route) => false);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
