import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthHelper {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static bool checkAuth() {
    if (auth.currentUser != null) {
      return true;
    }
    else {
      return false;
    }
  }

  static Future<bool> signIn(String email, String pass) async {
    try {
      await auth.signInWithEmailAndPassword(
        email: email, password: pass
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "User not found");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong Password");
      } else {
        Fluttertoast.showToast(msg: e.code.toString());
      }
      return false;
    }
  }

  static Future<bool> signUp(String email, String pass) async {
    try {
      await auth.createUserWithEmailAndPassword(
        email: email, password: pass
      );
      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: "Password too weak");
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(msg: "Email already in use");
      } else {
        Fluttertoast.showToast(msg: e.code.toString());
      }
      return false;
    }
  }

  static Future<String> getToken() async {
    try {
      if (checkAuth()) {
        var token = await auth.currentUser!.getIdToken();
        return token;
      } else {
        return '';
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Not logged in");
      return '';
    }
  }

  static Future<bool> signOut() async {
    try {
      auth.signOut();
      return true;
    } catch (e) {
      Fluttertoast.showToast(msg: "Not logged in");
      return false;
    }
  }
}