import 'dart:async';
import 'package:deliveryboy/Screens/HomeScreen.dart';
import 'package:deliveryboy/Screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  static const String id = 'splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(Duration(seconds: 4), () {
      FirebaseAuth.instance.authStateChanges().listen((User user) {
        if (user == null) {
          Navigator.pushReplacementNamed(context, LoginScreen.id);
        } else {
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });
    });

    super.initState();
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
                'assets/PlantAnimation2.json',
                height: 300,
                width: 300,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Plant-E',
              style: TextStyle(
                fontSize: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
