import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:globalink/models/users.dart';
import 'package:globalink/pages/splash_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> signUpKey = GlobalKey<FormState>();

  final _emailCtr = TextEditingController();
  final _passwordCtr = TextEditingController();
  final _nameCtr = TextEditingController();
  final _countryCtr = TextEditingController();

  // sign up
  Future<void> _signUp() async {
    try {
      final email = _emailCtr.text;
      final password = _passwordCtr.text;
      final name = _nameCtr.text;
      final country = _countryCtr.text;

      // create the user
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      String? userId = FirebaseAuth.instance.currentUser?.uid;

      FirebaseFirestore db = FirebaseFirestore.instance;

      Users user = Users(
        country: country,
        email: email,
        id: userId ?? '',
        name: name,
      );

      try {
        await db.collection('users').doc(userId).set(user.toJson());
      } catch (e) {
        if (kDebugMode) {
          print(e);
        }
      }

      // show snackbar on success
      SnackBar snackBar =
          const SnackBar(content: Text('Sign Up Successfully!'));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      // navigate to splash screen
      if (mounted) {
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => const SplashScreen()),
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
      resizeToAvoidBottomInset: true,

      // app bar
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: signUpKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // name
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _nameCtr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required!';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(maxWidth: 350),
                      hintText: 'Name',
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

                  // country
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _countryCtr,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Country is required!';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      constraints: const BoxConstraints(maxWidth: 350),
                      hintText: 'Country',
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

                  // sign up button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40.0, vertical: 12.0)),

                    // on sign up
                    onPressed: () {
                      if (signUpKey.currentState!.validate()) {
                        _signUp();
                      }
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
