import 'package:flutter/material.dart';
import 'package:myecommerce/Providers/LocationProvider.dart';
import 'package:myecommerce/Screens/MapScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAppBar extends StatefulWidget {
  @override
  _MyAppBarState createState() => _MyAppBarState();
}

class _MyAppBarState extends State<MyAppBar> {
  String _location = '';
  String _address = '';

  @override
  void initState() {
    getPrefs();
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    String address = prefs.getString('address');

    setState(() {
      _location = location;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationData = Provider.of<LocationProvider>(context);

    return SliverAppBar(
      // expandedHeight: 200,
      automaticallyImplyLeading: false,
      elevation: 0.0,
      floating: true,
      snap: true,
      title: TextButton(
        onPressed: () {
          locationData.getCurrentPosition().then((value) {
            if (value != null) {
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: MapScreen.id),
                screen: MapScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            } else {
              print('Permission not allowed');
            }
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Flexible(
                  child: Text(
                    _location == null ? 'Address not set' : _location,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 15,
                ),
              ],
            ),
            Flexible(
              child: Text(
                _address == null
                    ? 'Press here to set delivery location'
                    : _address,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      // actions: [
      //   IconButton(
      //     icon: Icon(Icons.power_settings_new),
      //     color: Colors.white,
      //     onPressed: () {
      //       //TODO Temporary
      //       FirebaseAuth.instance.signOut();
      //       Navigator.pushReplacementNamed(context, WelcomeScreen.id);
      //     },
      //   ),
      //   IconButton(
      //     icon: Icon(Icons.account_circle_outlined),
      //     color: Colors.white,
      //     onPressed: () {},
      //   ),
      // ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(56),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: '   Search...',
              hintStyle: TextStyle(),
              icon: Icon(Icons.search, color: Colors.white),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.zero,
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
