import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {
  File image;
  String pickerError = '';
  String error = '';
  bool isPicAvil = false;

//SHOP DATA
  double shopLatitude;
  double shopLongitude;
  String shopAddress;
  String placeName;

  String email;

  Future<File> getImage() async {
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

  Future getCurrentAddress() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    if (_locationData != null) {
      this.shopLatitude = _locationData.latitude;
      this.shopLongitude = _locationData.longitude;
      notifyListeners();
      final coordinates =
          new Coordinates(_locationData.latitude, _locationData.longitude);

      if (coordinates != null) {
        var _addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var shopAddress = _addresses.first;

        this.shopAddress = shopAddress.addressLine;
        this.placeName = shopAddress.featureName;

        notifyListeners();
      }

      print("$placeName : $shopAddress");
    }

    return shopAddress;
  }

  //Register Vendor using Email
  Future<UserCredential> registerVendor(email, password) async {
    UserCredential userCredential;
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      this.email = email;
      notifyListeners();

      userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        this.error = 'The password provided is too weak.';
        notifyListeners();
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        this.error = 'The account already exists for that email.';
        notifyListeners();
        print('The account already exists for that email.');
      }
    } catch (e) {
      this.error = e.toString();
      notifyListeners();

      print(e);
    }
    return userCredential;
  }

  //Save Vendor Data to Firestore DB.
  Future<void> saveVendorDataToDB({
    String url,
    String shopName,
    String mobile,
    String dialog,
  }) async {
    User user = FirebaseAuth.instance.currentUser;
    DocumentReference _vendors =
        FirebaseFirestore.instance.collection('vendors').doc(user.uid);
    _vendors.set({
      'uid': user.uid,
      'shopName': shopName,
      'imageUrl': url,
      'mobile': '+92$mobile',
      'dialog': dialog,
      'email': this.email,
      'address': '${this.placeName} : ${this.shopAddress}',
      'location': GeoPoint(this.shopLatitude, this.shopLongitude),
      'accVerified': false, //keep initial value false,
      'shopOpen': true, //TODO: will use later
      'rating': 0.0, //TODO: will use later
      'totalRating': 0, //TODO: will use later
      'isTopPicked': false, //keep initial value false, //TODO: will use later
    });
    return null;
  }

  //Login Vendor using Email
  Future<UserCredential> loginVendor(email, password) async {
    UserCredential userCredential;
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      this.email = email;
      notifyListeners();

      userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();

      print(e);
    }
    return userCredential;
  }

  //Reset Password
  Future<UserCredential> resetPassword(email) async {
    this.email = email;
    notifyListeners();
    UserCredential userCredential;
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.code;
      notifyListeners();

      print(e);
    }
    return userCredential;
  }
}
