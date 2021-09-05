import 'package:flutter/material.dart';

class TempScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _TempScreenState createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Screen'),
      ),
    );
  }
}
