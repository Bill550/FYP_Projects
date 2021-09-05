import 'package:cloud_firestore/cloud_firestore.dart';

class StoreServices {
  CollectionReference vendorBanner =
      FirebaseFirestore.instance.collection('vendorBanner');

  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');

  var doc;

  getTopPickedStore() {
    return vendors
        .where('accVerified', isEqualTo: true)
        .where('isTopPicked', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearByStore() {
    return vendors
        .where('accVerified', isEqualTo: true)
        .orderBy('shopName')
        .snapshots();
  }

  getNearByStorePagination() {
    return vendors.where('accVerified', isEqualTo: true).orderBy('shopName');
  }

  Future<DocumentSnapshot> getShopDetails(sellerUid) async {
    DocumentSnapshot snapshot = await vendors.doc(sellerUid).get();
    return snapshot;
  }
}
