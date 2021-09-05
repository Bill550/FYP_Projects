import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vendorapp/Widgets/DeliveryBoysList.dart';

class OrderServices {
  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  Future<void> updateOrderStatus(documentId, status) {
    var result = orders.doc(documentId).update({
      'orderStatus': status,
    });
    return result;
  }

  Color statusColor(DocumentSnapshot document) {
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

  showMyDialog(title, status, documentId, context) {
    OrderServices _orderServices = OrderServices();

    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(
            'Are you sure?',
            style: TextStyle(letterSpacing: 1),
          ),
          actions: [
            TextButton(
              onPressed: () {
                EasyLoading.show(status: 'Updating Status...');
                status == 'Accepted'
                    ? _orderServices
                        .updateOrderStatus(documentId, status)
                        .then((value) {
                        EasyLoading.showSuccess('Updated Successfully');
                      })
                    : _orderServices
                        .updateOrderStatus(documentId, status)
                        .then((value) {
                        EasyLoading.showSuccess('Updated Successfully');
                      });
                Navigator.pop(context);
              },
              child: Text(
                'OK',
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
      return document['deliveryBoy']['image'] == null
          ? Container()
          : ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                child: Image.network(document['deliveryBoy']['image']),
              ),
              title: new Text(document['deliveryBoy']['name']),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () {
                      GeoPoint location = document['deliveryBoy']['location'];
                      launchMap(location, document['deliveryBoy']['name']);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        child: Icon(
                          Icons.map_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  InkWell(
                    onTap: () {
                      launchCall('tel:${document['deliveryBoy']['phone']}');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        child: Icon(
                          Icons.phone_in_talk_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
    }

    if (document['orderStatus'] == 'Accepted') {
      return Container(
        color: Colors.grey[300],
        height: 50,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 8, 40, 8),
          child: TextButton(
            onPressed: () {
              print('Select Delivery boy');
              showDialog(
                context: context,
                builder: (BuildContext builder) {
                  return DeliveryBoysList(document);
                },
              );
            },
            child: Text(
              'Select Delivery Boy',
              style: TextStyle(color: Colors.white),
            ),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                Colors.orangeAccent,
              ),
            ),
          ),
        ),
      );
    }

    return Container(
      color: Colors.grey[300],
      height: 50,
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                onPressed: () {
                  showMyDialog(
                    'Accept Order',
                    'Accepted',
                    document.id,
                    context,
                  );
                },
                child: Text(
                  'Accept',
                  style: TextStyle(color: Colors.white),
                ),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.blueGrey,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: AbsorbPointer(
                absorbing: document['orderStatus'] == 'Rejected' ? true : false,
                child: TextButton(
                  onPressed: () {
                    showMyDialog(
                      'Reject Order',
                      'Rejected',
                      document.id,
                      context,
                    );
                  },
                  child: Text(
                    'Reject',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      document['orderStatus'] == 'Rejected'
                          ? Colors.grey
                          : Colors.red,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void launchCall(number) async => await canLaunch(number)
      ? await launch(number)
      : throw 'Could not launch $number';

  void launchMap(GeoPoint location, name) async {
    final availableMaps = await MapLauncher.installedMaps;
    print(availableMaps);

    await availableMaps.first.showMarker(
      coords: Coords(location.latitude, location.longitude),
      title: name,
    );
  }
}
