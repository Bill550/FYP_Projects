import 'dart:js';

import 'package:adminpanel2/constants.dart';
import 'package:ars_dialog/ars_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class FirebaseServices {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference banners = FirebaseFirestore.instance.collection('slider');
  CollectionReference vendors =
      FirebaseFirestore.instance.collection('vendors');

  CollectionReference category =
      FirebaseFirestore.instance.collection('Categories');

  CollectionReference blog = FirebaseFirestore.instance.collection('blog');

  CollectionReference boys = FirebaseFirestore.instance.collection('boys');

  FirebaseStorage storage = FirebaseStorage.instance;

  Future<DocumentSnapshot> getAdminCredentials(id) {
    var result = FirebaseFirestore.instance.collection('Admin').doc(id).get();

    return result;
  }

  //Banner

  Future<String> uploadBannerImageToDB(url) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      firestore.collection('slider').add({
        'image': downloadUrl,
      });
    }
    return downloadUrl;
  }

  deleteBannerImageFromDB(id) async {
    firestore.collection('slider').doc(id).delete();
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Vendor
  updateVendorStatus({id, status}) async {
    vendors.doc(id).update({
      'accVerified': status ? false : true,
    });
  }

  updateTopPickStatus({id, status}) async {
    vendors.doc(id).update({
      'isTopPicked': status ? false : true,
    });
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///Category
  Future<String> uploadCategoryImageToDB(url, catName) async {
    String downloadUrl = await storage.ref(url).getDownloadURL();
    if (downloadUrl != null) {
      category.doc(catName).set({
        'image': downloadUrl,
        'name': catName,
      });
    }
    return downloadUrl;
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////

  ///Blog
  Future<String> uploadBlogImageToDB(
      {url, blogDescription, blogTitle, blogDate}) async {
    print(url);
    print(blogDescription);
    print(blogTitle);
    print(blogDate);

    String downloadUrl = await storage.ref(url).getDownloadURL();
    print(downloadUrl);
    if (downloadUrl != null) {
      blog.doc(blogDate).set({
        'image': downloadUrl,
        'description': blogDescription,
        'title': blogTitle,
        'date': blogDate,
      });
    }
    return downloadUrl;
  }
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> confirmDeleteBlog({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                deleteBlogFromDB(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  deleteBlogFromDB(id) async {
    firestore.collection('blog').doc(id).delete();
  }
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<String> updateBlogDeatils(
      {blogID, url, blogDescription, blogTitle, blogDate}) async {
    print(blogID);
    print(url);
    print(blogDescription);
    print(blogTitle);
    print(blogDate);

    String downloadUrl = await storage.ref(url).getDownloadURL();
    print(downloadUrl);
    blog.doc(blogID).update({
      'image': downloadUrl,
      'date': blogDate,
      'description': blogDescription,
      'title': blogTitle,
    });
    return downloadUrl;
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> saveDeliveryBoys(email, password) async {
    boys.doc(email).set({
      'accVerified': false,
      'address': '',
      'boyName': '',
      'email': email,
      'imageUrl': '',
      'location': GeoPoint(0, 0),
      'mobile': '',
      'password': password,
      'uid': '',
    });
  }

  ///////////////////////////////////////////////////////////////////////////////////////////////////////////

  updateDeliveryBoysStatus({id, context, status}) {
    CustomProgressDialog progressDialog = CustomProgressDialog(
      context,
      blur: 10,
      backgroundColor: greenColor.withOpacity(.5),
      onDismiss: () {
        print("Do something onDismiss");
      },
    );
    progressDialog.setLoadingWidget(CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(greenColor),
    ));

    progressDialog.show();

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection('boys').doc(id);

    return FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }
      // Perform an update on the document
      transaction.update(documentReference, {'accVerified': status});
    }).then((value) {
      progressDialog.dismiss();
      showMyDialog(
        context: context,
        title: 'Delivery Boy Status',
        message:
            "Delivery boy approved status updated as ${status == true ? 'Approved' : 'Refuse'}",
      );
    }).catchError((error) {
      progressDialog.dismiss();
      showMyDialog(
        context: context,
        title: 'Delivery Boy Status',
        message: "Failed to update Delivery boy approved status: $error",
      );
    });
  }

  //////////////////////////////////////////////////////////////////////////////////////////////////////////

  Future<void> confirmDeleteDialog({title, message, context, id}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                deleteBannerImageFromDB(id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> showMyDialog({title, message, context}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(message),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
