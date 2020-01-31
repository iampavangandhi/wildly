import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../main.dart';
import '../main.dart';
import 'login_page.dart';

class AuthorityEdit extends StatefulWidget {
  @override
  _AuthorityEditState createState() => _AuthorityEditState();
}

class _AuthorityEditState extends State<AuthorityEdit> {

  String imgURL = "";

  bool _isLoading = false;
  bool isEverythingOk = false;

  TextEditingController causeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();


  bool _everythingIsOk() {

    if(causeController.value.text.isNotEmpty && nameController.value.text.isNotEmpty && typeController.value.text.isNotEmpty){
      return true;
    }else{
      showTopToast("Please fill in all the details!");
      return false;
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 64.0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: signUpGradients,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight),
        ),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 48.0, top: 32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Add animals here',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        letterSpacing: 3,
                        fontSize: 20.0,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),

            //name
            _textField(nameController, "Animal's name"),
            //description
            _textField(causeController, "Description"),
            _textField(typeController, "Type"),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: FloatingActionButton(
                onPressed: _addImageToDb,
                child: Icon(Icons.image),
              ),
            ),


            //sign up button
            Container(
              margin: EdgeInsets.only(left: 32.0, top: 32.0),
              child: Row(
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      try {
                        setState(() {
                          _isLoading = true;
                        });

                        if (_everythingIsOk()) {

                          //do shit here
                          _addToDb();
                        } else {
                          setState(() {
                            print('setting isLoading false');
                            _isLoading = false;
                          });
                        }
                      } catch (e) {
                        showTopToast('Oops.. an error occurred');
                        setState(() {
                          print('setting isLoading false in catch');
                          _isLoading = false;
                        });
                      }
                    },
                    child: Container(
                      padding:
                      EdgeInsets.symmetric(horizontal: 36.0, vertical: 16.0),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 15,
                                spreadRadius: 0,
                                offset: Offset(0.0, 32.0)),
                          ],
                          borderRadius: new BorderRadius.circular(36.0),
                          gradient:
                          LinearGradient(begin: FractionalOffset.centerLeft,
// Add one stop for each color. Stops should increase from 0 to 1
                              stops: [
                                0.2,
                                1
                              ], colors: [
                                Color(0xffFFC3A0),
                                Color(0xffFFAFBD),
                              ])),
                      child: _isLoading
                          ? SpinKitFadingCircle(color: Colors.white)
                          : Text(
                        'ADD',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Raleway'),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(10.0),
              child: FlatButton(
                child: Text("Sign Out"),
                onPressed: (){
                  FirebaseAuth.instance.signOut();
                  Navigator.of(context)
                      .pushReplacement(MaterialPageRoute(builder: (context) => RootPage()));
                  showTopToast("Signing Out...");
                },
              ),
            )

          ],
        ),
      ),
    );
  }


  void _addToDb() async {

    try {
      FirebaseUser user = await FirebaseAuth.instance.currentUser();

      String animal_key = FirebaseDatabase.instance
          .reference()
          .child('all_animals').push()
          .key;

      await FirebaseDatabase.instance
          .reference()
          .child('all_animals')
          .child(animal_key)
          .set({
        'type': typeController.value.text,
        'name': nameController.value.text,
        'cause': causeController.value.text,
        'has_treated': false,
        'ngo': user.uid,
        'image': imgURL,
      });

      await FirebaseDatabase.instance
          .reference()
          .child('ngo_animals')
          .child(user.uid)
          .child(animal_key)
          .set({
        'type': typeController.value.text,
        'name': nameController.value.text,
        'cause': causeController.value.text,
        'has_treated': false,
        'image': imgURL,
      });

      showTopToast("Data Inserted Successfully!");
      setState(() {
        _isLoading = false;
      });
    } catch (e){
      showTopToast("Some error occurred $e");
    }

  }

  void _addImageToDb() async {
    File galleryImage = await FilePicker.getFile(type: FileType.ANY);

    if (galleryImage != null) {
      int timestamp = DateTime.now().millisecondsSinceEpoch;

      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child('animal_photos')
          .child('$timestamp');

      StorageUploadTask uploadTask = ref.putFile(galleryImage);
      String imageURL =
      await (await uploadTask.onComplete).ref.getDownloadURL();

      //content is image url
      if (imageURL != null) {

          imgURL = imageURL;
          showTopToast("Image uploaded successfully!");

      }
    }
  }

  _textField(TextEditingController controller, String s) {
    return Container(
      margin: EdgeInsets.only(left: 16.0, right: 32.0, top: 32.0),
      decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                spreadRadius: 0,
                offset: Offset(0.0, 16.0)),
          ],
          borderRadius: new BorderRadius.circular(12.0),
          gradient: LinearGradient(
              begin: FractionalOffset(0.0, 0.4),
              end: FractionalOffset(0.9, 0.7),
              // Add one stop for each color. Stops should increase from 0 to 1
              stops: [
                0.2,
                0.9
              ],
              colors: [
                Color(0xffFFC3A0),
                Color(0xffFFAFBD),
              ])),
      child: TextField(
        style: hintAndValueStyle,
        controller: controller,
        decoration: new InputDecoration(
            contentPadding:
            new EdgeInsets.fromLTRB(40.0, 30.0, 10.0, 10.0),
            border: OutlineInputBorder(
                borderRadius: new BorderRadius.circular(12.0),
                borderSide: BorderSide.none),
            hintText: s,
            hintStyle: hintAndValueStyle),
      ),
    );
  }
}

