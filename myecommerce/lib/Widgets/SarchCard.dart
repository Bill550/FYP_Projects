import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myecommerce/Models/ProductModel.dart';
import 'package:myecommerce/Screens/ProductDetailsScreen.dart';
import 'package:myecommerce/Widgets/Cart/Counter.dart';

import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({
    this.offer,
    this.products,
    this.document,
  });

  final String offer;
  final ProductModel products;
  final DocumentSnapshot document;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 160,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1, color: Colors.grey[300]),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 8.0,
          bottom: 8.0,
          left: 10.0,
          right: 10.0,
        ),
        child: Row(
          children: [
            Stack(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(10),
                  child: InkWell(
                    onTap: () {
                      print(products.productName);

                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: ProductDetailsScreen.id),
                        screen:
                            ProductDetailsScreen(document: products.document),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    child: SizedBox(
                      height: 140,
                      width: 130,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Hero(
                          tag: 'product${products.document['productName']}',
                          child: Image.network(
                            products.document['productImage'],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (products.document['comparedPrice'] > 0)
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 3,
                        bottom: 3,
                      ),
                      child: Text(
                        '$offer %OFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          products.document['brand'],
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(height: 6),
                        Text(
                          products.document['productName'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        Container(
                          width: MediaQuery.of(context).size.width - 160,
                          padding: EdgeInsets.only(
                            top: 10,
                            bottom: 10,
                            left: 6,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.grey[200],
                          ),
                          child: Text(
                            '${products.document['weight']}KG',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Row(
                          children: [
                            Text(
                              'PKR: ${products.document['price'].toStringAsFixed(0)}',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(width: 10),
                            if (products.document['comparedPrice'] > 0)
                              Text(
                                'PKR: ${products.document['comparedPrice'].toStringAsFixed(0)}',
                                style: TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey,
                                  fontSize: 10,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            CounterForCard(
                              document: products.document,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
