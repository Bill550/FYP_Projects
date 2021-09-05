import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myecommerce/Constants.dart';
import 'package:myecommerce/Providers/AuthProvider.dart';
import 'package:myecommerce/Providers/LocationProvider.dart';
import 'package:myecommerce/Screens/MapScreen.dart';
import 'package:myecommerce/Screens/MyOrderScreen.dart';
import 'package:myecommerce/Screens/Payments/CreditCardList.dart';
import 'package:myecommerce/Screens/ProfileUpdateScreen.dart';
import 'package:myecommerce/Screens/WelcomeScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  static const String id = 'profile-screen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var userDetails = Provider.of<AuthProvider>(context);
    var locationData = Provider.of<LocationProvider>(context);

    User user = FirebaseAuth.instance.currentUser;

    userDetails.getUserDetails();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Plant-E',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Container(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'My Account',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: darkGreyColor),
                ),
              ),
            ),
            Stack(
              children: [
                Container(
                  // color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            userDetails.snapshot['firstName'].length != 0
                                ? CircleAvatar(
                                    radius: 40,
                                    backgroundColor: darkGreyColor,
                                    child: Text(
                                      userDetails.snapshot['firstName'][0],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                      ),
                                    ),
                                  )
                                : CircleAvatar(
                                    radius: 40,
                                    backgroundColor: darkGreyColor,
                                    child: Text(
                                      '',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 50,
                                      ),
                                    ),
                                  ),
                            SizedBox(width: 10),
                            Container(
                              height: 70,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    userDetails.snapshot['firstName'] != null
                                        ? '${userDetails.snapshot['firstName']} ${userDetails.snapshot['lastName']}'
                                        : 'Update your name',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: darkGreyColor,
                                    ),
                                  ),
                                  if (userDetails.snapshot['email'] != null)
                                    Text(
                                      '${userDetails.snapshot['email']}',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: darkGreyColor,
                                      ),
                                    ),
                                  Text(
                                    user.phoneNumber,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: darkGreyColor,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        if (userDetails.snapshot != null)
                          Container(
                            decoration: BoxDecoration(
                              color: darkGreyColor,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: ListTile(
                              tileColor: darkGreyColor,
                              leading: Icon(
                                Icons.location_on,
                                color: greyColor,
                              ),
                              title: Text(
                                userDetails.snapshot['location'],
                                style: TextStyle(color: greyColor),
                              ),
                              subtitle: Text(
                                userDetails.snapshot['address'],
                                style: TextStyle(color: greyColor),
                                maxLines: 1,
                              ),
                              trailing: SizedBox(
                                width: 80,
                                child: OutlinedButton(
                                  onPressed: () {
                                    EasyLoading.show(status: 'Please wait...');
                                    locationData
                                        .getCurrentPosition()
                                        .then((value) {
                                      if (value != null) {
                                        EasyLoading.dismiss();

                                        pushNewScreenWithRouteSettings(
                                          context,
                                          settings:
                                              RouteSettings(name: MapScreen.id),
                                          screen: MapScreen(),
                                          withNavBar: false,
                                          pageTransitionAnimation:
                                              PageTransitionAnimation.cupertino,
                                        );
                                      } else {
                                        EasyLoading.dismiss();

                                        print('Permission not allowed');
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Change',
                                    style: TextStyle(color: darkGreyColor),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    primary: Colors.white,
                                    backgroundColor: greyColor,
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 10.0,
                  child: IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: darkGreyColor,
                    ),
                    onPressed: () {
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: ProfileUpdateScreen.id),
                        screen: ProfileUpdateScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                  ),
                )
              ],
            ),
            ListTile(
              onTap: () {
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: MyOrderScreen.id),
                  screen: MyOrderScreen(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              leading: Icon(
                Icons.history,
                color: darkGreyColor,
              ),
              title: Text('My Orders'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            ListTile(
              onTap: () {
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: CreditCardList.id),
                  screen: CreditCardList(),
                  withNavBar: true,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
              leading: Icon(
                Icons.credit_card_outlined,
                color: darkGreyColor,
              ),
              title: Text('Manage credit cards'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.comment_outlined,
                color: darkGreyColor,
              ),
              title: Text('My Ratings & Reviews'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.notifications_outlined,
                color: darkGreyColor,
              ),
              title: Text('Notification'),
              horizontalTitleGap: 2,
            ),
            Divider(),
            ListTile(
              leading: Icon(
                Icons.power_settings_new,
                color: darkGreyColor,
              ),
              title: Text('Logout'),
              horizontalTitleGap: 2,
              onTap: () {
                FirebaseAuth.instance.signOut();
                pushNewScreenWithRouteSettings(
                  context,
                  settings: RouteSettings(name: WelcomeScreen.id),
                  screen: WelcomeScreen(),
                  withNavBar: false,
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
