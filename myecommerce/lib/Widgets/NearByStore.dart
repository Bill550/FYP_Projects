import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:myecommerce/Constants.dart';
import 'package:myecommerce/Providers/CartProvider.dart';
import 'package:myecommerce/Providers/StoreProvider.dart';
import 'package:myecommerce/Screens/VendorHomeScreen.dart';
import 'package:myecommerce/Services/StoreServices.dart';
import 'package:paginate_firestore/bloc/pagination_listeners.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class NearByStore extends StatefulWidget {
  @override
  _NearByStoreState createState() => _NearByStoreState();
}

class _NearByStoreState extends State<NearByStore> {
  StoreServices _storeServices = StoreServices();

  PaginateRefreshedChangeListener refreshedChangeListener =
      PaginateRefreshedChangeListener();

  @override
  Widget build(BuildContext context) {
    final _storeData = Provider.of<StoreProvider>(context);

    final _cart = Provider.of<CartProvider>(context);

    _storeData.getUserLocationData(context);

    String getDistance(location) {
      var distance = Geolocator.distanceBetween(
        _storeData.userLatitude,
        _storeData.userLongitude,
        location.latitude,
        location.longitude,
      );
      // print('the Distance between => => => => => => => => ' + '$distance');
      var distanceInKM = distance / 1000; //this will show in KM
      return distanceInKM.toStringAsFixed(2);
    }

    return Container(
      color: Colors.white,
      child: StreamBuilder<QuerySnapshot>(
        stream: _storeServices.getNearByStore(), //TODO: Will change it soon
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          // now we need to show store with in 30KM distance.
          // need to confirm even no shop near by or not.

          List shopDistance = [];
          for (int i = 0; i <= snapshot.data.docs.length - 1; i++) {
            var distance = Geolocator.distanceBetween(
              _storeData.userLatitude,
              _storeData.userLongitude,
              snapshot.data.docs[i]['location'].latitude,
              snapshot.data.docs[i]['location'].longitude,
            );
            var distanceInKM = distance / 1000;
            shopDistance.add(distanceInKM);
          }
          // this will sort with nearest distance. if nearest distance is more than 30, that mean no shop near by;
          shopDistance.sort();

          SchedulerBinding.instance.addPostFrameCallback((_) => setState(() {
                _cart.getDistance(shopDistance[0]);
              }));

          if (shopDistance[0] > 30) {
            return Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30, top: 30, left: 20, right: 20),
                    child: Container(
                      child: Center(
                        child: Text(
                          'Currently we are not servicing in your area, Please try again later or another location',
                          textAlign: TextAlign.left,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Image.asset(
                    'assets/images/City.png',
                  ),
                  Positioned(
                    right: 10.0,
                    top: 80.0,
                    child: Container(
                      width: 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Made by : ',
                            style: TextStyle(color: Colors.black54),
                          ),
                          Text(
                            'Bill550',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Anton',
                              letterSpacing: 2,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RefreshIndicator(
                  child: PaginateFirestore(
                    bottomLoader: SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    ),
                    header: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, right: 8, top: 20),
                          child: Text(
                            'All Nearby Stores',
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 5, bottom: 10),
                          child: Text(
                            'Findout Quality Products Nearby You',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilderType: PaginateBuilderType.listView,
                    itemBuilder: (index, context, document) => Padding(
                      padding: const EdgeInsets.all(4),
                      child: InkWell(
                        onTap: () {
                          _storeData.getSelectedStore(
                              document, getDistance(document['location']));
                          pushNewScreenWithRouteSettings(
                            context,
                            settings: RouteSettings(name: VendorHomeScreen.id),
                            screen: VendorHomeScreen(),
                            withNavBar: true,
                            pageTransitionAnimation:
                                PageTransitionAnimation.cupertino,
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 100,
                                height: 110,
                                child: Card(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(4),
                                    child: Image.network(
                                      document['imageUrl'],
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    child: Text(
                                      document['shopName'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width - 160,
                                    child: Text(
                                      document['dialog'],
                                      overflow: TextOverflow.ellipsis,
                                      style: kStoreCardStyle,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 160,
                                    child: Text(
                                      document['address'],
                                      overflow: TextOverflow.ellipsis,
                                      style: kStoreCardStyle,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    '${getDistance(document['location'])}KM',
                                    overflow: TextOverflow.ellipsis,
                                    style: kStoreCardStyle,
                                  ),
                                  SizedBox(height: 3),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '3.2',
                                        style: kStoreCardStyle,
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    query: _storeServices.getNearByStorePagination(),
                    listeners: [refreshedChangeListener],
                    footer: Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Container(
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                '**That\'s all folks**',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                            Stack(
                              children: [
                                Image.asset(
                                  'assets/images/City.png',
                                ),
                                Positioned(
                                  right: 00.0,
                                  top: 10.0,
                                  child: Container(
                                    width: 100,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Made by : ',
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        Text(
                                          'Bill550',
                                          style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                            fontFamily: 'Anton',
                                            letterSpacing: 2,
                                            color: Colors.grey,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  onRefresh: () async {
                    refreshedChangeListener.refreshed = true;
                  },
                )
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:myecommerce/Constants.dart';
// import 'package:myecommerce/Providers/StoreProvider.dart';
// import 'package:myecommerce/Services/StoreServices.dart';
// import 'package:paginate_firestore/bloc/pagination_listeners.dart';
// import 'package:paginate_firestore/paginate_firestore.dart';
// import 'package:provider/provider.dart';

// class NearByStore extends StatefulWidget {
//   @override
//   _NearByStoreState createState() => _NearByStoreState();
// }

// class _NearByStoreState extends State<NearByStore> {
//   StoreServices _storeServices = StoreServices();
//   PaginateRefreshedChangeListener refreshedChangeListener =
//       PaginateRefreshedChangeListener();

//   @override
//   Widget build(BuildContext context) {
//     final _storeData = Provider.of<StoreProvider>(context);

//     _storeData.getUserLocationData(context);

//     String getDistance(location) {
//       var distance = Geolocator.distanceBetween(
//         _storeData.userLatitude,
//         _storeData.userLongitude,
//         location.latitude,
//         location.longitude,
//       );
//       print('the Distance between => => => => => => => => ' + '$distance');
//       var distanceInKM = distance / 1000; //this will show in KM
//       return distanceInKM.toStringAsFixed(2);
//     }

//     return Container(
//       color: Colors.white,
//       child: StreamBuilder<QuerySnapshot>(
//         stream: _storeServices.getNearByStore(), //TODO: Will change it soon
//         builder: (BuildContext context,
//             AsyncSnapshot<QuerySnapshot<dynamic>> snapshot) {
//           if (!snapshot.hasData)
//             return Center(child: CircularProgressIndicator());

//           // now we need to show store with in 30KM distance.
//           // need to confirm even no shop near by or not.

//           List shopDistance = [];
//           for (int i = 0; i <= snapshot.data.docs.length - 1; i++) {
//             var distance = Geolocator.distanceBetween(
//               _storeData.userLatitude,
//               _storeData.userLongitude,
//               snapshot.data.docs[i]['location'].latitude,
//               snapshot.data.docs[i]['location'].longitude,
//             );
//             var distanceInKM = distance / 1000;
//             shopDistance.add(distanceInKM);
//           }
//           // this will sort with nearest distance. if nearest distance is more than 30, that mean no shop near by;
//           shopDistance.sort();

//           if (shopDistance[0] > 30) {
//             return Container(
//               child: Stack(
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.only(
//                         bottom: 30, top: 30, left: 20, right: 20),
//                     child: Container(
//                       child: Center(
//                         child: Text(
//                           'Currently we are not servicing in your area, Please try again later or another location',
//                           textAlign: TextAlign.left,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                             color: Colors.black54,
//                             fontSize: 20,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 40),
//                   Image.asset('assets/images/City.png', color: Colors.white),
//                   Positioned(
//                     right: 10.0,
//                     top: 80.0,
//                     child: Container(
//                       width: 100,
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             'Made by : ',
//                             style: TextStyle(color: Colors.black54),
//                           ),
//                           Text(
//                             'Bill550',
//                             style: TextStyle(
//                               fontWeight: FontWeight.bold,
//                               fontFamily: 'Anton',
//                               letterSpacing: 2,
//                               color: Colors.grey,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           }
//           return Padding(
//             padding: const EdgeInsets.all(8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 RefreshIndicator(
//                   child: PaginateFirestore(
//                     bottomLoader: SizedBox(
//                       height: 30,
//                       width: 30,
//                       child: CircularProgressIndicator(
//                         valueColor: AlwaysStoppedAnimation<Color>(
//                             Theme.of(context).primaryColor),
//                       ),
//                     ),
//                     header: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Padding(
//                           padding:
//                               const EdgeInsets.only(left: 8, right: 8, top: 20),
//                           child: Text(
//                             'All Nearby Stores',
//                             style: TextStyle(
//                               fontWeight: FontWeight.w900,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.only(
//                               left: 8, right: 8, top: 5, bottom: 10),
//                           child: Text(
//                             'Findout Quality Products Nearby You',
//                             style: TextStyle(
//                               fontSize: 12,
//                               color: Colors.grey,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemBuilderType: PaginateBuilderType.listView,
//                     itemBuilder: (index, context, document) => Padding(
//                       padding: const EdgeInsets.all(4),
//                       child: Container(
//                         width: MediaQuery.of(context).size.width,
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             SizedBox(
//                               width: 100,
//                               height: 110,
//                               child: Card(
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(4),
//                                   child: Image.network(
//                                     document['imageUrl'],
//                                     fit: BoxFit.cover,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             Column(
//                               mainAxisSize: MainAxisSize.min,
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   child: Text(
//                                     document['shopName'],
//                                     style: TextStyle(
//                                       fontSize: 14,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                     maxLines: 2,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 SizedBox(height: 3),
//                                 Text(
//                                   document['dialog'],
//                                   style: kStoreCardStyle,
//                                 ),
//                                 SizedBox(height: 3),
//                                 Container(
//                                   width:
//                                       MediaQuery.of(context).size.width - 250,
//                                   child: Text(
//                                     document['address'],
//                                     overflow: TextOverflow.ellipsis,
//                                     style: kStoreCardStyle,
//                                   ),
//                                 ),
//                                 SizedBox(height: 3),
//                                 Text(
//                                   '${getDistance(document['location'])}KM',
//                                   overflow: TextOverflow.ellipsis,
//                                   style: kStoreCardStyle,
//                                 ),
//                                 SizedBox(height: 3),
//                                 Row(
//                                   children: [
//                                     Icon(
//                                       Icons.star,
//                                       size: 12,
//                                       color: Colors.grey,
//                                     ),
//                                     SizedBox(width: 4),
//                                     Text(
//                                       '3.2',
//                                       style: kStoreCardStyle,
//                                     ),
//                                   ],
//                                 )
//                               ],
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                     query: _storeServices.getNearByStorePagination(),
//                     listeners: [refreshedChangeListener],
//                     footer: Padding(
//                       padding: EdgeInsets.only(top: 30),
//                       child: Container(
//                         child: Stack(
//                           children: [
//                             Center(
//                               child: Text(
//                                 '**That\'s all folks**',
//                                 style: TextStyle(color: Colors.grey),
//                               ),
//                             ),
//                             Image.asset('assets/images/City.png',
//                                 color: Colors.white),
//                             Positioned(
//                               right: 10.0,
//                               top: 80.0,
//                               child: Container(
//                                 width: 100,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       'Made by : ',
//                                       style: TextStyle(color: Colors.black54),
//                                     ),
//                                     Text(
//                                       'Bill550',
//                                       style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontFamily: 'Anton',
//                                         letterSpacing: 2,
//                                         color: Colors.grey,
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   onRefresh: () async {
//                     refreshedChangeListener.refreshed = true;
//                   },
//                 )
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
