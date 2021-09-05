import 'package:flutter/material.dart';
import 'package:vendorapp/Constants.dart';
// import 'package:vendorapp/Screens/LoginScreen.dart';
import 'package:vendorapp/Widgets/RegisterForm.dart';
import 'package:vendorapp/Widgets/ShopPicPicker.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Text(
                    'REGISTER',
                    style: TextStyle(
                      fontFamily: 'Anton',
                      fontSize: 30,
                      color: greenColor,
                      letterSpacing: 1,
                    ),
                  ),
                  ShopPicCard(),
                  RegisterForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
