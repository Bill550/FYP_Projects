import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myecommerce/Constants.dart';
import 'package:myecommerce/Services/CartServices.dart';

class CounterForCard extends StatefulWidget {
  final DocumentSnapshot document;

  const CounterForCard({this.document});

  @override
  _CounterForCardState createState() => _CounterForCardState();
}

class _CounterForCardState extends State<CounterForCard> {
  User user = FirebaseAuth.instance.currentUser;
  CartService _cart = CartService();

  bool _updating = false;
  bool _exists = false;
  int _qty = 1;
  String _docId;

  getCartData() {
    FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('products')
        .where('productId', isEqualTo: widget.document['productId'])
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        querySnapshot.docs.forEach((doc) {
          if (doc['productId'] == widget.document['productId']) {
            if (mounted) {
              setState(() {
                _qty = doc['qty'];
                _exists = true;
                _docId = doc.id;
              });
            }
          }
        });
      } else {
        if (mounted) {
          setState(() {
            _exists = false;
          });
        }
      }
    });
  }

  @override
  void initState() {
    getCartData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _exists
        ? StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return Container(
                height: 28,
                decoration: BoxDecoration(
                  border: Border.all(color: darkGreyColor),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                        });
                        if (_qty == 1) {
                          _cart.removeFromCart(_docId).then((value) {
                            setState(() {
                              _updating = false;
                              _exists = false;
                            });
                            _cart.checkData();
                          });
                        }

                        if (_qty > 1) {
                          setState(() {
                            _qty--;
                          });
                          var total = _qty * widget.document['price'];

                          _cart
                              .updateCartQTY(_docId, _qty, total)
                              .then((value) {
                            _updating = false;
                          });
                        }
                      },
                      child: Container(
                        child: Icon(
                          _qty == 1 ? Icons.delete_outline : Icons.remove,
                          color: darkGreyColor,
                        ),
                      ),
                    ),
                    Container(
                      height: double.infinity,
                      width: 30,
                      color: darkGreyColor,
                      child: Center(
                        child: FittedBox(
                          child: _updating
                              ? Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : Text(
                                  _qty.toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _updating = true;
                          _qty++;
                        });
                        var total = _qty * widget.document['price'];

                        _cart.updateCartQTY(_docId, _qty, total).then((value) {
                          setState(() {
                            _updating = false;
                          });
                        });
                      },
                      child: Container(
                        child: Icon(Icons.add, color: darkGreyColor),
                      ),
                    ),
                  ],
                ),
              );
            })
        : StreamBuilder(
            stream: getCartData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return InkWell(
                onTap: () {
                  EasyLoading.show(status: 'Adding to cart');
                  _cart.checkSeller().then((shopName) {
                    print(shopName);
                    print(widget.document['seller']['shopName']);
                    if (shopName == widget.document['seller']['shopName']) {
                      //Product from same seller
                      setState(() {
                        _exists = true;
                      });

                      _cart.addToCart(widget.document).then((value) {
                        EasyLoading.showSuccess('Added to cart');
                      });

                      return;
                    }

                    // else {
                    //   // product from another Seller
                    //   print('Another Seller Exists');
                    //   EasyLoading.dismiss();
                    //   showDialog(shopName);
                    // }

                    if (shopName == null) {
                      setState(() {
                        _exists = true;
                      });

                      _cart.addToCart(widget.document).then((value) {
                        EasyLoading.showSuccess('Added to cart');
                      });
                      return;
                    }

                    if (shopName != widget.document['seller']['shopName']) {
                      print('Another Seller Exists');
                      EasyLoading.dismiss();
                      showDialog(shopName);
                    }
                  });
                },
                child: Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: darkGreyColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30, right: 30),
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
  }

  showDialog(shopName) {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text('Replace cart item?'),
            content: Text(
                'Your cart contains items from $shopName. Do you want to discard the selection and add item from ${widget.document['seller']['shopName']}'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'No',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  //Delete Existing Product From Cart
                  _cart.deleteCart().then((value) {
                    _cart.addToCart(widget.document).then((value) {
                      setState(() {
                        _exists = true;
                      });
                      Navigator.pop(context);
                    });
                  });
                },
                child: Text(
                  'Yes',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }
}
