import 'package:deliveryboy/Providers/AuthProvider.dart';
import 'package:deliveryboy/Screens/HomeScreen.dart';
import 'package:deliveryboy/Screens/LoginScreen.dart';
import 'package:deliveryboy/Screens/RegisterScreen.dart';
import 'package:deliveryboy/Screens/ResetPasswordScreen.dart';
import 'package:deliveryboy/Screens/SplashScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:deliveryboy/Constants.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthProvider(),
        )
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Delivery App',
      theme: ThemeData(
        primaryColor: greenColor,
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        HomeScreen.id: (context) => HomeScreen(),
        ResetPasswordScreen.id: (context) => ResetPasswordScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),

        // SplashScreen.id: (context) => SplashScreen(),
        // SplashScreen.id: (context) => SplashScreen(),
        // SplashScreen.id: (context) => SplashScreen(),
        // SplashScreen.id: (context) => SplashScreen(),
      },
    );
  }
}
