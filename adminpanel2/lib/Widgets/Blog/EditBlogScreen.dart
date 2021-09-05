import 'dart:html';

import 'package:adminpanel2/Screens/BlogScreen.dart';
import 'package:adminpanel2/Services/Firebase_services.dart';
import 'package:adminpanel2/constants.dart';
import 'package:ars_dialog/ars_dialog.dart';
import 'package:firebase/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase/firebase.dart' as fb;

class EditBlogScreen extends StatefulWidget {
  static const String id = 'edit-blog-screen';
  final String blogId;

  const EditBlogScreen({this.blogId});

  @override
  _EditBlogScreenState createState() => _EditBlogScreenState();
}

class _EditBlogScreenState extends State<EditBlogScreen> {
  FirebaseServices _services = FirebaseServices();
  var _fileNameTextController = TextEditingController();
  var _blogDescriptionTextController = TextEditingController();
  var _blogTitleTextController = TextEditingController();

  bool _imageSelected = false;
  String _url;
  String blogID;

  final _formKey = GlobalKey<FormState>();
  DocumentSnapshot doc;

  @override
  void initState() {
    super.initState();
    getBlogDetails();
  }

  Future<void> getBlogDetails() async {
    _services.blog.doc(widget.blogId).get().then((document) {
      if (document.exists) {
        setState(() {
          _blogTitleTextController.text = document['title'];
          _blogDescriptionTextController.text = document['description'];
          _fileNameTextController.text = _url = document['image'];
          blogID = document.id;
        });
      }
    });
  }

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

    return Dialog(
      child: Container(
        height: 500,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            color: blackColor,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 600,
                      height: MediaQuery.of(context).size.height - 30,
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: _blogDescriptionTextController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: blackColor,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: greyColor,
                              width: 1,
                            ),
                          ),
                          filled: true,
                          fillColor: blackColor,
                          hintText: 'No Blog Description given',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.only(left: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some Description';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      child: Column(
                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          SizedBox(
                            width: 600,
                            // height: 250,
                            child: TextFormField(
                              // maxLines: 10,
                              controller: _blogTitleTextController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                hintText: 'No Blog Title given',
                                // hintStyle: TextStyle(
                                //   height: 2,
                                // ),
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.only(left: 20),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 10),
                          AbsorbPointer(
                            absorbing: true,
                            child: SizedBox(
                              width: 500,
                              height: 50,
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
                          SizedBox(height: 20),
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
                          SizedBox(height: 10),
                          AbsorbPointer(
                            absorbing: _imageSelected,
                            child: InkWell(
                              onTap: () {
                                if (_formKey.currentState.validate()) {
                                  if (_blogDescriptionTextController.text.isEmpty ||
                                      _blogDescriptionTextController.text ==
                                          null ||
                                      _blogDescriptionTextController.text ==
                                          '') {
                                    _services.showMyDialog(
                                      context: context,
                                      title: 'Update Blog',
                                      message: 'Description not given',
                                    );
                                  }
                                  if (_blogTitleTextController.text.isEmpty) {
                                    _services.showMyDialog(
                                      context: context,
                                      title: 'Update Blog',
                                      message: 'Title not given',
                                    );
                                  }
                                  progressDialog.show();
                                  _services
                                      .updateBlogDeatils(
                                    blogID: blogID,
                                    url: _url,
                                    blogTitle: _blogTitleTextController.text,
                                    blogDescription:
                                        _blogDescriptionTextController.text,
                                    blogDate: DateTime.now().toString(),
                                  )
                                      .then(
                                    (downloadUrl) {
                                      if (downloadUrl != null) {
                                        progressDialog.dismiss();
                                        _services
                                            .showMyDialog(
                                          title: 'Update Blog',
                                          message: 'Update Blog successfully',
                                          context: context,
                                        )
                                            .then((value) {
                                          Navigator.pushNamed(
                                              context, BlogScreen.id);
                                        });
                                      }
                                    },
                                  );
                                  _blogDescriptionTextController.clear();
                                  _blogTitleTextController.clear();
                                  _fileNameTextController.clear();
                                }
                              },
                              child: Container(
                                height: 40,
                                width: 150,
                                child: Center(
                                  child: Text(
                                    'Update Blog',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  color: _imageSelected
                                      ? darkGreyColor
                                      : greenColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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
    final path = 'blogImage/$dateTime';
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
