import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String userId;

  void authenticate() async {
    FirebaseUser user = await _auth.currentUser();
    if (user == null) {
      _auth.signInAnonymously();
    }
    userId = user.uid;
  }
}
