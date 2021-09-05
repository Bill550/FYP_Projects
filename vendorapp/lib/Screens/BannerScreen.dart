import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp/Provider/ProductProvider.dart';
import 'package:vendorapp/Services/Firebase_services.dart';
import 'package:vendorapp/Widgets/Bannercard.dart';

class BannerScreen extends StatefulWidget {
  static const String id = 'banner-screen';

  @override
  _BannerScreenState createState() => _BannerScreenState();
}

class _BannerScreenState extends State<BannerScreen> {
  FirebaseServices _services = FirebaseServices();

  var _imagePathTextController = TextEditingController();

  bool _isVisible = false;
  File _image;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          BannerCard(),
          Divider(thickness: 3),
          SizedBox(height: 20),
          Container(
            child: Center(
              child: Text(
                'ADD NEW BANNER',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.grey[200],
                      child: _image != null
                          ? Image.file(
                              _image,
                              fit: BoxFit.fill,
                            )
                          : Center(
                              child: Text('No imaage selected'),
                            ),
                    ),
                  ),
                  TextFormField(
                    enabled: false,
                    controller: _imagePathTextController,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  Visibility(
                    visible: _isVisible ? false : true,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: () {
                              setState(() {
                                _isVisible = true;
                              });
                            },
                            child: Text(
                              'Add new banner',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _isVisible,
                    child: Container(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    getBannerImage().then((value) {
                                      if (_image != null) {
                                        setState(() {
                                          _imagePathTextController.text =
                                              _image.path;
                                        });
                                      }
                                    });
                                  },
                                  child: Text(
                                    'Upload Image',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: AbsorbPointer(
                                  absorbing: _image != null ? false : true,
                                  child: TextButton(
                                    onPressed: () {
                                      EasyLoading.show(status: 'Saving...');
                                      uploadBannerImage(
                                              _image.path, _provider.shopName)
                                          .then((url) {
                                        if (url != null) {
                                          //save Banner url to firestore

                                          _services.saveBannerToDB(url);

                                          setState(() {
                                            _imagePathTextController.clear();
                                            _image = null;
                                          });

                                          EasyLoading.dismiss();

                                          _provider.alertDialog(
                                            context: context,
                                            title: 'Banner Upload',
                                            content:
                                                'Banner image uploaded successfully...',
                                          );
                                        } else {
                                          EasyLoading.dismiss();

                                          _provider.alertDialog(
                                            context: context,
                                            title: 'Banner Upload',
                                            content: 'Banner upload failed',
                                          );
                                        }
                                      });
                                    },
                                    child: Text(
                                      'Save',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ButtonStyle(
                                      backgroundColor: _image != null
                                          ? MaterialStateProperty.all<Color>(
                                              Theme.of(context).primaryColor)
                                          : MaterialStateProperty.all<Color>(
                                              Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _isVisible = false;
                                      _imagePathTextController.clear();
                                      _image = null;
                                    });
                                  },
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                      Color(0xff232931),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  ///
  ///
  ///Selecting Image from Device
  ///
  ///

  Future<File> getBannerImage() async {
    final picker = ImagePicker();

    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    } else {
      print('No image selected.');
    }
    return _image;
  }

  ///
  ///
  ///Uploading Image to firestorage
  ///
  ///

  Future<String> uploadBannerImage(filePath, shopName) async {
    //need file to upload, we alreday have in provider
    File file = File(filePath);
    var timeStamp = Timestamp.now().microsecondsSinceEpoch;

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage.ref('vendorBanner/$shopName/$timeStamp').putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }

    //now after upload we need file url to save in DB
    String downloadURL = await _storage
        .ref('vendorBanner/$shopName/$timeStamp')
        .getDownloadURL();

    return downloadURL;
  }
}
