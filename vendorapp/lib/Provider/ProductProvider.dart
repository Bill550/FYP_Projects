import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class ProductProvider with ChangeNotifier {
  String selectedCategory;
  String selectedSubCategory;
  String categoryImage;

  File image;
  String pickerError;
  String shopName;
  String productUrl;

  selectCategory(mainCategory, categoryImage) {
    this.selectedCategory = mainCategory;
    this.categoryImage = categoryImage;
    notifyListeners();
  }

  selectSubCategory(selected) {
    this.selectedSubCategory = selected;
    notifyListeners();
  }

  getShopName(shopName) {
    this.shopName = shopName;
    notifyListeners();
  }

  ///
  ///
  ///Remove all existing data before update next product
  ///
  ///

  resetProvider() {
    this.selectedCategory = null;
    this.selectedSubCategory = null;
    this.categoryImage = null;

    this.image = null;
    // this.pickerError = null;
    // this.shopName = null;
    this.productUrl = null;
    notifyListeners();
  }

  ///
  ///
  ///Selecting Image from Device
  ///
  ///

  Future<File> getProductImage() async {
    final picker = ImagePicker();

    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      this.image = File(pickedFile.path);
      notifyListeners();
    } else {
      this.pickerError = 'No image selected.';
      print('No image selected.');
      notifyListeners();
    }
    return this.image;
  }

  ///
  ///
  ///Uploading Image to firestorage
  ///
  ///

  Future<String> uploadProductImage(filePath, productName) async {
    //need file to upload, we alreday have in provider
    File file = File(filePath);
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref('productImage/${this.shopName}/$productName$timeStamp')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }

    //now after upload we need file url to save in DB
    String downloadURL = await _storage
        .ref('productImage/${this.shopName}/$productName$timeStamp')
        .getDownloadURL();

    this.productUrl = downloadURL;
    notifyListeners();

    return downloadURL;
  }

  ///
  ///
  ///Uploading Product data to fireStore
  ///
  ///

  Future<void> saveProductDataToDB(
      //need to bring these details from add product screen
      {
    productName,
    description,
    price,
    comparedPrice,
    sku,
    weight,
    tax,
    stockQty,
    lowStockQty,
    collection,
    brand,
    context,
  }) async {
    var timeStamp =
        DateTime.now().microsecondsSinceEpoch; //this will use as product ID

    User user = FirebaseAuth.instance.currentUser;

    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(timeStamp.toString()).set({
        'seller': {
          'shopName': this.shopName,
          'sellerUid': user.uid,
        },
        'productName': productName,
        'description': description,
        'price': price,
        'stockQty': stockQty,
        'lowStockQty': lowStockQty,
        'tax': tax,
        'weight': weight,
        'sku': sku,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'category': {
          'mainCategory': this.selectedCategory,
          'subCategory': this.selectedSubCategory,
          'categoryImage': this.categoryImage,
        },
        'published': false, //keep initial value false,
        'productId': timeStamp.toString(),
        'productImage': this.productUrl,
      });
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: 'Product details saved successfully ',
      );
    } catch (e) {
      this.alertDialog(
        context: context,
        title: 'ERROR',
        content: '${e.toString()}',
      );
    }
    return null;
  }

  ///
  ///
  ///Uploading Product data to fireStore
  ///
  ///

  Future<void> updateProductDataToDB(
      //need to bring these details from add product screen
      {
    productName,
    description,
    price,
    comparedPrice,
    collection,
    brand,
    sku,
    weight,
    tax,
    stockQty,
    lowStockQty,
    context,
    productId,
    image,
    category,
    subCategory,
    categoryImage,
  }) async {
    // var timeStamp =
    //     DateTime.now().microsecondsSinceEpoch; //this will use as product ID

    // User user = FirebaseAuth.instance.currentUser;

    CollectionReference _products =
        FirebaseFirestore.instance.collection('products');
    try {
      _products.doc(productId).update({
        // 'seller': {
        //   'shopName': this.shopName,
        //   'sellerUid': user.uid,
        // },
        'productName': productName,
        'description': description,
        'price': price,
        'stockQty': stockQty,
        'lowStockQty': lowStockQty,
        'tax': tax,
        'weight': weight,
        'sku': sku,
        'comparedPrice': comparedPrice,
        'collection': collection,
        'brand': brand,
        'category': {
          'mainCategory': category,
          'subCategory': subCategory,
          'categoryImage':
              this.categoryImage == null ? categoryImage : this.categoryImage,
        },
        // 'published': false, //keep initial value false,
        // 'productId': timeStamp.toString(),
        'productImage': this.productUrl == null ? image : this.productUrl,
      });
      this.alertDialog(
        context: context,
        title: 'SAVE DATA',
        content: 'Product details saved successfully ',
      );
      // Navigator.pop(context);
    } catch (e) {
      this.alertDialog(
        context: context,
        title: 'ERROR',
        content: '${e.toString()}',
      );
    }
    return null;
  }

  ///
  ///
  ///DialogBox
  ///
  ///

  alertDialog({context, title, content}) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            CupertinoDialogAction(
              child: Text('OK '),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
