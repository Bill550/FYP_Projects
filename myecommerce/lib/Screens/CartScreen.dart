import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myecommerce/Constants.dart';
import 'package:myecommerce/Providers/AuthProvider.dart';
import 'package:myecommerce/Providers/CartProvider.dart';
import 'package:myecommerce/Providers/CouponProvider.dart';
import 'package:myecommerce/Providers/LocationProvider.dart';
import 'package:myecommerce/Providers/OrderProvider.dart';
import 'package:myecommerce/Screens/MapScreen.dart';
import 'package:myecommerce/Screens/Payments/Stripe/StripeHome.dart';
import 'package:myecommerce/Screens/ProfileScreen.dart';
import 'package:myecommerce/Services/CartServices.dart';
import 'package:myecommerce/Services/OrderServices.dart';
import 'package:myecommerce/Services/StoreServices.dart';
import 'package:myecommerce/Services/UserServices.dart';
import 'package:myecommerce/Widgets/Cart/CartList.dart';
import 'package:myecommerce/Widgets/Cart/CodToggle.dart';
import 'package:myecommerce/Widgets/Cart/CouponWidget.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartScreen extends StatefulWidget {
  static const String id = 'cart-screen';
  final DocumentSnapshot document;

  CartScreen({this.document});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  StoreServices _store = StoreServices();
  UserServices _userService = UserServices();
  OrderServices _orderServices = OrderServices();
  CartService _cartServices = CartService();

  User user = FirebaseAuth.instance.currentUser;

  DocumentSnapshot doc;

  var textstyle = TextStyle(color: greyColor);

  double discount = 0;
  int deliveryFees = 70; //TODO: Will work on Later

  String _location = '';
  String _address = '';

  bool _loading = false;
  bool _checkingUser = false;

  @override
  void initState() {
    getPrefs();
    _store.getShopDetails(widget.document['sellerUid']).then((value) {
      setState(() {
        doc = value;
      });
    });
    super.initState();
  }

  getPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String location = prefs.getString('location');
    String address = prefs.getString('address');

    setState(() {
      _location = location;
      _address = address;
    });
  }

  @override
  Widget build(BuildContext context) {
    var _cartProvider = Provider.of<CartProvider>(context);

    final locationData = Provider.of<LocationProvider>(context);

    var userDetails = Provider.of<AuthProvider>(context);

    var _coupon = Provider.of<CouponProvider>(context);

    userDetails.getUserDetails().then((value) {
      double subTotal = _cartProvider.subTotal;

      double discountRate = _coupon.discountRate / 100;

      if (mounted) {
        setState(() {
          discount = subTotal * discountRate;
        });
      }
    });

    var _payable = _cartProvider.subTotal + deliveryFees - discount;

    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: greyColor,
      bottomSheet: userDetails.snapshot == null
          ? Container()
          : Container(
              height: 140,
              color: blackColor,
              child: Column(
                children: [
                  Container(
                    height: 80,
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Deliver to this Address: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    _loading = true;
                                  });
                                  locationData
                                      .getCurrentPosition()
                                      .then((value) {
                                    setState(() {
                                      _loading = false;
                                    });
                                    if (value != null) {
                                      pushNewScreenWithRouteSettings(
                                        context,
                                        settings:
                                            RouteSettings(name: MapScreen.id),
                                        screen: MapScreen(),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    } else {
                                      setState(() {
                                        _loading = false;
                                      });
                                      print('Permission not allowed');
                                    }
                                  });
                                },
                                child: _loading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        'Change',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontSize: 12,
                                        ),
                                      ),
                              )
                            ],
                          ),
                          Text(
                            userDetails.snapshot['firstName'] != null
                                ? '${userDetails.snapshot['firstName']} ${userDetails.snapshot['lastName']} : \n$_location, $_address'
                                : '$_location, $_address',
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'PKR: ${_payable.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '(Icluding Texes)',
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                          ElevatedButton(
                            onPressed: () {
                              EasyLoading.show(status: 'Please wait...');

                              _userService.getUserByID(user.uid).then((value) {
                                if (value['firstName'] == null ||
                                    value['firstName'] == '') {
                                  EasyLoading.dismiss();
                                  //Need to confirm UserName before placing Orders
                                  pushNewScreenWithRouteSettings(
                                    context,
                                    settings:
                                        RouteSettings(name: ProfileScreen.id),
                                    screen: ProfileScreen(),
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                } else {
                                  EasyLoading.dismiss();

                                  // EasyLoading.show(status: 'Please wait...');
                                  //First check payment type
                                  if (_cartProvider.cod == false) {
                                    //Pay Online
                                    orderProvider.totalAmount(_payable);
                                    Navigator.pushNamed(context, StripeHome.id)
                                        .whenComplete(() {
                                      if (orderProvider.success == true) {
                                        _saveOrder(
                                          _cartProvider,
                                          _payable,
                                          _coupon,
                                          orderProvider,
                                        );
                                      }
                                    });
                                  } else {
                                    //Cash On delivery
                                    _saveOrder(
                                      _cartProvider,
                                      _payable,
                                      _coupon,
                                      orderProvider,
                                    );
                                  }
                                }
                              });
                            },
                            child: _checkingUser
                                ? Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  )
                                : Text(
                                    'CHECKOUT',
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 2,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.redAccent),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return [
            SliverAppBar(
              floating: true,
              snap: true,
              backgroundColor: Colors.white,
              elevation: 0.0,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.document['shopName'],
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '${_cartProvider.cartQty} ${_cartProvider.cartQty > 1 ? 'Items, ' : 'Item, '}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        'To pay: PKR ${_payable.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              // iconTheme: IconThemeData(color: Colors.),
            )
          ];
        },
        body: doc == null
            ? Center(child: CircularProgressIndicator())
            : _cartProvider.cartQty > 0
                ? SingleChildScrollView(
                    padding: EdgeInsets.only(bottom: 80),
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Column(
                        children: [
                          Container(
                            color: Colors.white,
                            child: Column(
                              children: [
                                ListTile(
                                  tileColor: Colors.white,
                                  leading: Container(
                                    height: 60,
                                    width: 60,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4),
                                      child: Image.network(
                                        doc['imageUrl'],
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  title: Text(doc['shopName']),
                                  subtitle: Text(
                                    doc['address'],
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                CodToggleSwitch(),
                                Divider(color: Colors.grey[300]),
                              ],
                            ),
                          ),

                          CartList(
                            document: widget.document,
                          ),
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          ///
                          ///
                          ///Coupon Details
                          CouponWidget(doc['uid']),

                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          //////////////////////////////////////////////////////////////////////////////////////////////////////////
                          ///
                          ///
                          ///Bill Details
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 4, right: 4, top: 4, bottom: 80),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Bill Details',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Basket value',
                                            style: textstyle,
                                          )),
                                          Text(
                                            'PKR. ${_cartProvider.subTotal.toStringAsFixed(0)}',
                                            style: textstyle,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Discount',
                                            style: textstyle,
                                          )),
                                          Text(
                                            'PKR. ${discount.toStringAsFixed(0)}',
                                            style: textstyle,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      if (discount > 0)
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                              'Delivery Fee',
                                              style: textstyle,
                                            )),
                                            Text(
                                              'PKR. $deliveryFees',
                                              style: textstyle,
                                            ),
                                          ],
                                        ),
                                      Divider(color: Colors.grey),
                                      Row(
                                        children: [
                                          Expanded(
                                              child: Text(
                                            'Total amount payable',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          )),
                                          Text(
                                            'PKR. ${_payable.toStringAsFixed(0)}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Theme.of(context)
                                              .primaryColor
                                              .withOpacity(.3),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  'Total saving ',
                                                  style: TextStyle(
                                                      color: Colors.green),
                                                ),
                                              ),
                                              Text(
                                                'PKR. ${_cartProvider.saving.toStringAsFixed(0)}',
                                                style: TextStyle(
                                                    color: Colors.green),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Center(
                    child: Text('Cart Empty, Continue Shopping '),
                  ),
      ),
    );
  }

  _saveOrder(
    CartProvider cartProvider,
    payable,
    CouponProvider coupon,
    OrderProvider orderProvider,
  ) {
    _orderServices.saveOrder({
      'products': cartProvider.cartList,
      'userId': user.uid,
      'deliveryFee': deliveryFees,
      'total': payable,
      'discount': discount.toStringAsFixed(0),
      'cod': cartProvider.cod,
      'discountCode': coupon.document == null ? null : coupon.document['title'],
      'seller': {
        'shopName': widget.document['shopName'],
        'sellerId': widget.document['sellerUid'],
      },
      'timestamp': DateTime.now().toString(),
      'orderStatus': 'Ordered',
      'deliveryBoy': {
        'name': '',
        'phone': '',
        'location': '',
      }
    }).then((value) {
      orderProvider.success = false;
      //After Submiting need to clear cart list
      _cartServices.deleteCart().then((value) {
        _cartServices.checkData().then((value) {
          EasyLoading.showSuccess('Your order is submitted');

          Navigator.pop(context);
        });
      });
    });
  }
}
