import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myecommerce/Constants.dart';
import 'package:myecommerce/Providers/AuthProvider.dart';
import 'package:myecommerce/Providers/CartProvider.dart';
import 'package:myecommerce/Providers/CouponProvider.dart';
import 'package:myecommerce/Providers/LocationProvider.dart';
import 'package:myecommerce/Providers/OrderProvider.dart';
import 'package:myecommerce/Providers/StoreProvider.dart';
import 'package:myecommerce/Screens/BlogDetails.dart';
import 'package:myecommerce/Screens/CartScreen.dart';
import 'package:myecommerce/Screens/HomeScreen.dart';
import 'package:myecommerce/Screens/LandingScreen.dart';
import 'package:myecommerce/Screens/LogInScreen.dart';
import 'package:myecommerce/Screens/MainScreen.dart';
import 'package:myecommerce/Screens/BlogScreen.dart';
import 'package:myecommerce/Screens/MyOrderScreen.dart';
import 'package:myecommerce/Screens/Payments/CreateNewCardScreen.dart';
import 'package:myecommerce/Screens/Payments/CreditCardList.dart';
import 'package:myecommerce/Screens/Payments/Stripe/StripeHome.dart';
import 'package:myecommerce/Screens/Payments/Stripe/existing-cards.dart';
import 'package:myecommerce/Screens/ProductDetailsScreen.dart';
import 'package:myecommerce/Screens/ProductScreen.dart';
import 'package:myecommerce/Screens/ProfileScreen.dart';
import 'package:myecommerce/Screens/ProfileUpdateScreen.dart';
import 'package:myecommerce/Screens/SplashScreen.dart';
import 'package:myecommerce/Screens/VendorHomeScreen.dart';
import 'package:myecommerce/Screens/WelcomeScreen.dart';
import 'package:myecommerce/Screens/MapScreen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocationProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => StoreProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CouponProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
        )
      ],
      child: MyEcommerce(),
    ),
  );
}

class MyEcommerce extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: greenColor,
        fontFamily: 'Lato',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        HomeScreen.id: (context) => HomeScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        SplashScreen.id: (context) => SplashScreen(),
        MapScreen.id: (context) => MapScreen(),
        LogInScreen.id: (context) => LogInScreen(),
        LandingScreen.id: (context) => LandingScreen(),
        MainScreen.id: (context) => MainScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        ProfileUpdateScreen.id: (context) => ProfileUpdateScreen(),
        MyOrderScreen.id: (context) => MyOrderScreen(),
        BlogScreen.id: (context) => BlogScreen(),
        BlogDetails.id: (context) => BlogDetails(),
        VendorHomeScreen.id: (context) => VendorHomeScreen(),
        ProductScreen.id: (context) => ProductScreen(),
        ProductDetailsScreen.id: (context) => ProductDetailsScreen(),
        CartScreen.id: (context) => CartScreen(),
        ExistingCardsPage.id: (context) => ExistingCardsPage(),
        StripeHome.id: (context) => StripeHome(),
        CreditCardList.id: (context) => CreditCardList(),
        CreateNewCardScreen.id: (context) => CreateNewCardScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
        // HomeScreen.id: (context) => HomeScreen(),
      },
      builder: EasyLoading.init(),
    );
  }
}
