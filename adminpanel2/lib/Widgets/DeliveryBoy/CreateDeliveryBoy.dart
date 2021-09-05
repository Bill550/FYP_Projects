import 'package:adminpanel2/Services/Firebase_services.dart';
import 'package:adminpanel2/constants.dart';
import 'package:ars_dialog/ars_dialog.dart';
import 'package:flutter/material.dart';

class CreateNewBoyWidget extends StatefulWidget {
  @override
  _CreateNewBoyWidgetState createState() => _CreateNewBoyWidgetState();
}

class _CreateNewBoyWidgetState extends State<CreateNewBoyWidget> {
  FirebaseServices _services = FirebaseServices();

  bool _isVisible = false;

  var emailText = TextEditingController();
  var passwordText = TextEditingController();

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
      color: Colors.grey,
      width: MediaQuery.of(context).size.width,
      height: 80,
      child: Row(
        children: [
          Visibility(
            visible: _isVisible ? false : true,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Container(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _isVisible = true;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: 170,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Create new delivery boy',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Visibility(
            visible: _isVisible,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Container(
                  child: Row(
                    children: [
                      SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          //TODO: EMAIL VALIDATOR
                          controller: emailText,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Email ID',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      SizedBox(
                        width: 200,
                        height: 30,
                        child: TextField(
                          controller: passwordText,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                                width: 1,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            hintText: 'Password',
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.only(left: 20),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      InkWell(
                        onTap: () {
                          if (emailText.text.isEmpty) {
                            return _services.showMyDialog(
                              context: context,
                              title: 'Email ID',
                              message: 'Email ID not entered',
                            );
                          }
                          if (passwordText.text.isEmpty) {
                            return _services.showMyDialog(
                              context: context,
                              title: 'Password',
                              message: 'Password not entered',
                            );
                          }
                          if (passwordText.text.length < 6) {
                            return _services.showMyDialog(
                              context: context,
                              title: 'Password',
                              message: 'Password must be 6 characters',
                            );
                          }

                          progressDialog.show();

                          _services
                              .saveDeliveryBoys(
                            emailText.text,
                            passwordText.text,
                          )
                              .whenComplete(() {
                            emailText.clear();
                            passwordText.clear();
                            progressDialog.dismiss();
                            _services.showMyDialog(
                              context: context,
                              title: 'New Delivery Boy',
                              message: 'Added successfully',
                            );
                          });
                        },
                        child: Container(
                          height: 40,
                          width: 150,
                          child: Center(
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
