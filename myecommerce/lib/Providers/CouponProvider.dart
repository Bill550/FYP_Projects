import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

class CouponProvider with ChangeNotifier {
  // User user = FirebaseAuth.instance.currentUser;
  bool expired;
  DocumentSnapshot document;
  int discountRate = 0;

  getCouponData(title, sellerId) async {
    DocumentSnapshot document =
        await FirebaseFirestore.instance.collection('coupons').doc(title).get();

    if (document.exists) {
      this.document = document;
      notifyListeners();
      if (document['sellerId'] == sellerId) {
        checkExpiry(document);
      }
    } else {
      this.document = null;
      notifyListeners();
    }
  }

  checkExpiry(DocumentSnapshot document) {
    DateTime date = document['expiry'].toDate();
    var dateDiff = date.difference(DateTime.now()).inDays;
    if (dateDiff < 0) {
      //Coupon Expired
      this.expired = true;
      notifyListeners();
    } else {
      this.document = document;
      this.expired = false;
      this.discountRate = document['discountRate'];
      notifyListeners();
    }
  }
}
