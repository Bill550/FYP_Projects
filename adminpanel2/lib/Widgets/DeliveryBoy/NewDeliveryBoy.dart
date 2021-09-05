import 'package:adminpanel2/Services/Firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_switch/flutter_switch.dart';

class NewDeliveryBoy extends StatefulWidget {
  @override
  _NewDeliveryBoyState createState() => _NewDeliveryBoyState();
}

class _NewDeliveryBoyState extends State<NewDeliveryBoy> {
  bool status = false;

  FirebaseServices _services = FirebaseServices();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream:
            _services.boys.where('accVerified', isEqualTo: false).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went worng...'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          QuerySnapshot snap = snapshot.data;

          if (snap.size == 0) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text('No new delivery boy has registered')
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: DataTable(
              showBottomBorder: true,
              dataRowHeight: 60,
              headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
              columns: <DataColumn>[
                DataColumn(label: Expanded(child: Text('Profile'))),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Mobile')),
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Address')),
                DataColumn(label: Text('Action')),
              ],
              rows: _deliveryBoyDetails(snapshot.data, context),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _deliveryBoyDetails(QuerySnapshot snapshot, context) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      if (document != null) {
        return DataRow(
          cells: [
            DataCell(
              Container(
                width: 60,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: document['imageUrl'] == ''
                      ? Icon(Icons.person, size: 40)
                      : Image.network(
                          '${document['imageUrl']}',
                          fit: BoxFit.contain,
                        ),
                ),
              ),
            ),
            DataCell(
              Text('${document['boyName']}'),
            ),
            DataCell(
              Text('${document['mobile']}'),
            ),
            DataCell(
              Text('${document['email']}'),
            ),
            DataCell(
              Text('${document['address']}'),
            ),
            DataCell(
              document['mobile'] == ''
                  ? Text('Not registered')
                  : FlutterSwitch(
                      activeText: "Approved",
                      inactiveText: "Refuse",
                      value: document['accVerified'],
                      valueFontSize: 10.0,
                      width: 110,
                      borderRadius: 30.0,
                      showOnOff: true,
                      onToggle: (val) {
                        _services.updateDeliveryBoysStatus(
                          context: context,
                          id: document.id,
                          status: true,
                        );
                      },
                    ),
            ),
          ],
        );
      }
    }).toList();

    return newList;
  }
}
