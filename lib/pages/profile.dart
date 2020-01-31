import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String displayName, email;
  String photoUrl = "";


  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return new Stack(children: <Widget>[
      new Container(color: Colors.tealAccent.withOpacity(0.6),),
      new Image.network(photoUrl, fit: BoxFit.fill,),
      new Container(
        decoration: BoxDecoration(
          color:  Colors.tealAccent.withOpacity(0.6),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),),
      new Scaffold(
          backgroundColor: Colors.transparent,
          body: new Center(
            child: new Column(
              children: <Widget>[
                new SizedBox(height: _height/12,),
                new CircleAvatar(radius:_width<_height? _width/4:_height/4,backgroundImage: NetworkImage(photoUrl),),
                new SizedBox(height: _height/25.0,),
                new Text('$displayName', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: _width/15, color: Colors.white),),
                new Padding(padding: new EdgeInsets.only(top: _height/30, left: _width/8, right: _width/8),
                  child:new Text('$email',
                    style: new TextStyle(fontWeight: FontWeight.normal, fontSize: _width/25,color: Colors.white),textAlign: TextAlign.center,) ,),
              ],
            ),
          )
      )
    ],);
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child('user_account_settings').child(user.uid).once();
    setState(() {

      print('this is shit ${snapshot.value}');
      displayName = snapshot.value['displayName'];
      photoUrl = snapshot.value['photoUrl'];
      email = snapshot.value['email'];

      if(photoUrl == null){
        photoUrl = "https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png";
      }
      if (displayName == null){

        List<String> f = email.split('@');
        displayName = f[0];
      }
    });

  }
}

const List<Color> signUpGradients = [
  /* Color(0xFFFF9945),
  Color(0xFFFc6076),*/
  /*kShrinePink500,
  kShrinePink600,
  Colors.pinkAccent,*/
  Colors.black,
  Colors.black87
];
