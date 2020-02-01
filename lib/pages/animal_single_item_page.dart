import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:paytm_payments/paytm_payments.dart';
import '../main.dart';

class AnimalSingleItemPage extends StatefulWidget {

  final String imgUrl, title, description;
  final bool isAnimal;

  AnimalSingleItemPage(this.imgUrl, this.title, this.description, this.isAnimal);

  @override
  _AnimalSingleItemPageState createState() => _AnimalSingleItemPageState();
}

class _AnimalSingleItemPageState extends State<AnimalSingleItemPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 2.7,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width,
                  child: Image.network(
                    widget.imgUrl,
                    fit: BoxFit.cover,
                  ),

                ),


                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      letterSpacing: 3,
                      fontSize: 25.0,
                      color: Colors.black,
                      fontFamily: 'Oxygen',
                    ),
                  ),
                ),

                Container(
                  margin: const EdgeInsets.all(15.0),
                  child: Text(
                    widget.description,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      letterSpacing: 1,
                      fontSize: 18.0,
                      fontFamily: 'Raleway',
                      color: Colors.black45,
                    ),
                  ),
                ),


                //donate button
                widget.isAnimal ? Container(
                  margin: EdgeInsets.only(left: 142.0, top: 32.0),
                  child: Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          showDialog(context: context
                          ,child: Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    elevation: 0.0,
                                    backgroundColor: Colors.transparent,
                                    child: Container(
                                      padding: EdgeInsets.all(12.0),
                                      decoration: new BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(20.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            blurRadius: 10.0,
                                            offset: const Offset(0.0, 10.0),
                                          ),
                                        ],
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: <Widget>[

                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Text(
                                              'Buy subscription via Paytm to support this animal! \nPlease choose from one of the packages below: ',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.0),
                                            ),
                                          ),

                                          _widgets(1500, "Bronze"),
                                          _widgets(2500, "Silver"),
                                          _widgets(4000, "Gold"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
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
                          child: Text(
                            'Donate',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Raleway'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ) : Container(),

              ],
            ),

          ),
        )
    );
  }

  Widget _widgets(int price, String package) => Container(
    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
    child: Center(
      child: InkWell(
        onTap: () {
          showTopToast("Please wait while we redirect you to Paytm...");
          _addToDbTheDog();
          startPayment(price);
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12,
                    blurRadius: 15,
                    spreadRadius: 0,
                    offset: Offset(0.0, 32.0)),
              ],
              borderRadius: new BorderRadius.circular(36.0),
              border: Border.all(color: Colors.black87, width: 1.0)),
          child: Column(
            children: <Widget>[
              Text(
                '$price Rs',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
              Text(
                '$package',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Raleway'),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  startPayment(int price) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    try {
      await PaytmPayments.makePaytmPayment(
        "PIMOIn97892499954424", // [YOUR_MERCHANT_ID] (required field)
        "http://www.novelle.dx.am/generateChecksum.php",
        customerId: user.uid,
        orderId: DateTime.now().millisecondsSinceEpoch.toString(),
        txnAmount: "$price",
        channelId: "WAP",
        industryTypeId: "Retail",
        website: "DEFAULT",
        staging: false,
        showToast: true,
      );
    } catch (e) {
      print("Some error occurred $e");
      showTopToast('Some error occurred \n Please try again later');
    }
  }

  _addToDbTheDog() async {

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    String key = FirebaseDatabase.instance.reference().child('user_animals').child(user.uid).push().key;

    await FirebaseDatabase.instance.reference().child('user_animals').child(user.uid).child(key).set({
      'cause' : widget.description,
      'name' : widget.title,
      'image' : widget.imgUrl,

    });



  }
}