import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp/Constants.dart';
import 'package:vendorapp/Provider/AuthProvider.dart';
import 'package:vendorapp/Provider/OrderProvider.dart';
import 'package:vendorapp/Provider/ProductProvider.dart';
import 'package:vendorapp/Screens/AddEditCouponScreen.dart';
import 'package:vendorapp/Screens/AddNewProductScreen.dart';
import 'package:vendorapp/Screens/BannerScreen.dart';
import 'package:vendorapp/Screens/DashboardScreen.dart';
import 'package:vendorapp/Screens/HomeScreen.dart';
import 'package:vendorapp/Screens/LogInScreen.dart';
import 'package:vendorapp/Screens/OrdersScreen.dart';
import 'package:vendorapp/Screens/ProductScreen.dart';
import 'package:vendorapp/Screens/RegisterScreen.dart';
import 'package:vendorapp/Screens/ResetPasswordScreen.dart';
import 'package:vendorapp/Screens/SplashScreen.dart';

void main() async {
  Provider.debugCheckInvalidValueType = null;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => AuthProvider(),
        ),
        Provider(
          create: (_) => ProductProvider(),
        ),
        Provider(
          create: (_) => OrderProvider(),
        ),
      ],
      child: VendorApp(),
    ),
  );
}

class VendorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: greenColor,
        accentColor: Colors.white,
        fontFamily: 'Lato',
      ),
      builder: EasyLoading.init(),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id: (context) => SplashScreen(),

        LoginScreen.id: (context) => LoginScreen(),
        RegisterScreen.id: (context) => RegisterScreen(),
        ResetPasswordScreen.id: (context) => ResetPasswordScreen(),

        HomeScreen.id: (context) => HomeScreen(),
        MainScreen.id: (context) => MainScreen(),

        AddNewProduct.id: (context) => AddNewProduct(),
        ProductScreen.id: (context) => ProductScreen(),

        BannerScreen.id: (context) => BannerScreen(),
        AddEditCoupon.id: (context) => AddEditCoupon(),
        OrdersScreen.id: (context) => OrdersScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
