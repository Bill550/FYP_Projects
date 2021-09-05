import 'package:adminpanel2/Services/Firebase_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubCategoryWidget extends StatefulWidget {
  final String categoryName;

  SubCategoryWidget(this.categoryName);
  @override
  _SubCategoryWidgetState createState() => _SubCategoryWidgetState();
}

class _SubCategoryWidgetState extends State<SubCategoryWidget> {
  FirebaseServices _services = FirebaseServices();
  var _subCategoryTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: 400,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: FutureBuilder<DocumentSnapshot>(
            future: _services.category.doc(widget.categoryName).get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text('No Subcategory Add'),
                  );
                }

                Map<String, dynamic> data = snapshot.data.data();
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('Main Category: '),
                              Text(
                                widget.categoryName,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          Divider(thickness: 3),
                        ],
                      ),
                    ),
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    ///
                    ///SubCategory List
                    ///

                    Container(
                      child: Expanded(
                        child: ListView.builder(
                          itemCount: data['subCat'] == null
                              ? 0
                              : data['subCat'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: CircleAvatar(
                                child: Text('${index + 1}'),
                              ),
                              title: Text(data['subCat'][index]['name']),
                            );
                          },
                        ),
                      ),
                    ),

                    ///
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    ///
                    Container(
                      child: Column(
                        children: [
                          Divider(thickness: 4),
                          Container(
                            color: Colors.grey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Add new Sub-Category',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                SizedBox(height: 6),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: SizedBox(
                                          height: 30,
                                          child: TextField(
                                            controller:
                                                _subCategoryTextController,
                                            decoration: InputDecoration(
                                              hintText: 'Sub-Category Name',
                                              filled: true,
                                              fillColor: Colors.white,
                                              border: OutlineInputBorder(),
                                              focusedBorder:
                                                  OutlineInputBorder(),
                                              contentPadding:
                                                  EdgeInsets.only(left: 10),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: InkWell(
                                          onTap: () {
                                            if (_subCategoryTextController
                                                .text.isEmpty) {
                                              return _services.showMyDialog(
                                                  context: context,
                                                  title: 'Add new Sub-Category',
                                                  message:
                                                      'Need to give Sub-Category name');
                                            }
                                            DocumentReference doc = _services
                                                .category
                                                .doc(widget.categoryName);
                                            doc.update({
                                              'subCat': FieldValue.arrayUnion([
                                                {
                                                  'name':
                                                      _subCategoryTextController
                                                          .text,
                                                },
                                              ]),
                                            });
                                            _subCategoryTextController.clear();
                                            Navigator.pop(context);
                                          },
                                          child: Container(
                                            height: 40,
                                            width: 120,
                                            child: Center(
                                              child: Text(
                                                'Save',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            decoration: BoxDecoration(
                                                color: Colors.black54,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
