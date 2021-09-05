import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp/Constants.dart';
import 'package:vendorapp/Provider/AuthProvider.dart';
import 'package:vendorapp/Screens/HomeScreen.dart';
import 'package:vendorapp/Screens/RegisterScreen.dart';
import 'package:vendorapp/Screens/ResetPasswordScreen.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();
  var _passwordTextController = TextEditingController();

  String email;
  String password;
  Icon icon;
  bool _isVisible = false;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(
                left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
            child: Center(
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Lottie.asset('assets/PlantAnimation2.json',
                              height: 250),
                          // SizedBox(height: 10),
                          Text(
                            'LOGIN',
                            style: TextStyle(
                              fontFamily: 'Anton',
                              fontSize: 30,
                              color: greenColor,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'can\'t be empty';
                          }
                          if (value.contains(' ')) {
                            return 'Should not contain space';
                          }
                          final bool _isValid = EmailValidator.validate(
                              _emailTextController.text);
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
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          focusColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
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
                        maxLength: 15,
                        obscureText: _isVisible == false ? true : false,
                        controller: _passwordTextController,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(),
                          contentPadding: EdgeInsets.zero,
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.vpn_key_outlined),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isVisible = !_isVisible;
                              });
                            },
                            icon: _isVisible
                                ? Icon(Icons.visibility_off_outlined)
                                : Icon(Icons.visibility_outlined),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).primaryColor,
                              width: 2,
                            ),
                          ),
                          focusColor: Theme.of(context).primaryColor,
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, ResetPasswordScreen.id);
                            },
                            child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  _authData
                                      .loginVendor(email, password)
                                      .then((credential) {
                                    if (credential != null) {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      Navigator.pushReplacementNamed(
                                          context, HomeScreen.id);
                                    } else {
                                      setState(() {
                                        _isLoading = false;
                                      });

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(_authData.error),
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                              child: _isLoading
                                  ? LinearProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                      backgroundColor: Colors.transparent,
                                    )
                                  : Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
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
                              Navigator.pushNamed(context, RegisterScreen.id);
                            },
                            child: RichText(
                              text: TextSpan(
                                text: '',
                                children: [
                                  TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Register',
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
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
