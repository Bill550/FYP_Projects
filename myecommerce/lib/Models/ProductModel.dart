import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String productName, category, image, weight, brand, shopName;
  final num price, comparedPrice;
  final DocumentSnapshot document;

  ProductModel({
    this.productName,
    this.comparedPrice,
    this.category,
    this.image,
    this.weight,
    this.brand,
    this.price,
    this.shopName,
    this.document,
  });
}
