import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryboy/Services/FirebaseServices.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class OrdersServices {
  FirebaseServices _services = FirebaseServices();

  Color statusColor(DocumentSnapshot document) {
    if (document['orderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document['orderStatus'] == 'Accepted') {
      return Colors.blueGrey[400];
    }
    if (document['orderStatus'] == 'Rejected') {
      return Colors.red;
    }
    if (document['orderStatus'] == 'Picked Up') {
      return Colors.pink[900];
    }
    if (document['orderStatus'] == 'On the way') {
      return Colors.purple[900];
    }
    if (document['orderStatus'] == 'Delivered') {
      return Colors.green;
    }

    return Colors.orange;
  }

  Icon statusIcon(DocumentSnapshot document) {
    if (document['orderStatus'] == 'Accepted') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }
    if (document['orderStatus'] == 'Rejected') {
      return Icon(
        Icons.cases,
        color: statusColor(document),
      );
    }
    if (document['orderStatus'] == 'Picked Up') {
      return Icon(
        Icons.delivery_dining,
        color: statusColor(document),
      );
    }
    if (document['orderStatus'] == 'On the way') {
      return Icon(
        Icons.shopping_bag_outlined,
        color: statusColor(document),
      );
    }
    if (document['orderStatus'] == 'Delivered') {
      return Icon(
        Icons.assignment_turned_in_outlined,
        color: statusColor(document),
      );
    }

    return Icon(
      Icons.done_all_outlined,
      color: statusColor(document),
    );
  }

  showMyDialog({title, status, documentId, context}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(
            'Make sure you have received payment',
            style: TextStyle(letterSpacing: 1),
          ),
          actions: [
            TextButton(
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: documentId, status: 'Delivered')
                    .then((value) {
                  EasyLoading.showSuccess('Order status is now \'Delivered\'');
                  Navigator.pop(context);
                });
              },
              child: Text(
                'RECEIVE',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget statusContainer(DocumentSnapshot document, context) {
    if (document['deliveryBoy']['name'].length > 1) {
      if (document['orderStatus'] == 'Accepted') {
        return Container(
          color: Colors.grey[300],
          height: 50,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
            child: TextButton(
              onPressed: () {
                EasyLoading.show();
                _services
                    .updateStatus(id: document.id, status: 'Picked Up')
                    .then((value) {
                  EasyLoading.showSuccess('Order Status is now Picked Up');
                });
              },
              child: Text(
                'Pick Up',
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  statusColor(document),
                ),
              ),
            ),
          ),
        );
      }
    }

    if (document['orderStatus'] == 'Picked Up') {
      return Container(
        color: Colors.grey[300],
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
          child: TextButton(
            onPressed: () {
              EasyLoading.show();
              _services
                  .updateStatus(id: document.id, status: 'On the way')
                  .then((value) {
                EasyLoading.showSuccess('On the way to Pick up the order');
              });
            },
            child: Text(
              'On the way',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                statusColor(document),
              ),
            ),
          ),
        ),
      );
    }

    if (document['orderStatus'] == 'On the way') {
      return Container(
        color: Colors.grey[300],
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
          child: TextButton(
            onPressed: () {
              if (document['cod'] == true) {
                return showMyDialog(
                  context: context,
                  title: 'Recived Payment',
                  status: 'Delivered',
                  documentId: document.id,
                );
              } else {
                EasyLoading.show();
                _services
                    .updateStatus(id: document.id, status: 'Delivered')
                    .then((value) {
                  EasyLoading.showSuccess('Order is delivered now.');
                });
              }
            },
            child: Text(
              'Deliver Order',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                statusColor(document),
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.grey[300],
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: TextButton(
        onPressed: () {},
        child: Text(
          'Order Completed',
          style: TextStyle(color: Colors.white),
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
            statusColor(document),
          ),
        ),
      ),
    );
  }

  void launchCall(number) async => await canLaunch(number)
      ? await launch(number)
      : throw 'Could not launch $number';

  void launchMap(lat, log, name) async {
    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps);

    await availableMaps.first.showMarker(
      coords: Coords(lat, log),
      title: name,
    );
  }
}

//  document['deliveryBoy']['image'] == null
//           ? Container()
//           : ListTile(
//               leading: CircleAvatar(
//                 backgroundColor: Colors.white,
//                 child: Image.network(document['deliveryBoy']['image']),
//               ),
//               title: new Text(document['deliveryBoy']['name']),
//               trailing: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   IconButton(
//                     icon: Icon(
//                       Icons.map_outlined,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     onPressed: () {
//                       GeoPoint location = document['deliveryBoy']['location'];
//                       launchMap(location, document['deliveryBoy']['name']);
//                     },
//                   ),
//                   IconButton(
//                     icon: Icon(
//                       Icons.phone,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                     onPressed: () {
//                       launchCall('tel:${document['deliveryBoy']['phone']}');
//                     },
//                   ),
//                 ],
//               ),
//             );
