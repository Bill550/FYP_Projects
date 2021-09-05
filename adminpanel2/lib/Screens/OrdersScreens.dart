import 'package:adminpanel2/Services/SideBarWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class OrdersScreen extends StatelessWidget {
  static const String id = 'order-screen';
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBarWidget = SideBarWidget();

    return AdminScaffold(
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sideBarWidget.sideBarMenus(context, OrdersScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Text(
            'Order Screen',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 36,
            ),
          ),
        ),
      ),
    );
  }
}
