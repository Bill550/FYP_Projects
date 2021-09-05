import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myecommerce/Providers/LocationProvider.dart';
import 'package:myecommerce/Screens/LandingScreen.dart';
import 'package:myecommerce/Screens/MainScreen.dart';
import 'package:myecommerce/Services/UserServices.dart';

class AuthProvider with ChangeNotifier {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String smsOTP;
  String verificationID;
  String error = '';
  UserServices _userServices = UserServices();
  bool loading = false;
  LocationProvider locationData = LocationProvider();
  String screen;
  double latitude;
  double longitude;
  String address;
  String location;

  DocumentSnapshot snapshot;

  Future<void> verifyMobile({
    BuildContext context,
    String number,
  }) async {
    this.loading = true;
    notifyListeners();
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      this.loading = false;
      notifyListeners();
      await _auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        this.loading = false;
        print('The provided phone number is not valid.' + '${e.toString()}');
        this.error = e.toString();
        notifyListeners();
      }
    };

    final PhoneCodeSent codeSent =
        (String verificationId, int resendToken) async {
      this.verificationID = verificationId;

      //Open Dialog box to enter received OTP SMS
      smsOTPDialog(context, number);
    };

    try {
      _auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: (String verID) {
          this.verificationID = verID;
        },
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.toString();
      this.loading = false;
      notifyListeners();

      print(e.toString());
    }
  }

  ///
  ///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///
  Future<bool> smsOTPDialog(BuildContext context, String number) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            children: [
              Text('Verification Code'),
              SizedBox(height: 6),
              Text(
                'Enter 6 digit OTP received as SMS',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          content: Container(
            height: 85,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              maxLength: 6,
              onChanged: (value) {
                this.smsOTP = value;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  PhoneAuthCredential credential = PhoneAuthProvider.credential(
                      verificationId: verificationID, smsCode: smsOTP);

                  final User user =
                      (await _auth.signInWithCredential(credential)).user;

                  if (user != null) {
                    this.loading = false;
                    notifyListeners();

                    _userServices.getUserByID(user.uid).then((snapShot) {
                      if (snapShot.exists) {
                        //user data already exists
                        if (this.screen == 'Login') {
                          //Need to check user data already exit in DB or not.
                          //if it's Login, no new data so, no need to update.
                          if (snapShot['address'] != null) {
                            Navigator.pushReplacementNamed(
                                context, MainScreen.id);
                          }
                          Navigator.pushReplacementNamed(
                              context, LandingScreen.id);
                        } else {
                          print('When old user login Longitude & Latitude : ' +
                              '${locationData.longitude} & ${locationData.latitude}');

                          //need to update new selected address
                          updateUser(
                            id: user.uid,
                            number: user.phoneNumber,
                          );
                          Navigator.pushReplacementNamed(
                              context, MainScreen.id);
                        }
                      } else {
                        //user data does not exists
                        //Will create new data in DB.
                        _createUser(
                          id: user.uid,
                          number: user.phoneNumber,
                        );
                        Navigator.pushReplacementNamed(
                            context, LandingScreen.id);
                      }
                    });
                  } else {
                    print('Login Failed');
                  }

                  // if (locationData.selectedAddress != null) {
                  //   /// to Update user data in firestore successfully.
                  //   ///
                  //   updateUser(
                  //     id: user.uid,
                  //     number: user.phoneNumber,
                  //     latitude: locationData.latitude,
                  //     longitude: locationData.longitude,
                  //     address: locationData.selectedAddress.addressLine,
                  //   );
                  // } else {
                  //   /// Create user data in firestore after user successfully registered.
                  //   ///
                  //   _createUser(
                  //     id: user.uid,
                  //     number: user.phoneNumber,
                  //     latitude: latitude,
                  //     longitude: longitude,
                  //     address: address,
                  //   );
                  // }

                  // ///
                  // /// Navigate to HOME PAGE After LOGIN

                  // if (user != null) {
                  //   Navigator.of(context).pop();

                  //   Navigator.pushReplacementNamed(context, HomeScreen.id);
                  // } else {
                  //   print('Login Failed');
                  // }

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                  ///
                  ///
                } on FirebaseAuthException catch (e) {
                  this.error = 'Invalid OTP';
                  notifyListeners();

                  print(e.toString());

                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'DONE',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        );
      },
    ).whenComplete(() {
      this.loading = false;
      notifyListeners();
    });
  }

  ///
  ///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///

  void _createUser({
    String id,
    String number,
  }) {
    _userServices.createUserData({
      'id': id,
      'number': number,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'address': this.address,
      'location': this.location,
      'email': '',
      'lastName': '',
      'firstName': '',

      // 'location': GeoPoint(latitude, longitude),
      // 'latitude': locationData.latitude,
      // 'longitude': locationData.longitude,
      // 'address': locationData.selectedAddress == null
      //     ? locationData.selectedAddress
      //     : locationData.selectedAddress.addressLine,
    });
    this.loading = false;
    notifyListeners();
  }

  ///
  ///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///

  void updateUser({
    String id,
    String number,
  }) async {
    try {
      _userServices.updateUserData({
        'id': id,
        'number': number,
        'latitude': this.latitude,
        'longitude': this.longitude,
        'address': this.address,
        'location': this.location,

        // 'location': GeoPoint(latitude, longitude),

        // 'address': this.selectedAddress == null
        //     ? this.selectedAddress
        //     : locationData.selectedAddress,
      });
      this.loading = false;
      notifyListeners();
      //TODO: Comment
      // return true;
    } on FirebaseFirestore catch (e) {
      print('Error: $e');
      //TODO: Comment
      // return false;
    }
  }

  ///
  ///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///

  getUserDetails() async {
    DocumentSnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser.uid)
        .get();

    if (result != null) {
      this.snapshot = result;
      notifyListeners();
    } else {
      this.snapshot = null;
      notifyListeners();
    }

    return result;
  }

  ///
  ///
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ///
  ///

}
