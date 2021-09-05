import 'package:deliveryboy/Widgets/BoyPicPicker.dart';
import 'package:deliveryboy/Widgets/RegisterForm.dart';
import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const String id = 'register-screen';

  @override
  Widget build(BuildContext context) {
    // final _authData = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  BoyPicCard(),
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
