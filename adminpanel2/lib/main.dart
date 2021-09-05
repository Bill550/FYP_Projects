import 'package:adminpanel2/Screens/BlogScreen.dart';
import 'package:adminpanel2/Screens/BannersScreen.dart';
import 'package:adminpanel2/Screens/DeliveryBoyScreen.dart';
import 'package:adminpanel2/Screens/HomeScreen.dart';
import 'package:adminpanel2/Screens/LoginScreen.dart';
import 'package:adminpanel2/Screens/CategoriesScreen.dart';
import 'package:adminpanel2/Screens/NotificationScreen.dart';
import 'package:adminpanel2/Screens/OrdersScreens.dart';
import 'package:adminpanel2/Screens/SettingScreen.dart';
import 'package:adminpanel2/Screens/SplashScreen.dart';
import 'package:adminpanel2/Screens/VendorScreen.dart';
import 'package:adminpanel2/Widgets/Blog/EditBlogScreen.dart';
import 'package:adminpanel2/constants.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin Dash-board',
      theme: ThemeData(
        primaryColor: greenColor,
      ),
      home: SplashScreen(),
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        CategoriesScreen.id: (context) => CategoriesScreen(),
        OrdersScreen.id: (context) => OrdersScreen(),
        BannersScreen.id: (context) => BannersScreen(),
        BlogScreen.id: (context) => BlogScreen(),
        EditBlogScreen.id: (context) => EditBlogScreen(),
        NotificationScreen.id: (context) => NotificationScreen(),
        SettingsScreen.id: (context) => SettingsScreen(),
        VendorsScreen.id: (context) => VendorsScreen(),
        DeliveryBoyScreen.id: (context) => DeliveryBoyScreen(),
      },
    );
  }
}
