import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseServices {
  User user = FirebaseAuth.instance.currentUser;

  CollectionReference category =
      FirebaseFirestore.instance.collection('Categories');

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');

  CollectionReference vendorBanner =
      FirebaseFirestore.instance.collection('vendorBanner');

  CollectionReference coupons =
      FirebaseFirestore.instance.collection('coupons');

  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');

  CollectionReference boys = FirebaseFirestore.instance.collection('boys');

  CollectionReference orders = FirebaseFirestore.instance.collection('orders');

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  ///
  ///Update Published And Unpublished
  ///

  Future<void> publishProduct({id}) {
    return products.doc(id).update({
      'published': true,
    });
  }

  Future<void> unPublishProduct({id}) {
    return products.doc(id).update({
      'published': false,
    });
  }

  ///
  ///delete Unpublished
  ///

  Future<void> deleteProduct({id}) {
    return products.doc(id).delete();
  }

  Future<void> saveBannerToDB(url) {
    return vendorBanner.add({
      'imageUrl': url,
      'sellerUid': user.uid,
    });
  }

  Future<void> deleteVendorBanner({id}) {
    return vendorBanner.doc(id).delete();
  }

  Future<void> saveCoupon({
    document,
    title,
    discountRate,
    expiry,
    details,
    active,
  }) {
    if (document == null) {
      return coupons.doc(title).set({
        'title': title,
        'discountRate': discountRate,
        'expiry': expiry,
        'details': details,
        'active': active,
        'sellerId': user.uid,
      });
    }
    return coupons.doc(title).update({
      'title': title,
      'discountRate': discountRate,
      'expiry': expiry,
      'details': details,
      'active': active,
      'sellerId': user.uid,
    });
  }

  Future<DocumentSnapshot> getshopDetails() async {
    DocumentSnapshot doc = await vendors.doc(user.uid).get();
    return doc;
  }

  Future<DocumentSnapshot> getCustomerDetails(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<void> selectBoy({orderId, location, name, phone, image, email}) {
    var result = orders.doc(orderId).update(
      {
        'deliveryBoy': {
          'location': location,
          'name': name,
          'phone': phone,
          'image': image,
          'email': email,
        },
      },
    );
    return result;
  }
}
