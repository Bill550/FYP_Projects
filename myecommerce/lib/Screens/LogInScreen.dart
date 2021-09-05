import 'package:flutter/material.dart';
import 'package:myecommerce/Providers/AuthProvider.dart';
import 'package:myecommerce/Providers/LocationProvider.dart';
import 'package:provider/provider.dart';

class LogInScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  bool _isvalidMobileNumber = false;
  var _mobileNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final locationData = Provider.of<LocationProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: Container(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Enter your Phone Number to process',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
                        setState(() {
                          _isvalidMobileNumber = true;
                        });
                      } else {
                        setState(() {
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
                              // print('When Mobile No Enter longitude: ' +
                              //     '${locationData.longitude}');
                              setState(() {
                                auth.loading = true;
                                auth.screen = 'MapScreen';
                                auth.latitude = locationData.latitude;
                                auth.longitude = locationData.longitude;
                                auth.address =
                                    locationData.selectedAddress.addressLine;
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
                                setState(() {
                                  auth.loading = false;
                                });
                              });
                            },
                            child: auth.loading
                                ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
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
        ),
      ),
    );
  }
}
