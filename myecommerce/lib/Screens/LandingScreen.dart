import 'package:flutter/material.dart';
import 'package:myecommerce/Providers/LocationProvider.dart';
import 'package:myecommerce/Screens/MapScreen.dart';

class LandingScreen extends StatefulWidget {
  static const String id = 'landing-screen';

  @override
  _LandingScreenState createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LocationProvider _locationProvider = LocationProvider();
  // User user = FirebaseAuth.instance.currentUser;
  // String _location;
  // String _address;
  bool _isLoading = false;

  // @override
  // void initState() {
  //   UserServices _userSServices = UserServices();
  //   _userSServices.getUserByID(user.uid).then((result) async {
  //     if (result != null) {
  //       print('=> => => => => => => =>' + '${result['latitude']}');

  //       if (result['latitude'] != null) {
  //         getPrefs(result);
  //       } else {
  //         await _locationProvider.getCurrentPosition();
  //         if (_locationProvider.permissionAllowed == true) {
  //           print('Helllo');
  //           Navigator.pushNamed(context, MapScreen.id);
  //         } else {
  //           // _locationProvider.getCurrentPosition();

  //           print(' => => => => => => => =>  Permission not allowed');
  //         }
  //       }
  //     }
  //   });
  //   super.initState();
  // }

  // getPrefs(dbResult) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String location = prefs.getString('location');
  //   if (location == null) {
  //     prefs.setString('address', dbResult['address']);
  //     prefs.setString('location', dbResult['location']);
  //     if (mounted) {
  //       setState(() {
  //         _location = dbResult['location'];
  //         _address = dbResult['address'];
  //         isLoading = false;
  //       });
  //     }
  //     Navigator.pushReplacementNamed(context, HomeScreen.id);
  //   }
  //   Navigator.pushReplacementNamed(context, HomeScreen.id);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(_location == null ? '' : _location),
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     _address == null ? 'Delivery Address not set' : _address,
            //     style: TextStyle(fontWeight: FontWeight.bold),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Delivery Address not set',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Text(
            //     _address == null
            //         ? 'Please update your dilivery address to find nearest store for you'
            //         : _address,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(color: Colors.grey),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Please update your dilivery address to find nearest store for you',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ),
            SizedBox(height: 10),
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Container(
              width: 600,
              child: Image.asset(
                'assets/images/Location.png',
                fit: BoxFit.fill,
                // color: Colors.black12,
              ),
            ),
            // Visibility(
            //   visible: _location != null ? true : false,
            //   child: TextButton(
            //     onPressed: () {
            //       Navigator.pushReplacementNamed(context, HomeScreen.id);
            //     },
            //     child: Text('Confirm your location'),
            //     style: ButtonStyle(
            //       backgroundColor: MaterialStateProperty.all<Color>(
            //           Theme.of(context).primaryColor),
            //     ),
            //   ),
            // ),

            // TextButton(
            //   onPressed: () {
            //     _locationProvider.getCurrentPosition();
            //     if (_locationProvider.selectedAddress != null) {
            //       print(
            //           '=> => => => => => => => _locationProvider.selectedAddress ' +
            //               "${_locationProvider.selectedAddress}");

            //       Navigator.pushReplacementNamed(context, MapScreen.id);
            //     } else {
            //       print('Permission not allowed');
            //     }
            //   },
            //   child: Text(
            //     _location != null ? 'update Location' : 'Set your location',
            //     style: TextStyle(color: Colors.white),
            //   ),
            //   style: ButtonStyle(
            //     backgroundColor: MaterialStateProperty.all<Color>(
            //         Theme.of(context).primaryColor),
            //   ),
            // ),
            _isLoading
                ? CircularProgressIndicator()
                : TextButton(
                    onPressed: () async {
                      setState(() {
                        _isLoading = true;
                      });
                      await _locationProvider.getCurrentPosition();
                      if (_locationProvider.permissionAllowed == true) {
                        // print(
                        //     '=> => => => => => => => _locationProvider.permissionAllowed ' +
                        //         "${_locationProvider.permissionAllowed}");

                        Navigator.pushReplacementNamed(context, MapScreen.id);
                      } else {
                        Future.delayed(Duration(seconds: 4), () {
                          if (_locationProvider.permissionAllowed == false) {
                            print('Permission not allowed');
                            setState(() {
                              _isLoading = false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Please allow permission to find nearest by stores for you'),
                              ),
                            );
                          }
                        });
                      }
                    },
                    child: Text(
                      'Set your location',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
