import 'package:flutter/material.dart';
import 'package:myecommerce/Widgets/CategoriesWidget.dart';
import 'package:myecommerce/Widgets/Products/BestSellingProducts.dart';
import 'package:myecommerce/Widgets/Products/FeatureProducts.dart';
import 'package:myecommerce/Widgets/Products/RecentlyAddedProducts.dart';
import 'package:myecommerce/Widgets/VendorAppBar.dart';
import 'package:myecommerce/Widgets/VendorBanner.dart';

class VendorHomeScreen extends StatelessWidget {
  static const String id = 'vendorHome-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            VendorAppBar(),
          ];
        },
        body: ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            VendorBanner(),
            VendorCategories(),

            //Recently Add Products
            //Best Selling Products
            //Featured Products
            BestSellingProducts(),
            FeatureProducts(),
            RecentlyAddedProducts(),
          ],
        ),
      ),
    );
  }
}
