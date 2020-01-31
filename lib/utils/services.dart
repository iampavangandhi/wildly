import 'dart:async';
import 'package:animal_welfare_project/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:paytm_payments/paytm_payments.dart';

class FirebaseService {
  FirebaseService() {
    initPayments();
  }

  void initPayments() async {
    PaytmPayments.responseStream.listen((Map<dynamic, dynamic> responseData) {
      print('function trigerred');
      print('Response code ${responseData.toString()}');

      if (responseData['STATUS'].toString() == "TXN_SUCCESS") {
        switch (responseData['TXNAMOUNT'].toString()) {
          case "9.00":
            _addPoints(50);
            break;

          case "299.00":
            _addPoints(1200);
            break;

          case "499.00":
            _addPoints(2100);
            break;
        }
      }

      /*
      {CURRENCY: INR, GATEWAYNAME: PPBLC, RESPMSG: Txn Success, PAYMENTMODE: UPI, MID: PIMOIn97892499954424,
       RESPCODE: 01, TXNAMOUNT: 1.00, TXNID: 20190910111212800110168140186967271, ORDERID: 1568120445208, STATUS: TXN_SUCCESS, BANKTXNID: 925342772828, TXNDATE: 2019-09-10 18:30:47.0,
       CHECKSUMHASH: 38+U+g+T9ouFNbiuNuGyU51JkN43l+FqvaDA5guYeKssSsHne6hY81T9bAfmwrB7aIgFzWIFHPptliBSoGzczS8II1hej1CY+AcB0PpAP1o=}
      * */
    });
  }

}

_addPoints(int boughtPoints) async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  DataSnapshot snapshot = await FirebaseDatabase.instance
      .reference()
      .child('users')
      .child(user.uid)
      .child('points')
      .once();
  int currentPoints = snapshot.value;

  currentPoints += boughtPoints;
  FirebaseDatabase.instance
      .reference()
      .child('users')
      .child(user.uid)
      .child('points')
      .set(currentPoints);

  showTopToast(
      'Payment completed successfully! \n $boughtPoints points added to your account');
}

Future<String> _getAccountKey() async {
  FirebaseUser user = await FirebaseAuth.instance.currentUser();
  return user == null ? null : user.uid;
}
