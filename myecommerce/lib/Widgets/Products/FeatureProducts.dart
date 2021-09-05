import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myecommerce/Providers/StoreProvider.dart';
import 'package:myecommerce/Services/ProductServices.dart';
import 'package:myecommerce/Widgets/Products/ProductCardWidget.dart';
import 'package:provider/provider.dart';

class FeatureProducts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProductServices _services = ProductServices();
    var _store = Provider.of<StoreProvider>(context);

    return FutureBuilder<QuerySnapshot>(
      future: _services.products
          .where('published', isEqualTo: true)
          .where('collection', isEqualTo: 'Featured Products')
          .where('seller.sellerUid', isEqualTo: _store.storeDetails['uid'])
          .get(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (!snapshot.hasData) {
          return Container();
        }

        if (snapshot.data.docs.isEmpty) {
          return Container();
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 46,
                  decoration: BoxDecoration(
                    color: Colors.teal[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      'Featured Products',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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
            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: snapshot.data.docs.map((DocumentSnapshot document) {
                return ProductCard(document);
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
