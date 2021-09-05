import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myecommerce/Widgets/Products/AddToCartWidget.dart';
import 'package:myecommerce/Widgets/Products/SaveForLater.dart';

class BottomSheetContainer extends StatefulWidget {
  final DocumentSnapshot document;

  const BottomSheetContainer({this.document});

  @override
  _BottomSheetContainerState createState() => _BottomSheetContainerState();
}

class _BottomSheetContainerState extends State<BottomSheetContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Flexible(flex: 1, child: SaveForLater(document: widget.document)),
          Flexible(flex: 1, child: AddToCartWidget(document: widget.document)),
        ],
      ),
    );
  }
}
