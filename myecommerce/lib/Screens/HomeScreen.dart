import 'package:flutter/material.dart';
import 'package:myecommerce/Widgets/ImageSlider.dart';
import 'package:myecommerce/Widgets/MyAppBar.dart';
import 'package:myecommerce/Widgets/NearByStore.dart';
import 'package:myecommerce/Widgets/TopPickStore.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home-screen';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            MyAppBar(),
          ];
        },
        body: ListView(
          children: [
            ImageSlider(),
            Container(
              color: Colors.white,
              child: TopPickStore(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: NearByStore(),
            ),
          ],
        ),
      ),
    );
  }
}
