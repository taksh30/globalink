import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:globalink/models/chatrooms.dart';
import 'package:globalink/models/users.dart';
import 'package:globalink/pages/chatroom_page.dart';
import 'package:globalink/pages/profile_page.dart';
import 'package:globalink/pages/splash_screen.dart';
import 'package:globalink/providers/user_provider.dart';
import 'package:provider/provider.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  User? currentUser = FirebaseAuth.instance.currentUser;

  GlobalKey<ScaffoldState> drawerKey = GlobalKey<ScaffoldState>();

  FirebaseFirestore db = FirebaseFirestore.instance;

  List<Chatrooms> chatrooms = [];
  List<String> chatroomIds = [];

  @override
  void initState() {
    _getChatrooms();
    super.initState();
  }

  // get all chatrooms
  void _getChatrooms() async {
    try {
      // get from database
      QuerySnapshot<Map<String, dynamic>> chatroomSnapshot =
          await db.collection('chatrooms').get();

      // populate to model class
      final chatroomList = chatroomSnapshot.docs
          .map((doc) => Chatrooms.fromJson(doc.data()))
          .toList();

      // get chatroom ids
      final ids = chatroomSnapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        chatrooms = chatroomList;
        chatroomIds = ids;
      });
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }

  // log out
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    Users? userProvider = Provider.of<UserProvider>(context).currentUser;

    return Scaffold(
      key: drawerKey,

      // app bar
      appBar: AppBar(
        title: const Text('GlobaLink'),
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: InkWell(
            // for open drawer
            onTap: () {
              drawerKey.currentState?.openDrawer();
            },
            child: CircleAvatar(
              backgroundColor: Colors.black,

              // user name
              child: Text(
                userProvider?.name[0] ?? '',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        actions: [
          // log out button
          IconButton(
            // on log out button pressed
            onPressed: () {
              _signOut();

              // go to splash screen
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen(),
                ),
                (route) {
                  return false;
                },
              );
            },
            icon: const Icon(
              Icons.logout_outlined,
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              // profile
              ListTile(
                // go to profile page
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );

                  drawerKey.currentState?.closeDrawer();
                },

                // user name
                title: Text(
                  userProvider?.name ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                // user email
                subtitle: Text(userProvider?.email ?? ''),
                leading: CircleAvatar(
                  child: Text(userProvider?.name[0] ?? ''),
                ),
              ),
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProfilePage(),
                    ),
                  );
                },
                title: const Text('Profile'),
                leading: const Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),

      // chatrooms
      body: ListView.builder(
        itemCount: chatrooms.length,
        itemBuilder: (context, index) {
          if (chatrooms.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final chatroom = chatrooms[index];

          return ListTile(
            // go to chatroom page
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatroomPage(
                    chatroomName: chatroom.name,
                    chatroomId: chatroomIds[index],
                  ),
                ),
              );
            },
            leading: CircleAvatar(
              child: Text(chatroom.name[0]),
            ),

            // chatroom name
            title: Text(chatroom.name),

            // chatroom description
            subtitle: Text(chatroom.description),
          );
        },
      ),
    );
  }
}
