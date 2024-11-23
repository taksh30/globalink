import 'package:flutter/material.dart';
import 'package:globalink/models/users.dart';
import 'package:globalink/pages/edit_profile_page.dart';
import 'package:globalink/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // go to edit profile page
  Future<dynamic> _goToEditProfilePage() {
    return Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const EditProfilePage(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    Users? userProvider = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      // app bar
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // user icon
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 50,
                  child: Text(
                    userProvider?.name[0] ?? '',
                    style: const TextStyle(fontSize: 30.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),

              // user name
              Text(userProvider?.name ?? ''),

              // user email
              Text(userProvider?.email ?? ''),
              const SizedBox(
                height: 15.0,
              ),

              // edit profile button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 8.0)),

                // on edit button pressed
                onPressed: () {
                  _goToEditProfilePage();
                },
                child: const Text(
                  'Edit Profile',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
