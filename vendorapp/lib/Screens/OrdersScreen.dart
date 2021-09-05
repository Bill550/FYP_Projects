import 'package:chips_choice/chips_choice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp/Provider/OrderProvider.dart';
import 'package:vendorapp/Services/OrderServices.dart';
import 'package:vendorapp/Widgets/OrderSummeryCard.dart';

class OrdersScreen extends StatefulWidget {
  static const String id = 'orders-screen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrderServices _orderServices = OrderServices();
  User user = FirebaseAuth.instance.currentUser;

  int tag = 0;
  List<String> options = [
    'All Orders',
    'Ordered',
    'Accepted',
    'Picked Up',
    'On the way',
    'Delivered',
  ];

  @override
  Widget build(BuildContext context) {
    var _orderProvider = Provider.of<OrderProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Container(
            height: 40,
            width: MediaQuery.of(context).size.width,
            color: Theme.of(context).primaryColor,
            child: Center(
              child: Text(
                'My Orders',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
            height: 56,
            width: MediaQuery.of(context).size.width,
            child: ChipsChoice<int>.single(
              choiceStyle: C2ChoiceStyle(
                borderRadius: BorderRadius.all(
                  Radius.circular(3),
                ),
              ),
              value: tag,
              onChanged: (val) {
                if (val == 0) {
                  setState(() {
                    _orderProvider.status = null;
                  });
                }
                setState(() {
                  print(options[val]);
                  tag = val;
                  if (tag > 0) {
                    _orderProvider.filterOrder(options[val]);
                  }
                });
              },
              choiceItems: C2Choice.listFrom<int, String>(
                source: options,
                value: (i, v) => i,
                label: (i, v) => v,
              ),
            ),
          ),
          Container(
            child: StreamBuilder<QuerySnapshot>(
              stream: _orderServices.orders
                  .where('seller.sellerId', isEqualTo: user.uid)
                  .where(
                    'orderStatus',
                    isEqualTo: tag > 0 ? _orderProvider.status : null,
                  )
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                // print(user.uid);
                // print(snapshot.data.docs);

                // print(snapshot.data.docs);
                if (snapshot.hasError) {
                  return Text('Something went wrong');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.data.size == 0) {
                  //TODO: NO ORDER SCREEN
                  return Center(
                    child: Text(
                      tag > 0
                          ? 'No ${options[tag]} orders'
                          : 'No orders. From the users',
                    ),
                  );
                }

                return Expanded(
                  child: new ListView(
                    padding: EdgeInsets.zero,
                    children:
                        snapshot.data.docs.map((DocumentSnapshot document) {
                      return OrderSummeryCard(document);
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
