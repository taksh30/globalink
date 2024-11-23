import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:globalink/pages/dashboard_page.dart';
import 'package:globalink/pages/register_page.dart';
import 'package:globalink/providers/user_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginKey = GlobalKey<FormState>();

  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();

  bool isLoading = false;

  // login
  Future<void> _login() async {
    try {
      final email = _emailCtr.text;
      final password = _passwordCtr.text;

      // sign in the user
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // show snackbar on success
      SnackBar snackBar = const SnackBar(content: Text('Login Successfully!'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Provider.of<UserProvider>(context, listen: false).getUsers();
      }

      // navigate to dashboard page
      if (mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const DashboardPage()),
            (route) {
          return false;
        });
      }

      // clear the textfields
      _emailCtr.clear();
      _passwordCtr.clear();
    } catch (e) {
      // show error snackbar
      SnackBar snackBar = SnackBar(content: Text(e.toString()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
      ),
      body: SafeArea(
        child: Center(
          child: Form(
            key: loginKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // email
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _emailCtr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email is required!';
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    constraints: const BoxConstraints(maxWidth: 350),
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),

                // password
                TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _passwordCtr,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required!';
                    } else {
                      return null;
                    }
                  },
                  autocorrect: false,
                  obscureText: true,
                  enableSuggestions: false,
                  decoration: InputDecoration(
                    constraints: const BoxConstraints(maxWidth: 350),
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        12.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),

                // login button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40.0, vertical: 12.0)),

                  // on login button
                  onPressed: () async {
                    if (loginKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      await _login();

                      isLoading = false;
                      setState(() {});
                    }
                  },
                  child: isLoading
                      ? const SizedBox(
                          width: 30,
                          height: 22,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
                const SizedBox(
                  height: 8.0,
                ),

                // go to sign up page
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterPage(),
                        ));
                  },
                  child: const Text(
                    'Don\'t have an account? Sign Up',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
