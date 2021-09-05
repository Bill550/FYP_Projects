import 'dart:html';
import 'package:adminpanel2/Services/Firebase_services.dart';
import 'package:adminpanel2/constants.dart';
import 'package:ars_dialog/ars_dialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class BannerUploadWidget extends StatefulWidget {
  @override
  _BannerUploadWidgetState createState() => _BannerUploadWidgetState();
}

class _BannerUploadWidgetState extends State<BannerUploadWidget> {
  FirebaseServices _services = FirebaseServices();

  var _fileNameTextController = TextEditingController();

  bool _visible = false;

  bool _imageSelected = true;

  String _url;

  @override
  Widget build(BuildContext context) {
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

    return Container(
      color: darkGreyColor,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: [
            Visibility(
              visible: _visible,
              child: Container(
                child: Row(
                  children: [
                    AbsorbPointer(
                      absorbing: true,
                      child: SizedBox(
                        width: 300,
                        height: 30,
                        child: TextField(
                          controller: _fileNameTextController,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'No image selected',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    InkWell(
                      onTap: () {
                        uploadStorage();
                      },
                      child: Container(
                        height: 40,
                        width: 150,
                        child: Center(
                          child: Text(
                            'Upload Image',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        decoration: BoxDecoration(color: greenColor),
                      ),
                    ),
                    SizedBox(width: 10),
                    AbsorbPointer(
                      absorbing: _imageSelected,
                      child: InkWell(
                        onTap: () {
                          progressDialog.show();
                          _services.uploadBannerImageToDB(_url).then(
                            (downloadUrl) {
                              if (downloadUrl != null) {
                                progressDialog.dismiss();
                                _services.showMyDialog(
                                  title: 'New Banner Image',
                                  message: 'Save Banner Image successfully',
                                  context: context,
                                );
                              }
                            },
                          );
                          _fileNameTextController.clear();
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          child: Center(
                            child: Text(
                              'Save Image',
                              style: TextStyle(
                                color: _imageSelected
                                    ? darkGreyColor
                                    : Colors.white,
                              ),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: _imageSelected ? greyColor : greenColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: _visible ? false : true,
              child: InkWell(
                onTap: () {
                  setState(() {
                    _visible = true;
                  });
                },
                child: Container(
                  height: 40,
                  width: 150,
                  child: Center(
                    child: Text(
                      'Add new banner',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  decoration: BoxDecoration(color: greenColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void uploadImage({@required Function(File file) onSelected}) {
    //it will select image from PC
    InputElement uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }

  void uploadStorage() {
    //it will upload image on firebase Storage
    final dateTime = DateTime.now();
    final path = 'bannerImage/$dateTime';
    uploadImage(onSelected: (file) {
      if (file != null) {
        setState(() {
          _fileNameTextController.text = file.name;
          _imageSelected = false;
          _url = path;
        });
        fb
            .storage()
            .refFromURL('gs://ecommerce-b7b23.appspot.com')
            .child(path)
            .put(file);
      }
    });
  }
}
