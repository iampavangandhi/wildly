import 'package:animal_welfare_project/main.dart';
import 'package:animal_welfare_project/utils/paytm.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("YEAH"),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.payment), onPressed: () =>  Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => Paytm())))
        ],
      ),
      body: Container(
        child: Center(
          child: FlatButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context)
                  .pushReplacement(MaterialPageRoute(builder: (context) => RootPage()));
              showTopToast("Signing out...");
            },
            child: Text("Sign Out"),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _isFirstTimeLogin();
    super.initState();
  }

  _isFirstTimeLogin() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user.uid)
        .child('points')
        .once();

    if (snapshot.value == null) {
      //first time user || set details here
      FirebaseDatabase.instance
          .reference()
          .child('users')
          .child(user.uid)
          .child('points')
          .set(200);
    }
  }
}
