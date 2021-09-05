import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:deliveryboy/Screens/HomeScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';

class AuthProvider extends ChangeNotifier {
  CollectionReference _boys = FirebaseFirestore.instance.collection('boys');

  File image = File('');
  String pickerError = '';
  String error = '';
  bool isPicAvil = false;

//BOY DATA
  double boyLatitude;
  double boyLongitude;
  String boyAddress;
  String placeName;

  String email;

  getEmail(email) {
    this.email = email;
    notifyListeners();
  }

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
      this.boyLatitude = _locationData.latitude;
      this.boyLongitude = _locationData.longitude;
      notifyListeners();
      final coordinates =
          new Coordinates(_locationData.latitude, _locationData.longitude);

      if (coordinates != null) {
        var _addresses =
            await Geocoder.local.findAddressesFromCoordinates(coordinates);
        var boyAddress = _addresses.first;

        this.boyAddress = boyAddress.addressLine;
        this.placeName = boyAddress.featureName;

        notifyListeners();
      }
    }

    return boyAddress;
  }

  //Register Boys using Email
  Future<UserCredential> registerBoys(email, password) async {
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

  //Save Boys Data to Firestore DB.
  Future<void> saveBoysDataToDB({
    String url,
    String boyName,
    String mobile,
    String password,
    context,
  }) async {
    User user = FirebaseAuth.instance.currentUser;
    _boys.doc(this.email).update({
      'uid': user.uid,
      'boyName': boyName,
      'password': password,
      'imageUrl': url,
      'mobile': mobile,
      'address': '${this.placeName} : ${this.boyAddress}',
      'location': GeoPoint(this.boyLatitude, this.boyLongitude),
      'accVerified': false, //keep initial value false,
    }).whenComplete(() {
      Navigator.pushReplacementNamed(context, HomeScreen.id);
    });
    return null;
  }

  //Login Boys using Email
  Future<UserCredential> loginBoys(email, password) async {
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
      this.error = e.toString();
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
      await _auth.sendPasswordResetEmail(email: email).whenComplete(() {
        // _boys.doc(email).update(data);
      });
    } on FirebaseAuthException catch (e) {
      this.error = e.code;
      notifyListeners();
    } catch (e) {
      this.error = e.toString();
      notifyListeners();

      print(e);
    }
    return userCredential;
  }
}
