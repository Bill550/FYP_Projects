import 'package:adminpanel2/Services/SideBarWidget.dart';
import 'package:adminpanel2/Widgets/Categories/CategoryListWidget.dart';
import 'package:adminpanel2/Widgets/Categories/CategoryUploadWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class CategoriesScreen extends StatelessWidget {
  static const String id = 'categories-screen';
  @override
  Widget build(BuildContext context) {
    SideBarWidget _sideBarWidget = SideBarWidget();

    return AdminScaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.black87,
        iconTheme: IconThemeData(color: Colors.white),
        title: const Text(
          'Dashboard',
          style: TextStyle(color: Colors.white),
        ),
      ),
      sideBar: _sideBarWidget.sideBarMenus(context, CategoriesScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Categories Screen',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Add new Categories and Sub-Categories'),
              Divider(thickness: 5),
              CategoryUploadWidget(),
              Divider(thickness: 5),
              CategoryListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
