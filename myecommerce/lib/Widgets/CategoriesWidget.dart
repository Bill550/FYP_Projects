import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myecommerce/Providers/StoreProvider.dart';
import 'package:myecommerce/Screens/ProductScreen.dart';
import 'package:myecommerce/Services/ProductServices.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class VendorCategories extends StatefulWidget {
  @override
  _VendorCategoriesState createState() => _VendorCategoriesState();
}

class _VendorCategoriesState extends State<VendorCategories> {
  ProductServices _productServices = ProductServices();

  List _cateList = [];

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    FirebaseFirestore.instance
        .collection('products')
        .where('seller.sellerUid', isEqualTo: _store.storeDetails['uid'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        // print('mainCategory =>=>=>=>=>=>=>=>' +
        //     '${doc['category']['mainCategory']}');
        if (mounted) {
          setState(() {
            _cateList.add(doc['category']['mainCategory']);
          });
        }
      });
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);

    return FutureBuilder(
      future: _productServices.category.get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went worng...'));
        }

        if (_cateList.length == 0) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData) {
          return Container();
        }

        return SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/landscape.jpg'),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Shop by Category',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                          shadows: <Shadow>[
                            Shadow(
                                offset: Offset(2.0, 2.0),
                                blurRadius: 3.0,
                                color: Colors.black)
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Wrap(
                direction: Axis.horizontal,
                children: snapshot.data.docs.map((DocumentSnapshot document) {
                  return _cateList.contains(document['name'])
                      ? InkWell(
                          onTap: () {
                            // print(document['name']);
                            _storeProvider
                                .getSelectedCategory(document['name']);

                            _storeProvider.getSelectedSubCategory(null);

                            pushNewScreenWithRouteSettings(
                              context,
                              settings: RouteSettings(name: ProductScreen.id),
                              screen: ProductScreen(),
                              withNavBar: true,
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: Container(
                            width: 100,
                            height: 120,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.grey,
                                  width: .5,
                                ),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Image.network(
                                      document['image'],
                                      // fit: BoxFit.fill,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 8),
                                    child: Text(
                                      document['name'],
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Text('');
                }).toList(),
              ),
            ],
          ),
        );
      },
    );
  }
}
