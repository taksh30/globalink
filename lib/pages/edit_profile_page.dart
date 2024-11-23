import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:globalink/models/users.dart';
import 'package:globalink/providers/user_provider.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameCtr = TextEditingController();

  GlobalKey<FormState> editFormKey = GlobalKey<FormState>();

  FirebaseFirestore db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();

    // populate user name on edit name text
    Users? userProvider =
        Provider.of<UserProvider>(context, listen: false).currentUser;
    _nameCtr.text = userProvider?.name ?? '';
  }

  // update user name
  Future<void> updateUserData() async {
    try {
      Users? currentUser =
          Provider.of<UserProvider>(context, listen: false).currentUser;

      if (currentUser == null) {
        throw Exception('Current user is null');
      }

      Users updatedUser = currentUser.copyWith(name: _nameCtr.text);

      // update database
      await db
          .collection('users')
          .doc(currentUser.id)
          .update(updatedUser.toJson());

      // snackbar
      SnackBar snackBar =
          const SnackBar(content: Text('User name updated successfully!'));
      if (mounted) {
        // populate the updated data
        Provider.of<UserProvider>(context, listen: false).getUsers();

        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        Navigator.pop(context);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // app bar
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
        actions: [
          // update user data button
          IconButton(
            // on update button pressed
            onPressed: () {
              if (editFormKey.currentState!.validate()) {
                updateUserData();
              }
            },
            icon: const Icon(
              Icons.check,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: editFormKey,

                  // name
                  child: TextFormField(
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
