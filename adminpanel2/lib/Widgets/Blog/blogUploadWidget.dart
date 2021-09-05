import 'package:adminpanel2/Widgets/Blog/AddBlogWidget.dart';
import 'package:flutter/material.dart';

class BlogUploadWidget extends StatefulWidget {
  @override
  _BlogUploadWidgetState createState() => _BlogUploadWidgetState();
}

class _BlogUploadWidgetState extends State<BlogUploadWidget> {
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AddBlogWidget();
            },
          );
        },
        child: Container(
          height: 40,
          width: 150,
          child: Center(
            child: Text(
              'Add New Blog',
              style: TextStyle(color: Colors.white),
            ),
          ),
          decoration: BoxDecoration(color: Colors.black54),
        ),
      ),
    );
  }
}
