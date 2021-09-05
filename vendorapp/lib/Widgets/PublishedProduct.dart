import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vendorapp/Services/Firebase_services.dart';

class PublishedProduct extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseServices _services = FirebaseServices();

    return Container(
      child: StreamBuilder(
        stream:
            _services.products.where('published', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went worng...'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: FittedBox(
              child: DataTable(
                showBottomBorder: true,
                dataRowHeight: 60,
                headingRowColor: MaterialStateProperty.all(Colors.grey[200]),
                columns: <DataColumn>[
                  DataColumn(label: Expanded(child: Text('Product Name'))),
                  DataColumn(label: Text('Image')),
                  // DataColumn(label: Text('Info')),
                  DataColumn(label: Text('Action')),
                ],
                rows: _productDetails(snapshot.data),
              ),
            ),
          );
        },
      ),
    );
  }

  List<DataRow> _productDetails(QuerySnapshot snapshot) {
    List<DataRow> newList = snapshot.docs.map((DocumentSnapshot document) {
      if (document != null) {
        return DataRow(
          cells: [
            DataCell(
              Container(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Row(
                    children: [
                      Text(
                        'Name: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          document['productName'],
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Text(
                        'SKU: ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        document['sku'],
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            DataCell(
              Container(
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    children: [
                      Image.network(
                        document['productImage'],
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // DataCell(
            //   Container(
            //     child: Text((document['productImage'])),
            //   ),
            // ),
            DataCell(
              popUpButton(document.data()),
            ),
          ],
        );
      }
    }).toList();

    return newList;
  }

  Widget popUpButton(data, {BuildContext context}) {
    FirebaseServices _services = FirebaseServices();

    return PopupMenuButton<String>(
      onSelected: (String value) {
        print(value);
        if (value == 'Unpublish') {
          _services.unPublishProduct(
            id: data['productId'],
          );
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Unpublish',
          child: ListTile(
            leading: Icon(Icons.check),
            title: Text('Unpublish'),
          ),
        ),
        const PopupMenuItem<String>(
          value: 'Preview',
          child: ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('Preview'),
          ),
        ),
      ],
    );
  }
}
