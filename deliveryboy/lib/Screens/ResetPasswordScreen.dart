import 'package:deliveryboy/Providers/AuthProvider.dart';
import 'package:deliveryboy/Screens/LoginScreen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String id = 'resetPassword-screen';

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  var _emailTextController = TextEditingController();

  String email;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 40.0, right: 40.0, top: 20.0, bottom: 20.0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/ForgotPassword.png', height: 250),
                SizedBox(height: 20),
                RichText(
                  text: TextSpan(
                    text: '',
                    children: [
                      TextSpan(
                        text: 'Forgot Password  ',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            'Don\'t worry, provide us your registered Email, we will send you an email to reset your password',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'can\'t be empty';
                    }
                    if (value.contains(' ')) {
                      return 'Should not contain space';
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
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            setState(() {
                              _isLoading = true;
                            });
                            _authData.resetPassword(email);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Check your Email ${_emailTextController.text} for reset link.'),
                              ),
                            );
                          }
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.id);
                        },
                        child: _isLoading
                            ? LinearProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                                backgroundColor: Colors.transparent,
                              )
                            : Text(
                                'Reset Password',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Theme.of(context).primaryColor),
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
    );
  }
}
