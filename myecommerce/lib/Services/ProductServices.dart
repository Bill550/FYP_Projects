import 'package:cloud_firestore/cloud_firestore.dart';

class ProductServices {
  CollectionReference category =
      FirebaseFirestore.instance.collection('Categories');

  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
}
