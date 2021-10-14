import 'package:flutter/material.dart';
import 'package:myecommerce/Providers/StoreProvider.dart';
import 'package:myecommerce/Widgets/Products/ProductListWidget.dart';
import 'package:provider/provider.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'product-screen';

  @override
  Widget build(BuildContext context) {
    var _storeProvider = Provider.of<StoreProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              title: Text(
                _storeProvider.selectedProductCategory,
                style: TextStyle(color: Colors.white),
              ),
              expandedHeight: 110,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(top: 88),
                child: Container(
                  height: 56,
                  color: Colors.grey,
                  // child: ProductFilterWidget(),
                ),
              ),
            )
          ];
        },
        body: ListView(
          padding: EdgeInsets.zero,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            ProductListWidget(),
          ],
        ),
      ),
    );
  }
}
