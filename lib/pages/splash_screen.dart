import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalink/pages/dashboard_page.dart';
import 'package:globalink/pages/login_page.dart';
import 'package:globalink/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();

    // show login page when user is logged out else show dashboard
    Future.delayed(const Duration(seconds: 3), () {
      if (currentUser == null) {
        _openLoginPage();
      } else {
        _openDashboardPage();
      }
    });
  }

  // go to login page
  void _openLoginPage() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const LoginPage()));
  }

  // go to dashboard page
  void _openDashboardPage() {
    // load user data
    Provider.of<UserProvider>(context, listen: false).getUsers();

    Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => const DashboardPage()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Welcome to GlobaLink'),
      ),
    );
  }
}
