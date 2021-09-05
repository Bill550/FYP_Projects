import 'package:adminpanel2/Services/SideBarWidget.dart';
import 'package:adminpanel2/Widgets/DeliveryBoy/ApprovedDeliveryBoy.dart';
import 'package:adminpanel2/Widgets/DeliveryBoy/CreateDeliveryBoy.dart';
import 'package:adminpanel2/Widgets/DeliveryBoy/NewDeliveryBoy.dart';
import 'package:adminpanel2/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class DeliveryBoyScreen extends StatelessWidget {
  static const String id = 'delivery-screen';

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBarWidget = SideBarWidget();

    return DefaultTabController(
      length: 2,
      child: AdminScaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          iconTheme: IconThemeData(color: Colors.white),
          title: const Text(
            'Dashboard',
            style: TextStyle(color: Colors.white),
          ),
        ),
        sideBar: _sideBarWidget.sideBarMenus(context, DeliveryBoyScreen.id),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                Text(
                  'DeliveryBoy Screen',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                  ),
                ),
                Text(
                  'Create And Manage All Delivery Boys',
                ),
                Divider(thickness: 5),
                CreateNewBoyWidget(),
                Divider(thickness: 5),
                TabBar(
                  indicatorColor: greenColor,
                  labelColor: greenColor,
                  unselectedLabelColor: Colors.black54,
                  tabs: [
                    Tab(text: 'NEW'),
                    Tab(text: 'APPROVED'),
                  ],
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      children: [
                        NewDeliveryBoy(),
                        ApprovedDeliveryBoy(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
