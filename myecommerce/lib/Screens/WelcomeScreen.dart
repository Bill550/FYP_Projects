import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myecommerce/Constants.dart';
import 'package:myecommerce/Providers/AuthProvider.dart';
import 'package:myecommerce/Providers/LocationProvider.dart';
import 'package:myecommerce/Screens/OnBoardScreen.dart';
import 'package:provider/provider.dart';
import 'package:myecommerce/Screens/MapScreen.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'wlcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    bool _isvalidMobileNumber = false;
    var _mobileNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, StateSetter myState) {
            return Container(
              // height: MediaQuery.of(context).size.height / 2,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                        visible: auth.error == 'Invalid OTP' ? true : false,
                        child: Container(
                          child: Column(
                            children: [
                              Text(
                                auth.error,
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                              SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: blackColor,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Enter your Phone Number to process',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      // SizedBox(height: 10),
                      //TODO: Validation
                      TextField(
                        controller: _mobileNumberController,
                        decoration: InputDecoration(
                          prefixText: '+92',
                          labelText: '10 Digit mobile number',
                        ),
                        keyboardType: TextInputType.phone,
                        autofocus: true,
                        maxLength: 10,
                        onChanged: (value) {
                          if (value.length == 10) {
                            myState(() {
                              _isvalidMobileNumber = true;
                            });
                          } else {
                            myState(() {
                              _isvalidMobileNumber = false;
                            });
                          }
                        },
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: AbsorbPointer(
                              absorbing: _isvalidMobileNumber ? false : true,
                              child: TextButton(
                                onPressed: () {
                                  myState(() {
                                    auth.loading = true;
                                  });
                                  String number =
                                      '+92${_mobileNumberController.text}';
                                  auth
                                      .verifyMobile(
                                    context: context,
                                    number: number,
                                  )
                                      .then((value) {
                                    _mobileNumberController.clear();
                                  });
                                },
                                child: auth.loading
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
                                        _isvalidMobileNumber
                                            ? 'CONTINUE'
                                            : 'ENTER MOBILE NUMBER',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                style: ButtonStyle(
                                  backgroundColor: _isvalidMobileNumber
                                      ? MaterialStateProperty.all<Color>(
                                          Theme.of(context).primaryColor)
                                      : MaterialStateProperty.all<Color>(
                                          Colors.grey),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _mobileNumberController.clear();
        });
      });
    }

    final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(
          children: [
            // Positioned(
            //   right: 0.0,
            //   top: 10.0,
            //   child: TextButton(
            //     onPressed: () {},
            //     child: Text(
            //       'SKIP',
            //       style: TextStyle(color: Theme.of(context).primaryColor),
            //     ),
            //   ),
            // ),
            Column(
              children: [
                Expanded(child: OnBoardScreen()),
                Text(
                  'Ready to order from shop?',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () async {
                    setState(() {
                      locationData.loading = true;
                    });

                    await locationData.getCurrentPosition();
                    if (locationData.permissionAllowed == true) {
                      locationData.getCurrentPosition().then((value) {
                        Navigator.pushReplacementNamed(context, MapScreen.id);
                        setState(() {
                          locationData.loading = false;
                        });
                      });
                    } else {
                      print('Permission not allowed');
                      setState(() {
                        locationData.loading = false;
                      });
                    }
                  },
                  child: locationData.loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          'SET DELIVERY LOCATION',
                          style: TextStyle(color: Colors.white),
                        ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                ),
                // SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    setState(() {
                      auth.screen = 'Login';
                    });
                    showBottomSheet(context);
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Already a Customer? ',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
