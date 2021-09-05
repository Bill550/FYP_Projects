import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vendorapp/Services/Firebase_services.dart';
import 'package:vendorapp/Services/OrderServices.dart';

class DeliveryBoysList extends StatefulWidget {
  final DocumentSnapshot document;

  DeliveryBoysList(this.document);

  @override
  _DeliveryBoysListState createState() => _DeliveryBoysListState();
}

class _DeliveryBoysListState extends State<DeliveryBoysList> {
  FirebaseServices _services = FirebaseServices();
  OrderServices _orderServices = OrderServices();

  GeoPoint _shopLocation;

  @override
  void initState() {
    _services.getshopDetails().then((value) {
      if (value != null) {
        if (mounted) {
          setState(() {
            _shopLocation = value['location'];
          });
        }
      } else {
        print('No Data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              iconTheme: IconThemeData(color: Colors.white),
              title: Text(
                'Select Delivery Boys',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: Column(
                children: [
                  Text('Select the delivery boy'),
                  Text('Click on the delivery boy to select'),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _services.boys
                    .where('accVerified', isEqualTo: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  return new ListView(
                    shrinkWrap: true,
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      GeoPoint location = document['location'];
                      double distanceInMeters = _shopLocation == null
                          ? 0.0
                          : Geolocator.distanceBetween(
                                _shopLocation.latitude,
                                _shopLocation.longitude,
                                location.latitude,
                                location.longitude,
                              ) /
                              1000;

                      if (distanceInMeters > 10) {
                        Container();
                      }
                      return Column(
                        children: [
                          ListTile(
                            onTap: () {
                              EasyLoading.show(status: 'Assigning boy...');
                              _services
                                  .selectBoy(
                                orderId: widget.document.id,
                                name: document['boyName'],
                                phone: document['mobile'],
                                image: document['imageUrl'],
                                location: document['location'],
                                email: document['email'],
                              )
                                  .then((value) {
                                EasyLoading.showSuccess(
                                    'Assigned Delivery Boy');
                                Navigator.pop(context);
                              });
                            },
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(document['imageUrl']),
                            ),
                            title: new Text(document['boyName']),
                            subtitle: new Text(
                              '${distanceInMeters.toStringAsFixed(0)} KM',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.map_outlined,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    GeoPoint location = document['location'];
                                    _orderServices.launchMap(
                                      location,
                                      document['boyName'],
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    Icons.phone,
                                    color: Theme.of(context).primaryColor,
                                  ),
                                  onPressed: () {
                                    _orderServices.launchCall(
                                        'tel:${document['mobile']}');
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                          )
                        ],
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
