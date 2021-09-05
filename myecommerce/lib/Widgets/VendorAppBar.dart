import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:myecommerce/Models/ProductModel.dart';
import 'package:myecommerce/Providers/StoreProvider.dart';
import 'package:myecommerce/Widgets/SarchCard.dart';
import 'package:provider/provider.dart';
import 'package:search_page/search_page.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorAppBar extends StatefulWidget {
  @override
  _VendorAppBarState createState() => _VendorAppBarState();
}

class _VendorAppBarState extends State<VendorAppBar> {
  static List<ProductModel> productModel = [];
  String offer;
  String shopName;
  DocumentSnapshot document;

  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('products')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          document = doc;

          offer = ((doc['comparedPrice'] - doc['price']) /
                  doc['comparedPrice'] *
                  100)
              .toStringAsFixed(0);
          productModel.add(ProductModel(
            productName: doc['productName'],
            category: doc['category']['mainCategory'],
            image: doc['productImage'],
            shopName: doc['seller']['shopName'],
            weight: doc['weight'],
            brand: doc['brand'],
            price: doc['price'],
            comparedPrice: doc['comparedPrice'],
            document: doc,
          ));
        });
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    productModel.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);

    mapLauncher() async {
      GeoPoint location = _store.storeDetails['location'];

      final availableMaps = await MapLauncher.installedMaps;

      await availableMaps.first.showMarker(
        coords: Coords(location.latitude, location.longitude),
        title: "${_store.storeDetails['shopName']} iss here",
      );
    }

    return SliverAppBar(
      floating: true,
      snap: true,
      iconTheme: IconThemeData(color: Colors.white),
      expandedHeight: 280,
      flexibleSpace: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(top: 86.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      _store.storeDetails['imageUrl'],
                    ),
                  ),
                ),
                child: Container(
                  color: Colors.grey.withOpacity(.7),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: [
                        Text(
                          _store.storeDetails['dialog'],
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        Text(
                          _store.storeDetails['address'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        Text(
                          _store.storeDetails['email'],
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        Text(
                          'Distance: ' + "${_store.distance}" + 'KM',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        ///
                        ///
                        ///

                        SizedBox(height: 6),

                        ///
                        ///
                        ///
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star_half,
                              color: Colors.white,
                            ),
                            Icon(
                              Icons.star_outline,
                              color: Colors.white,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '(4.5)',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        ///
                        ///
                        ///

                        SizedBox(height: 6),

                        ///
                        ///
                        ///
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: () {
                                  launch(
                                      'tel:+92${_store.storeDetails['mobile']}');
                                },
                                icon: Icon(Icons.phone),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            SizedBox(width: 3),
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              child: IconButton(
                                onPressed: () {
                                  mapLauncher();
                                },
                                icon: Icon(Icons.map),
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            setState(() {
              shopName = _store.storeDetails['shopName'];
            });
            showSearch(
              context: context,
              delegate: SearchPage<ProductModel>(
                onQueryUpdate: (s) => print(s),
                items: productModel,
                searchLabel: 'Search product',
                suggestion: Center(
                  child: Text('Filter product by name, category or price'),
                ),
                failure: Center(
                  child: Text('No product found :('),
                ),
                filter: (products) => [
                  products.productName,
                  products.category,
                  products.brand,
                  products.price.toString(),
                ],
                builder: (products) => shopName != products.shopName
                    ? Container()
                    : SearchCard(
                        offer: offer,
                        products: products,
                        document: products.document,
                      ),
              ),
            );
          },
          icon: Icon(CupertinoIcons.search),
        ),
      ],
      title: Text(
        _store.storeDetails['shopName'],
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
