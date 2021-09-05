import 'package:flutter/material.dart';
import 'package:vendorapp/Screens/AddNewProductScreen.dart';
import 'package:vendorapp/Widgets/PublishedProduct.dart';
import 'package:vendorapp/Widgets/UnPublishedProduct.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // appBar: AppBar(
        //   iconTheme: IconThemeData(color: Colors.white),
        // ),
        body: Column(
          children: [
            Material(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Container(
                        child: Row(
                          children: [
                            Text('Products'),
                            SizedBox(width: 10),
                            CircleAvatar(
                              backgroundColor: Colors.black54,
                              maxRadius: 8,
                              child: FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    '20',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(0),
                      child: TextButton.icon(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        label: Text(
                          'Add New',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AddNewProduct.id);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
            TabBar(
              indicatorColor: Theme.of(context).primaryColor,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.black54,
              tabs: [
                Tab(
                  text: 'PUBLISHED',
                ),
                Tab(
                  text: 'UN-PUBLISHED',
                ),
              ],
            ),
            Expanded(
              child: Container(
                child: TabBarView(
                  children: [
                    PublishedProduct(),
                    UnPublishedProduct(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
