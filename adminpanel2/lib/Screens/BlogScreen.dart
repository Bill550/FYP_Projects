import 'package:adminpanel2/Services/SideBarWidget.dart';
import 'package:adminpanel2/Widgets/Blog/BlogListWidget.dart';
import 'package:adminpanel2/Widgets/Blog/blogUploadWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';

class BlogScreen extends StatelessWidget {
  static const String id = 'blog-screen';
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
      sideBar: _sideBarWidget.sideBarMenus(context, BlogScreen.id),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Blog Screen',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                ),
              ),
              Text('Add new Blog'),
              Divider(thickness: 5),
              BlogUploadWidget(),
              Divider(thickness: 5),
              Row(
                children: [
                  Text('Scroll down For all blog'),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_downward_outlined)
                ],
              ),
              Divider(thickness: 5),
              BlogListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
