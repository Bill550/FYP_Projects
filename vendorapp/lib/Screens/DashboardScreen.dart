import 'package:flutter/material.dart';

class MainScreen extends StatefulWidget {
  static const String id = 'dashboard-screen';

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Dashboard'),
      ),
    );
  }
}
