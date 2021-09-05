import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myecommerce/Services/UserServices.dart';

class ProfileUpdateScreen extends StatefulWidget {
  static const String id = 'profileUpdate-screen';

  @override
  _ProfileUpdateScreenState createState() => _ProfileUpdateScreenState();
}

class _ProfileUpdateScreenState extends State<ProfileUpdateScreen> {
  User user = FirebaseAuth.instance.currentUser;

  UserServices _user = UserServices();

  final _formKey = GlobalKey<FormState>();

  var _firstName = TextEditingController();
  var _lastName = TextEditingController();
  var _mobile = TextEditingController();
  var _email = TextEditingController();

  updateProfile() {
    return FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'firstName': _firstName.text,
      'lastName': _lastName.text,
      'email': _email.text,
    });
  }

  @override
  void initState() {
    _user.getUserByID(user.uid).then((value) {
      if (mounted) {
        setState(() {
          _firstName.text = value['firstName'];
          _lastName.text = value['lastName'];
          _mobile.text = value['number'];
          _email.text = value['email'];
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Update Profile',
          style: TextStyle(color: Colors.white),
        ),
      ),
      bottomSheet: InkWell(
        onTap: () {
          if (_formKey.currentState.validate()) {
            EasyLoading.show(status: 'Updating Profile...');
            updateProfile().then((value) {
              EasyLoading.showSuccess('Updated Successfully');
              Navigator.pop(context);
            });
          }
        },
        child: Container(
          width: double.infinity,
          height: 56,
          color: Colors.blueGrey[900],
          child: Center(
            child: Text(
              'Update',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstName,
                      decoration: InputDecoration(
                        labelText: 'First Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.zero,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter First Name';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _lastName,
                      decoration: InputDecoration(
                        labelText: 'Last Name',
                        labelStyle: TextStyle(color: Colors.grey),
                        contentPadding: EdgeInsets.zero,
                      ),
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter Last Name';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _mobile,
                enabled: false,
                decoration: InputDecoration(
                  labelText: 'Mobile',
                  labelStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.grey),
                  contentPadding: EdgeInsets.zero,
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Email address';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
