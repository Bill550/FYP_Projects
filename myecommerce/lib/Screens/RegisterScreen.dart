import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class RegisterScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Hero(
              tag: 'logo',
              child: Lottie.asset(
                'assets/PlantAnimation.json',
                height: 150,
                width: 150,
              ),
            ),
            TextField(),
            TextField(),
            TextField(),
            TextField(),
          ],
        ),
      ),
    );
  }
}
