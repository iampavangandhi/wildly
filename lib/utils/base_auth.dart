import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_database/firebase_database.dart';

abstract class BaseAuth {
  Future<String> signIn(String email, String password);

  Future<String> signUp(String email, String password, String type);

  Future<String> getCurrentUser();

  Future<String> signInUsingGoogle();

  Future<void> sendEmailVerification();

  Future<bool> isEmailVerified();

  void signOut();
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final DatabaseReference _ref =
      FirebaseDatabase.instance.reference().child("user_account_settings");
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<String> signIn(String email, String password) async {
    FirebaseUser user = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);

    return user.uid;
  }

  Future<String> signUp(String email, String password, String type) async {
    FirebaseUser user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    addToDatabase(user, type);
    return user.uid;
  }

  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    print('${user.uid}');
    return user.isEmailVerified;
  }

  Future<String> signInUsingGoogle() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication authentication =
        await googleSignInAccount.authentication;

    AuthCredential c = GoogleAuthProvider.getCredential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken);
    FirebaseUser user = await _firebaseAuth.signInWithCredential(c);

    addToDatabase(user, "user");

    return user.uid;
  }

  Future<String> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  void signOut() {
    _firebaseAuth.signOut();
    _googleSignIn.signOut();
  }

  addToDatabase(FirebaseUser user, String type) {

    if(type == "authority"){
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(user.uid)
          .child('type')
          .set("authority");
    }

    _ref.child(user.uid).set({
      'photoUrl': user.photoUrl,
      'phoneNumber': user.phoneNumber,
      'displayName': user.displayName,
      'email': user.email,
      'type' : type
    });
  }
}
