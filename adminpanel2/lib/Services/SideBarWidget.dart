import 'package:adminpanel2/Screens/BlogScreen.dart';
import 'package:adminpanel2/Screens/BannersScreen.dart';
import 'package:adminpanel2/Screens/CategoriesScreen.dart';
import 'package:adminpanel2/Screens/DeliveryBoyScreen.dart';
import 'package:adminpanel2/Screens/HomeScreen.dart';
import 'package:adminpanel2/Screens/LoginScreen.dart';
// import 'package:adminpanel2/Screens/NotificationScreen.dart';
// import 'package:adminpanel2/Screens/OrdersScreens.dart';
// import 'package:adminpanel2/Screens/SettingScreen.dart';
import 'package:adminpanel2/Screens/VendorScreen.dart';
import 'package:adminpanel2/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class SideBarWidget {
  sideBarMenus(context, selctedRoute) {
    return SideBar(
      activeBackgroundColor: darkGreyColor,
      activeIconColor: Colors.white,
      activeTextStyle: TextStyle(
        color: Colors.white,
      ),
      items: const [
        MenuItem(
          title: 'Dashboard',
          route: HomeScreen.id,
          icon: Icons.dashboard,
        ),
        MenuItem(
          title: 'Blog',
          route: BlogScreen.id,
          icon: Icons.article_outlined,
        ),
        MenuItem(
          title: 'Banners',
          route: BannersScreen.id,
          icon: CupertinoIcons.photo,
        ),
        MenuItem(
          title: 'Vendor',
          route: VendorsScreen.id,
          icon: Icons.group,
        ),
        MenuItem(
          title: 'Delivery Boy',
          route: DeliveryBoyScreen.id,
          icon: Icons.delivery_dining,
        ),
        MenuItem(
          title: 'Categories',
          route: CategoriesScreen.id,
          icon: Icons.category,
        ),
        // MenuItem(
        //   title: 'Orders',
        //   route: OrdersScreen.id,
        //   icon: CupertinoIcons.cart_fill,
        // ),
        // MenuItem(
        //   title: 'Send Notification',
        //   route: NotificationScreen.id,
        //   icon: Icons.notifications,
        // ),
        // MenuItem(
        //   title: 'Settings',
        //   route: SettingsScreen.id,
        //   icon: Icons.settings,
        // ),
        MenuItem(
          title: 'Exit',
          route: LoginScreen.id,
          icon: Icons.exit_to_app,
        ),
      ],
      selectedRoute: selctedRoute,
      onSelected: (item) {
        if (item.route != null) {
          Navigator.of(context).pushNamed(item.route);
        }
      },
      header: Container(
        height: 50,
        width: double.infinity,
        color: blackColor,
        // color: Color(0xff444444),
        child: Center(
          child: Text(
            'MENU',
            style: TextStyle(
                letterSpacing: 2,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
      footer: Container(
        height: 50,
        width: double.infinity,
        color: blackColor,
        // color: Color(0xff444444),
        child: Center(
            // child: Lottie.asset(
            //   'assets/PlantAnimation.json',
            //   height: 100,
            //   width: 100,
            // ),
            ),
      ),
    );
  }
}
