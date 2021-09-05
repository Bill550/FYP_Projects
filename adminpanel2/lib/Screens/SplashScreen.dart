import 'dart:async';

import 'package:adminpanel2/Screens/HomeScreen.dart';
import 'package:adminpanel2/Screens/LoginScreen.dart';
import 'package:adminpanel2/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // StreamSubscription<User> _listener;

  @override
  void initState() {
    Timer(Duration(seconds: 4), () {
      // _listener = FirebaseAuth.instance.authStateChanges().listen((User user) {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        print('Hello User: ' + user.toString());
        try {
          if (user == null) {
            print('User is currently signed out!');
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => LoginScreen()));
          } else if (user != null) {
            print('User is signed in!: ' + user.toString());
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => HomeScreen()));
          }
        } on FirebaseAuthException catch (e) {
          print('User is currently signed out!  ' + ' $e ');
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => LoginScreen()));
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          // crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/PlantAnimation.json',
              height: 500,
              width: 500,
            ),
            // SizedBox(height: 10),
            Container(
              alignment: Alignment.bottomCenter,
              child: Text(
                'Plant-E',
                style: TextStyle(
                  fontSize: 32,
                  color: greenColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
