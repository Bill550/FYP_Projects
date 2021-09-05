import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp/Constants.dart';
import 'package:vendorapp/Provider/AuthProvider.dart';
import 'package:vendorapp/Screens/HomeScreen.dart';
import 'package:vendorapp/Screens/LoginScreen.dart';

class RegisterForm extends StatefulWidget {
  static const String id = 'register-screen';

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _shopTextController = TextEditingController();
  var _dialogTextController = TextEditingController();
  var _passwordTextController = TextEditingController();
  var _addressTextController = TextEditingController();
  String email;
  String password;
  String mobile;
  String shopName;
  bool _isloading = false;

  Future<String> uploadFile(filePath) async {
    //need file to upload, we alreday have in provider
    File file = File(filePath);

    FirebaseStorage _storage = FirebaseStorage.instance;

    try {
      await _storage
          .ref('uploads/ShopProfilePic/${_shopTextController.text}')
          .putFile(file);
    } on FirebaseException catch (e) {
      // e.g, e.code == 'canceled'
      print(e.code);
    }

    //now after upload we need file url to save in DB
    String downloadURL = await _storage
        .ref('uploads/ShopProfilePic/${_shopTextController.text}')
        .getDownloadURL();

    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scaffoldMessage(message) {
      return ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }

    return _isloading
        ? CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
          )
        : Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,

                    // controller: _shopTextController,
                    // maxLength: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'can\'t be empty';
                      }
                      if (value.contains(' ')) {
                        return 'Should not contain space';
                      }
                      if (value.length < 3) {
                        return 'Should be at least 3 characaters';
                      }
                      if (value.length > 15) {
                        return 'Should be less than 15 characaters';
                      }
                      setState(() {
                        _shopTextController.text = value;
                      });
                      setState(() {
                        shopName = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.add_business),
                      labelText: 'Business Name',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                //////////////////////////////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,

                    // controller: _mobileTextController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'can\'t be empty';
                      }
                      if (value.contains(' ')) {
                        return 'Should not contain space';
                      }
                      if (value.length > 10 && value.length < 10) {
                        return 'Incorrect Number';
                      }
                      setState(() {
                        mobile = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone_android),
                      prefixText: '+92',
                      labelText: 'Mobile Number',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                //////////////////////////////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    // autovalidateMode: AutovalidateMode.always,
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'can\'t be empty';
                      }
                      final bool _isValid =
                          EmailValidator.validate(_emailTextController.text);
                      if (!_isValid) {
                        return "Invalid email address";
                      }
                      setState(() {
                        email = value;
                      });

                      return null;
                    },
                    controller: _emailTextController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: 'Email',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                //////////////////////////////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _passwordTextController,
                    obscureText: true,
                    maxLength: 15,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'can\'t be empty';
                      }
                      if (value.contains(' ')) {
                        return 'Should not contain space';
                      }
                      if (value.length < 6) {
                        return 'Should be at least 6 characaters';
                      }
                      if (value.length > 15) {
                        return 'Should be less than 15 characaters';
                      }
                      setState(() {
                        password = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key_outlined),
                      labelText: 'Password',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                //////////////////////////////////////////////////////////////////////////////////////////////////////////
                // Padding(
                //   padding: const EdgeInsets.all(3.0),
                //   child: TextFormField(
                //     controller: _cPasswordTextController,
                //     maxLength: 15,
                //     obscureText: true,
                //     keyboardType: TextInputType.number,
                //     validator: (value) {
                //       if (value == null || value.isEmpty) {
                //         return 'Enter Confirm Password';
                //       } else if (value.length < 6) {
                //         return 'Minimum 6 Characters';
                //       } else if (_passwordTextController.text !=
                //           _cPasswordTextController) {
                //         return 'Password doesn\'t match';
                //       }
                //       return null;
                //     },
                //     decoration: InputDecoration(
                //       prefixIcon: Icon(Icons.vpn_key_outlined),
                //       labelText: 'Confirm Password',
                //       contentPadding: EdgeInsets.zero,
                //       enabledBorder: OutlineInputBorder(),
                //       focusedBorder: OutlineInputBorder(
                //         borderSide: BorderSide(
                //           width: 2,
                //           color: Theme.of(context).primaryColor,
                //         ),
                //       ),
                //       focusColor: Theme.of(context).primaryColor,
                //     ),
                //   ),
                // ),
                // //////////////////////////////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _addressTextController,
                    maxLines: 5,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please Press Navigation Button';
                      }
                      if (_authData.shopLatitude == null) {
                        return 'Please Press Navigation Button';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.contact_mail_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(Icons.location_searching),
                        onPressed: () {
                          _addressTextController.text =
                              'Locating... \n Please wait...';
                          _authData.getCurrentAddress().then((address) {
                            if (address != null) {
                              setState(() {
                                _addressTextController.text =
                                    '${_authData.placeName}\n${_authData.shopAddress}';
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text('Can\'t get Location. Try again'),
                                ),
                              );
                            }
                          });
                        },
                      ),
                      labelText: 'Shop Address',
                      // contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                //////////////////////////////////////////////////////////////////////////////////////////////////////////
                Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: TextFormField(
                    onChanged: (value) {
                      _dialogTextController.text = value;
                    },
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.comment),
                      labelText: 'Shop Dialog',
                      contentPadding: EdgeInsets.zero,
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      focusColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                //////////////////////////////////////////////////////////////////////////////////////////////////////////
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (_authData.isPicAvil == true) {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                _isloading = true;
                              });
                              _authData
                                  .registerVendor(email, password)
                                  .then((credential) {
                                if (credential.user.uid != null) {
                                  //Vendor Registered
                                  //now upload pic to fire storage
                                  uploadFile(_authData.image.path).then((url) {
                                    if (url != null) {
                                      //now save Vendor Details in DB
                                      _authData.saveVendorDataToDB(
                                        url: url,
                                        mobile: mobile,
                                        shopName: shopName,
                                        dialog: _dialogTextController.text,
                                      );

                                      setState(() {
                                        _isloading = false;
                                      });
                                      Navigator.pushReplacementNamed(
                                          context, HomeScreen.id);
                                    } else {
                                      scaffoldMessage(
                                          'Failed to upload Profile Picture');
                                    }
                                  });
                                } else {
                                  //Register Failed
                                  scaffoldMessage(_authData.error);
                                }
                              });
                            }
                          } else {
                            scaffoldMessage(
                                'Shop Profile Picture need to be added');
                          }
                        },
                        child: Text(
                          'Register',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      child: RichText(
                        text: TextSpan(
                          text: '',
                          children: [
                            TextSpan(
                              text: 'Already have an account? ',
                              style: TextStyle(
                                color: blackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
  }
}
