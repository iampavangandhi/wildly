import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'animal_single_item_page.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String displayName = "", email = "";
  String photoUrl = "";
  List myAnimalsList = List();

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return new Stack(children: <Widget>[
      new Container(color: Colors.blueGrey.withOpacity(0.6),),
      new Container(
        decoration: BoxDecoration(
          color:  Colors.blueGrey.withOpacity(0.6),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),),
      new Scaffold(
          backgroundColor: Colors.transparent,
          body: new Center(
            child: new Column(
              children: <Widget>[
                new SizedBox(height: _height/12,),
                new CircleAvatar(radius:_width<_height? _width/8:_height/8,backgroundImage: NetworkImage(photoUrl),),
                new SizedBox(height: 25.0,),
                new Text('$displayName', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: _width/15, color: Colors.white),),
                new Padding(padding: new EdgeInsets.only(top: 0.0, left: _width/8, right: _width/8),
                  child:new Text('$email',
                    style: new TextStyle(fontWeight: FontWeight.normal, fontSize: _width/25,color: Colors.white),textAlign: TextAlign.center,) ,),
                Container(padding: EdgeInsets.all(10.0),child: new Text('My Contributions', style: new TextStyle(fontWeight: FontWeight.bold, fontFamily: 'DancingScript', color: Colors.white, fontSize: 28.0),)),
                _horizontalList(myAnimalsList),
              ],
            ),
          )
      )
    ]);
  }

  _horizontalList(List storyList) => Container(
    padding: EdgeInsets.all(12.0),
    height: 280.0,
    child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: storyList.length,
        itemBuilder: (context, index) => _listItem(storyList[index])),
  );

  _listItem(story) {
    return InkWell(
      onTap: ()  {
        Navigator.of(context).push(MaterialPageRoute(builder: (context) => AnimalSingleItemPage()));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              child: Stack(
                children: <Widget>[
                  Container(
                      height: 250.0,
                      width: 200.0,
                      child: Image.network(
                        story['image'],
                        fit: BoxFit.cover,
                      )),
                  Positioned(
                    left: 0.0,
                    bottom: 0.0,
                    width: 200.0,
                    height: 60.0,
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Colors.black.withOpacity(0.01),
                              ])),
                    ),
                  ),
                  Positioned(
                    top: 0.0,
                    right: 8.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.9),
                      child: Chip(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(10.0)),
                          backgroundColor: Colors.white,
                          labelPadding: EdgeInsets.symmetric(
                              horizontal: 4.0, vertical: 0.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 0.0, horizontal: 3.0),
                          label: Text(
                            story['type'],
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                fontSize: 11.0),
                          )),
                    ),
                  ),
                  Positioned(
                    left: 10.0,
                    bottom: 10.0,
                    right: 10.0,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            Container(
                              width: 160.0,
                              child: Text(
                                '${story['name']}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18.0),
                              ),
                            ),
                            Container(
                              width: 160.0,
                              child: Text(
                                '${descriptionStringShort(story['cause'])}',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 13.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  descriptionStringShort(String description) => description.length > 22
      ? description.substring(0, 22) + '...'
      : description;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  loadData() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    DataSnapshot snapshot = await FirebaseDatabase.instance.reference().child('user_account_settings').child(user.uid).once();
    DataSnapshot snapshot1 =
    await FirebaseDatabase.instance.reference().child('user_animals').child(user.uid).once();

    setState(() {
      myAnimalsList = (snapshot1.value as Map<dynamic, dynamic>).values.toList();
      displayName = snapshot.value['displayName'];
      photoUrl = snapshot.value['photoUrl'];
      email = snapshot.value['email'];

      if(photoUrl == null){
        photoUrl = "https://www.searchpng.com/wp-content/uploads/2019/02/Deafult-Profile-Pitcher.png";
      }
      if (displayName == ""){
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
