import 'package:adminpanel2/Services/SideBarWidget.dart';
import 'package:adminpanel2/Widgets/Vendors/VendorDataTableWidget.dart';
import 'package:adminpanel2/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class VendorsScreen extends StatefulWidget {
  static const String id = 'vendors-screen';

  @override
  _VendorsScreenState createState() => _VendorsScreenState();
}

class _VendorsScreenState extends State<VendorsScreen> {
  SideBarWidget _sideBarWidget = SideBarWidget();

  @override
  Widget build(BuildContext context) {
    return AdminScaffold(
      appBar: AppBar(
        // backgroundColor: Colors.black87,
        backgroundColor: darkGreyColor,

        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sideBarWidget.sideBarMenus(context, VendorsScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manage Vendor\'s',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              SizedBox(height: 10),
              Text('Manage all the Vendor\'s activities'),
              Divider(thickness: 5),
              VendorDatTable(),
              Divider(thickness: 5),
            ],
          ),
        ),
      ),
    );
  }
}
