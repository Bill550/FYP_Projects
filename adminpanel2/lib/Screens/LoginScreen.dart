import 'package:adminpanel2/Screens/HomeScreen.dart';
import 'package:adminpanel2/Services/Firebase_services.dart';
import 'package:adminpanel2/constants.dart';
import 'package:ars_dialog/ars_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  final _formKey = GlobalKey<FormState>();

  FirebaseServices _services = FirebaseServices();

  var _usernameTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  String validPassword(value) {
    if (value.isEmpty) {
      return 'Required';
    } else if (value.contains(' ')) {
      return 'Should not contain space';
    } else if (value.length < 6) {
      return 'Should be at least 6 characaters';
    } else if (value.length > 15) {
      return 'Should be less than 15 characaters';
    } else {
      return null;
    }
  }

  String validUsername(value) {
    if (value.isEmpty) {
      return 'Required';
    } else if (value.contains(' ')) {
      return 'Should not contain space';
    } else if (value.length < 3) {
      return 'Should be at least 3 characaters';
    } else if (value.length > 15) {
      return 'Should be less than 15 characaters';
    } else {
      return null;
    }
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

    _login({username, password}) async {
      progressDialog.show();
      _services.getAdminCredentials(username).then((value) async {
        if (value.exists) {
          // In Video he use this but isn't for me
          // if (value.data()['username'] == username) {
          //   if (value.data()['password'] == password) {
          //
          //   }
          // }

          if (value['username'] == username) {
            if (value.get('password') == password) {
              //if both is correct , Will Login
              try {
                UserCredential userCredential =
                    await FirebaseAuth.instance.signInAnonymously();
                if (userCredential != null) {
                  //if sign in success, will navigate to HomeScreen
                  print(userCredential.toString());
                  progressDialog.dismiss();
                  Navigator.pushReplacementNamed(context, HomeScreen.id);
                }
              } on FirebaseAuthException catch (e) {
                //if sign in failed
                progressDialog.dismiss();
                _services.showMyDialog(
                  context: context,
                  title: 'Login',
                  message: '${e.toString()}',
                );
              }

              return;
            }
            // if password is incorrect
            progressDialog.dismiss();
            _services.showMyDialog(
              context: context,
              title: 'Invalid Credential',
              message: 'Credential you have entered is invalid',
            );
            return;
          }
          //if username is incorrect
          progressDialog.dismiss();
          _services.showMyDialog(
            context: context,
            title: 'Invalid Credential',
            message: 'Credential you have entered is invalid',
          );
        }
        //if username is incorrect
        progressDialog.dismiss();
        _services.showMyDialog(
          context: context,
          title: 'Invalid Credential',
          message: 'Credential you have entered is invalid',
        );
      });
    }

    return Scaffold(
      body: FutureBuilder(
        // Initialize FlutterFire:
        future: _initialization,
        builder: (context, snapshot) {
          // Check for errors
          if (snapshot.hasError) {
            return Center(child: Text('SomethingWentWrong'));
          }

          // Once complete, show your application
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    greenColor,
                    Colors.white,
                  ],
                  stops: [1.5, 1.5],
                  begin: Alignment.topCenter,
                  end: Alignment(0.0, 0.0),
                ),
              ),
              child: Center(
                child: Container(
                  width: 350,
                  height: 500,
                  child: Card(
                    elevation: 6.0,
                    shape: Border.all(color: Colors.greenAccent, width: 2),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              child: Column(
                                children: [
                                  Lottie.asset(
                                    'assets/PlantAnimation.json',
                                    width: 200,
                                    height: 200,
                                  ),
                                  TextFormField(
                                    controller: _usernameTextController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return validUsername(value);
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Username',
                                      prefixIcon: Icon(Icons.person),
                                      hintText: 'Username',
                                      contentPadding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: greenColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                  TextFormField(
                                    controller: _passwordTextController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return validPassword(value);
                                      }

                                      return null;
                                    },
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      helperText: 'Minimum 6 characters',
                                      labelText: 'Password',
                                      prefixIcon: Icon(Icons.vpn_key_rounded),
                                      hintText: 'Password',
                                      contentPadding:
                                          EdgeInsets.only(left: 20, right: 20),
                                      border: OutlineInputBorder(),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: greenColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: InkWell(
                                    onTap: () async {
                                      if (_formKey.currentState.validate()) {
                                        _login(
                                          username:
                                              _usernameTextController.text,
                                          password:
                                              _passwordTextController.text,
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 80,
                                      child: Center(
                                          child: Text(
                                        'Login',
                                        style: TextStyle(color: Colors.white),
                                      )),
                                      decoration: BoxDecoration(
                                        color: greenColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          // Otherwise, show something whilst waiting for initialization to complete
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

// Future<void> _login() async {
//       print('validate');
//       _services.getAdminCredentials().then((value) {
//         value.docs.forEach((doc) async {
//           if (doc.get('username') == username) {
//             if (doc.get('password') == password) {
//               progressDialog.dismiss();
//               print('dismis');
//               UserCredential userCredential =
//                   await FirebaseAuth.instance.signInAnonymously();
//               print('signInAnonymously');
//               progressDialog.show(useSafeArea: false);

//               if (userCredential.user.uid != null) {
//                 Navigator.pushReplacement(context,
//                     MaterialPageRoute(builder: (context) => HomeScreen()));
//                 return;
//               } else {
//                 _showMyDialog(
//                   title: 'Login',
//                   message: 'Login Failed',
//                 );
//               }
//             } else {
//               print('Dismis');
//               progressDialog.dismiss();
//               _showMyDialog(
//                 title: 'Invalid Credential',
//                 message: 'The Credential you entered is not valid.',
//               );
//             }
//           } else {
//             progressDialog.dismiss();
//             _showMyDialog(
//               title: 'Invalid Credential',
//               message: 'The Credential you entered is not valid.',
//             );
//           }
//         });
//       });
//     }
