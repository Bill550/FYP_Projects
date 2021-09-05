// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:myecommerce/Providers/StoreProvider.dart';
// import 'package:myecommerce/Services/ProductServices.dart';
// import 'package:provider/provider.dart';

// class ProductFilterWidget extends StatefulWidget {
//   @override
//   _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
// }

// class _ProductFilterWidgetState extends State<ProductFilterWidget> {
//   List _subCatList = [];

//   ProductServices _services = ProductServices();

//   @override
//   void didChangeDependencies() {
//     var _storeProvider = Provider.of<StoreProvider>(context);

//     FirebaseFirestore.instance
//         .collection('products')
//         .where('category.mainCategory',
//             isEqualTo: _storeProvider.selectedProductCategory)
//         .get()
//         .then((QuerySnapshot querySnapshot) {
//       querySnapshot.docs.forEach((doc) {
//         setState(() {
//           _subCatList.add(doc['category']['subCategory']);
//         });
//       });
//     });

//     super.didChangeDependencies();
//   }

//   @override
//   Widget build(BuildContext context) {
//     var _storeData = Provider.of<StoreProvider>(context);

//     return FutureBuilder<DocumentSnapshot>(
//       future: _services.category.doc(_storeData.selectedProductCategory).get(),
//       builder:
//           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//         if (snapshot.hasError) {
//           return Text("Something went wrong");
//         }

//         if (snapshot.hasData && !snapshot.data.exists) {
//           return Text("Document does not exist");
//         }

//         if (!snapshot.hasData) {
//           return Container();
//         }

//         Map<String, dynamic> data =
//             snapshot.data.data() as Map<String, dynamic>;
//         return Container(
//           height: 50,
//           color: Colors.grey,
//           child: ListView(
//             scrollDirection: Axis.horizontal,
//             children: [
//               SizedBox(width: 10),
//               ActionChip(
//                 backgroundColor: Colors.white,
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 label: Text('All ${_storeData.selectedProductCategory}'),
//                 onPressed: () {
//                   _storeData.getSelectedSubCategory(null);
//                 },
//               ),
//               ListView.builder(
//                 shrinkWrap: true,
//                 scrollDirection: Axis.horizontal,
//                 physics: ScrollPhysics(),
//                 itemCount: data.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   // print('index: $index');
//                   // print("Data: $data");
//                   // print("CategoryList: $_subCatList");
//                   // print('${data['subCat'][index]['name']}');

//                   return Padding(
//                     padding: const EdgeInsets.only(left: 10),
//                     child: _subCatList.contains(data['subCat'][index]['name'])
//                         ? ActionChip(
//                             backgroundColor: Colors.white,
//                             elevation: 4,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             label: Text(data['subCat'][index]['name']),
//                             onPressed: () {
//                               _storeData.getSelectedSubCategory(
//                                   data['subCat'][index]['name']);
//                             },
//                           )
//                         : Container(),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
// }

// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:myecommerce/Providers/StoreProvider.dart';
// // import 'package:myecommerce/Services/ProductServices.dart';
// // import 'package:provider/provider.dart';

// // class ProductFilterWidget extends StatefulWidget {
// //   @override
// //   _ProductFilterWidgetState createState() => _ProductFilterWidgetState();
// // }

// // class _ProductFilterWidgetState extends State<ProductFilterWidget> {
// //   List _subCategory = [];

// //   ProductServices _services = ProductServices();

// //   @override
// //   void didChangeDependencies() {
// //     var _store = Provider.of<StoreProvider>(context);

// //     FirebaseFirestore.instance
// //         .collection('products')
// //         .where('category.mainCategory',
// //             isEqualTo: _store.selectedProductCategory)
// //         .get()
// //         .then((QuerySnapshot querySnapshot) {
// //       querySnapshot.docs.forEach((doc) {
// //         if (mounted) {
// //           setState(() {
// //             _subCategory.add(doc['category']['subCategory']);
// //           });
// //         }
// //       });
// //     });

// //     super.didChangeDependencies();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     var _storeData = Provider.of<StoreProvider>(context);

// //     return FutureBuilder(
// //       future: _services.category.doc(_storeData.selectedProductCategory).get(),
// //       builder:
// //           (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
// //         if (snapshot.hasError) {
// //           return Text("Something went wrong");
// //         }

// //         if (snapshot.hasData && !snapshot.data.exists) {
// //           return Text("Document does not exist");
// //         }

// //         if (_subCategory.length == 0) {
// //           return Center(child: CircularProgressIndicator());
// //         }

// //         if (!snapshot.hasData) {
// //           return Container();
// //         }

// //         Map<String, dynamic> data = snapshot.data.data();
// //         return Container(
// //           height: 50,
// //           color: Colors.grey,
// //           child: ListView(
// //             scrollDirection: Axis.horizontal,
// //             // physics: NeverScrollableScrollPhysics(),
// //             children: [
// //               SizedBox(width: 10),
// //               ActionChip(
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(4),
// //                 ),
// //                 elevation: 4,
// //                 label: Text('All ${_storeData.selectedProductCategory}'),
// //                 backgroundColor: Colors.white,
// //                 onPressed: () {
// //                   _storeData.getSelectedSubCategory(null);
// //                 },
// //               ),
// //               ListView.builder(
// //                 shrinkWrap: true,
// //                 scrollDirection: Axis.horizontal,
// //                 physics: ScrollPhysics(),
// //                 itemCount: data.length,
// //                 itemBuilder: (BuildContext context, int index) {
// //                   print('index: $index');
// //                   print("Data: $data");
// //                   print("CategoryList: $_subCategory");

// //                   return Padding(
// //                     padding: const EdgeInsets.only(left: 10),
// //                     child: _subCategory.contains(data['subCat'][index]['name'])
// //                         ? ActionChip(
// //                             shape: RoundedRectangleBorder(
// //                               borderRadius: BorderRadius.circular(4),
// //                             ),
// //                             elevation: 4,
// //                             label: Text(
// //                               data['subCat'][index]['name'],
// //                             ),
// //                             backgroundColor: Colors.white,
// //                             onPressed: () {
// //                               _storeData.getSelectedSubCategory(
// //                                   data['subCat'][index]['name']);
// //                             },
// //                           )
// //                         : Container(),
// //                   );
// //                 },
// //               ),
// //             ],
// //           ),
// //         );
// //       },
// //     );
// //   }
// // }
