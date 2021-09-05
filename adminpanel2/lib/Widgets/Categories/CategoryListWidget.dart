import 'package:adminpanel2/Services/Firebase_services.dart';
import 'package:adminpanel2/Widgets/Categories/CategoryCardWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _services.category.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Somthing went worng'),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Wrap(
            direction: Axis.horizontal,
            children: snapshot.data.docs.map((DocumentSnapshot document) {
              return CategoryCard(document);
            }).toList(),
          );
        },
      ),
    );
  }
}
