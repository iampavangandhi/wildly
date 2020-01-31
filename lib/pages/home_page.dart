import 'package:animal_welfare_project/pages/authority_edit.dart';
import 'package:animal_welfare_project/pages/profile.dart';
import 'package:animal_welfare_project/pages/discover.dart';
import 'package:animal_welfare_project/pages/home_list.dart';
import 'package:animal_welfare_project/utils/paytm.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int currentPage = 0;

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
      bottomNavigationBar: FancyBottomNavigation(
        tabs: [
          TabData(iconData: Icons.home, title: "Home"),
          TabData(iconData: Icons.search, title: "Discover"),
          TabData(iconData: Icons.person, title: "Profile"),
        ],
        onTabChangedListener: (p) {
          setState(() {
            currentPage = p;
          });
        },
      ),
      body: Container(
        child: Center(
          child: _getPage(currentPage)
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
    DataSnapshot snapshot1 = await FirebaseDatabase.instance
        .reference()
        .child('users')
        .child(user.uid)
        .child('type')
        .once();

    //if authority, go to the authorities page
    if (snapshot1.value == "authority") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => AuthorityEdit()));
    }

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

  _getPage(int currentPage) {

    switch(currentPage){
      case 0:
        return HomeList();

      case 1:
        return Discover();

      case 2:
        return Profile();
    }

  }
}
