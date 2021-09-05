import 'package:flutter/material.dart';
import 'package:vendorapp/Screens/BannerScreen.dart';
import 'package:vendorapp/Screens/CouponScreen.dart';
import 'package:vendorapp/Screens/DashboardScreen.dart';
import 'package:vendorapp/Screens/OrdersScreen.dart';
import 'package:vendorapp/Screens/ProductScreen.dart';

class DrawerServices {
  Widget drawerScren(title) {
    if (title == 'Dashboard') {
      return MainScreen();
    }
    if (title == 'Product') {
      return ProductScreen();
    }
    if (title == 'Banner') {
      return BannerScreen();
    }
    if (title == 'Coupons') {
      return CouponScreen();
    }
    if (title == 'Orders') {
      return OrdersScreen();
    }
    if (title == 'Reports') {
      return MainScreen();
    }
    if (title == 'Setting') {
      return MainScreen();
    }
    return MainScreen();
  }
}
