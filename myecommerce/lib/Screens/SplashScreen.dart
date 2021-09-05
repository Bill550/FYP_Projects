import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:myecommerce/Constants.dart';
import 'package:myecommerce/Screens/LandingScreen.dart';
import 'package:myecommerce/Screens/MainScreen.dart';
import 'package:myecommerce/Screens/WelcomeScreen.dart';
import 'package:myecommerce/Services/UserServices.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, WelcomeScreen.id);
        } else {
          // if user has data in firestore check delivery address set or not
          getUserData();
        }
      });
    });
  }

  getUserData() async {
    UserServices _userServices = UserServices();

    _userServices.getUserByID(user.uid).then((result) {
      //check location details has or not
      if (result['address'] != null) {
        // if address details exists
        updatePrefs(result);
      }
      //if address details doesn't exist
      Navigator.pushReplacementNamed(context, LandingScreen.id);
    });
  }

  Future<void> updatePrefs(result) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('latitude', result['latitude']);
    prefs.setDouble('longitude', result['longitude']);
    prefs.setString('address', result['address']);
    prefs.setString('location', result['location']);
    //After updating prefs, Navigate to HomeScreen
    Navigator.pushReplacementNamed(context, MainScreen.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Lottie.asset(
                'assets/PlantAnimation3.json',
                height: 300,
                width: 300,
                frameRate: FrameRate(75),
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Plant-E',
              style: TextStyle(
                fontSize: 32,
                color: blackColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
