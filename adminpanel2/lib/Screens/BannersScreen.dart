import 'package:adminpanel2/Services/SideBarWidget.dart';
import 'package:adminpanel2/Widgets/Banners/BannerUploadWidget.dart';
import 'package:adminpanel2/Widgets/Banners/BannersWidget.dart';
import 'package:adminpanel2/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class BannersScreen extends StatelessWidget {
  static const String id = 'banner-screen';

  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBarWidget = SideBarWidget();

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
      sideBar: _sideBarWidget.sideBarMenus(context, BannersScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Banners Screen',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Add / Delete Home Screen Banner Images'),
              Divider(thickness: 5),
              //Banners
              BannersWidget(),
              Divider(thickness: 5),
              BannerUploadWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
