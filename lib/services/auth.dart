import 'package:firebase_auth/firebase_auth.dart';

import '../models/custom_user.dart';

class AuthService {

  //_ makes var private
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //create user object
  CustomUser ? _userFromFirebaseUser(User? user) {
    return user != null ? CustomUser(uid: user.uid) : null;
  }

  //auth sign in stream
  Stream<CustomUser?> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  //SIgn in email & password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //register
  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}