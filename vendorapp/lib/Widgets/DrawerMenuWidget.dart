import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp/Provider/ProductProvider.dart';
import 'package:vendorapp/Screens/LoginScreen.dart';

class MenuWidget extends StatefulWidget {
  final Function(String) onItemClick;

  const MenuWidget({Key key, this.onItemClick}) : super(key: key);

  @override
  _MenuWidgetState createState() => _MenuWidgetState();
}

class _MenuWidgetState extends State<MenuWidget> {
  User user = FirebaseAuth.instance.currentUser;
  var vendorsData;

  @override
  void initState() {
    getVendorData();
    super.initState();
  }

  Future<DocumentSnapshot> getVendorData() async {
    var result = await FirebaseFirestore.instance
        .collection('vendors')
        .doc(user.uid)
        .get();

    setState(() {
      vendorsData = result;
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    _provider.getShopName(vendorsData != null ? vendorsData['shopName'] : '');
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 4,
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: FittedBox(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.grey,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: vendorsData != null
                          ? NetworkImage(vendorsData['imageUrl'])
                          : null,
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    vendorsData != null ? vendorsData['shopName'] : 'Shop Name',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          sliderItem('Dashboard', Icons.dashboard_outlined),
          sliderItem('Product', Icons.shopping_bag_outlined),
          sliderItem('Banner', CupertinoIcons.photo_on_rectangle),
          sliderItem('Coupons', CupertinoIcons.gift),
          sliderItem('Orders', Icons.list_alt_outlined),
          sliderItem('Reports', Icons.stacked_bar_chart),
          sliderItem('Setting', Icons.settings_outlined),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]),
                ),
              ),
              child: SizedBox(
                height: 40,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        color: Colors.black54,
                        size: 18,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'LogOut',
                        style: TextStyle(color: Colors.black, fontSize: 12),
                      )
                    ],
                  ),
                ),
              ),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut().then((value) {
                Navigator.pushReplacementNamed(context, LoginScreen.id);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget sliderItem(String title, IconData icons) => InkWell(
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.grey[300]),
            ),
          ),
          child: SizedBox(
            height: 40,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Row(
                children: [
                  Icon(
                    icons,
                    color: Colors.black54,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Text(
                    title,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  )
                ],
              ),
            ),
          ),
        ),
        onTap: () {
          widget.onItemClick(title);
          print(title);
        },
      );
}
