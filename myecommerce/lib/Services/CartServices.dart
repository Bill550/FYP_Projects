import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartService {
  CollectionReference cart = FirebaseFirestore.instance.collection('cart');
  User user = FirebaseAuth.instance.currentUser;

  Future<void> addToCart(document) async {
    cart.doc(user.uid).set({
      'user': user.uid,
      'sellerUid': document['seller']['sellerUid'],
      'shopName': document['seller']['shopName'],
    });

    return cart.doc(user.uid).collection('products').add({
      'productId': document['productId'],
      'productName': document['productName'],
      'productImage': document['productImage'],
      'weight': document['weight'],
      'price': document['price'],
      'comparedPrice': document['comparedPrice'],
      'sku': document['sku'],
      'qty': 1,
      'total': document['price'],
    });
  }

  Future<void> updateCartQTY(docId, qty, total) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .doc(docId);

    return FirebaseFirestore.instance
        .runTransaction((transaction) async {
          DocumentSnapshot snapshot = await transaction.get(documentReference);

          if (!snapshot.exists) {
            throw Exception("Product does not exist in cart!");
          }

          transaction.update(documentReference, {'qty': qty, 'total': total});

          return qty;
        })
        .then((value) => print("Updated Cart"))
        .catchError((error) => print("Failed to update cart: $error"));
  }

  Future<void> removeFromCart(docId) async {
    cart.doc(user.uid).collection('products').doc(docId).delete();
  }

  Future<void> checkData() async {
    final snapshot = await cart.doc(user.uid).collection('products').get();
    if (snapshot.docs.length == 0) {
      cart.doc(user.uid).delete();
    }
  }

  Future<void> deleteCart() async {
    final result =
        await cart.doc(user.uid).collection('products').get().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.docs) {
        ds.reference.delete();
      }
    });
  }

  Future<String> checkSeller() async {
    final snapshot = await cart.doc(user.uid).get();
    return snapshot.exists ? snapshot['shopName'] : null;
  }
}
