import 'dart:html';

import 'package:adminpanel2/Services/Firebase_services.dart';
import 'package:adminpanel2/Widgets/Vendors/VendorDetailsBox.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VendorDatTable extends StatefulWidget {
  @override
  _VendorDatTableState createState() => _VendorDatTableState();
}

class _VendorDatTableState extends State<VendorDatTable> {
  FirebaseServices _services = FirebaseServices();

  int tag = 0;
  List<String> options = [
    'All Vendor\'s',
    'Active',
    'Inactive',
    'Top Picked',
    // 'Top Rated',
  ];

  bool topPicked;
  bool active;

  filter(val) {
    if (val == 1) {
      setState(() {
        active = true;
      });
    }
    if (val == 2) {
      setState(() {
        active = false;
      });
    }
    if (val == 3) {
      setState(() {
        topPicked = true;
      });
    }
    if (val == 0) {
      setState(() {
        topPicked = null;
        active = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ChipsChoice<int>.single(
          value: tag,
          onChanged: (val) {
            setState(() {
              tag = val;
            });
            print('Filter Value: ' + '$val');
            filter(val);
          },
          choiceItems: C2Choice.listFrom<int, String>(
            activeStyle: (i, v) {
              return C2ChoiceStyle(
                brightness: Brightness.dark,
                color: Colors.black54,
              );
            },
            source: options,
            value: (i, v) => i,
            label: (i, v) => v,
          ),
        ),
        Divider(
          thickness: 5,
        ),
        StreamBuilder(
          stream: _services.vendors
              .where('isTopPicked', isEqualTo: topPicked)
              .where('accVerified', isEqualTo: active)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went worng');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),

                //table Headers
                columns: <DataColumn>[
                  DataColumn(label: Text('Active/Inactive')),
                  DataColumn(label: Text('Top Picked')),
                  DataColumn(label: Text('Shop Name')),
//TODO:
                  // DataColumn(label: Text('Rating')),
                  // DataColumn(label: Text('Total Sale')),
                  DataColumn(label: Text('Mobile')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('View Details')),
                ],

                //Details
                rows: _vendorsDetailsRows(snapshot.data, _services),
              ),
            );
          },
        )
      ],
    );
  }

  List<DataRow> _vendorsDetailsRows(
      QuerySnapshot snapshot, FirebaseServices services) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      return DataRow(
        cells: [
          DataCell(
            IconButton(
              icon: document['accVerified']
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.remove_circle,
                      color: Colors.red,
                    ),
              onPressed: () {
                services.updateVendorStatus(
                  id: document['uid'],
                  status: document['accVerified'],
                );
              },
            ),
          ),

          ////////////////////////////////////////////////////////////////////////////////////////////////
          DataCell(
            IconButton(
              icon: document['isTopPicked']
                  ? Icon(
                      Icons.check_circle,
                      color: Colors.green,
                    )
                  : Icon(null),
              onPressed: () {
                services.updateTopPickStatus(
                  id: document['uid'],
                  status: document['isTopPicked'],
                );
              },
            ),
          ),

          ///////////////////////////////////////////////////////////////////////////////////////////////
          DataCell(Text(document['shopName'])),

          ///////////////////////////////////////////////////////////////////////////////////////////////

          // DataCell(
          //   Row(
          //     children: [
          //       Icon(
          //         Icons.star,
          //         color: Colors.grey,
          //       ),
          //       Text('3.5')
          //     ],
          //   ),
          // ),

          /////////////////////////////////////////////////////////////////////////////////////////////

          // DataCell(Text('20,000')),

          ////////////////////////////////////////////////////////////////////////////////////////////

          DataCell(Text(document['mobile'])),

          /////////////////////////////////////////////////////////////////////////////////////////////

          DataCell(Text(document['email'])),

          ////////////////////////////////////////////////////////////////////////////////////////////

          DataCell(
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                //will popup Vendor Details screen
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VendorDetailsBox(document['uid']);
                    });
              },
            ),
          ),
        ],
      );
    }).toList();
    return newList;
  }
}
