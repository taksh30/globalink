import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:globalink/models/users.dart';

class UserProvider extends ChangeNotifier {
  Users? currentUser;

  FirebaseFirestore db = FirebaseFirestore.instance;

  // get user details
  void getUsers() async {
    try {
      // current user
      String? userId = FirebaseAuth.instance.currentUser?.uid;

      // get users
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await db.collection('users').doc(userId).get();

      // populate user details
      if (snapshot.exists) {
        currentUser = Users.fromJson(snapshot.data() ?? {});

        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
