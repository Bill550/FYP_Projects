import 'package:cloud_firestore/cloud_firestore.dart';

class BlogServices {
  CollectionReference blogs = FirebaseFirestore.instance.collection('blog');

  var doc;

  // getTopPickedStore() {
  //   return vendors
  //       .where('accVerified', isEqualTo: true)
  //       .where('isTopPicked', isEqualTo: true)
  //       .orderBy('shopName')
  //       .snapshots();
  // }

  getBlogList() {
    return blogs.orderBy('date', descending: true).snapshots();
  }

  getBlogPagination() {
    return blogs.orderBy('date', descending: true);
  }

  Future<DocumentSnapshot> getBlogDetails(blogId) async {
    DocumentSnapshot snapshot = await blogs.doc(blogId).get();
    return snapshot;
  }
}
