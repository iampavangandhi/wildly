import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {


  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;
    final String imgUrl = 'https://pixel.nymag.com/imgs/daily/selectall/2017/12/26/26-eric-schmidt.w700.h700.jpg';

    return new Stack(children: <Widget>[
      new Container(color: Colors.blue,),
      new Image.network(imgUrl, fit: BoxFit.fill,),
      new Container(
        decoration: BoxDecoration(
          color:  Colors.blue.withOpacity(0.9),
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),),
      new Scaffold(
          appBar: new AppBar(
            title: new Text("Profile"),
            centerTitle: false,
            elevation: 0.0,
            backgroundColor: Colors.transparent,
          ),
          drawer: new Drawer(child: new Container(),),
          backgroundColor: Colors.transparent,
          body: new Center(
            child: new Column(
              children: <Widget>[
                new SizedBox(height: _height/12,),
                new CircleAvatar(radius:_width<_height? _width/4:_height/4,backgroundImage: NetworkImage(imgUrl),),
                new SizedBox(height: _height/25.0,),
                new Text('Eric Schmidt', style: new TextStyle(fontWeight: FontWeight.bold, fontSize: _width/15, color: Colors.white),),
                new Padding(padding: new EdgeInsets.only(top: _height/30, left: _width/8, right: _width/8),
                  child:new Text('Snowboarder, Superhero and writer.\nSometime I work at google as Executive Chairman ',
                    style: new TextStyle(fontWeight: FontWeight.normal, fontSize: _width/25,color: Colors.white),textAlign: TextAlign.center,) ,),
              ],
            ),
          )
      )
    ],);
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
