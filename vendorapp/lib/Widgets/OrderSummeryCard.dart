import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vendorapp/Services/Firebase_services.dart';
import 'package:vendorapp/Services/OrderServices.dart';

class OrderSummeryCard extends StatefulWidget {
  final DocumentSnapshot document;

  OrderSummeryCard(this.document);

  @override
  _OrderSummeryCardState createState() => _OrderSummeryCardState();
}

class _OrderSummeryCardState extends State<OrderSummeryCard> {
  OrderServices _orderservices = OrderServices();
  FirebaseServices _services = FirebaseServices();

  DocumentSnapshot _customer;

  @override
  void initState() {
    _services.getCustomerDetails(widget.document['id']).then((value) {
      if (value != null) {
        setState(() {
          _customer = value;
        });
      } else {
        print('no data');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            ListTile(
              horizontalTitleGap: 0,
              leading: CircleAvatar(
                backgroundColor: Colors.white,
                radius: 14,
                child: _orderservices.statusIcon(widget.document),
              ),
              title: Text(
                widget.document['orderStatus'],
                style: TextStyle(
                  fontSize: 12,
                  color: _orderservices.statusColor(widget.document),
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                'On ${DateFormat.yMMMd().format(DateTime.parse(widget.document['timestamp']))}',
                style: TextStyle(fontSize: 12),
              ),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Payment Type: ${widget.document['cod'] == true ? 'Cash on delivery' : 'Paid online'}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Amount: PKR.${widget.document['total'].toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////
            //ned to bring customer Details
            _customer == null
                ? Container()
                : ListTile(
                    title: Row(
                      children: [
                        Text(
                          'Customer: ',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${_customer['firstName']} ${_customer['lastName']}',
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    subtitle: Text(
                      'Address: ${_customer['address']}',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                      maxLines: 1,
                    ),
                    trailing: InkWell(
                      onTap: () {
                        _orderservices.launchCall('tel:${_customer['number']}');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(4)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 2, bottom: 2),
                          child: Icon(
                            Icons.phone_in_talk_outlined,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

            ////////////////////////////////////////////////////////////////////////////////////////////////////////////
            ExpansionTile(
              title: Text(
                'Order details',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.black,
                ),
              ),
              subtitle: Text(
                'View order details',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: widget.document['products'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Image.network(
                          widget.document['products'][index]['productImage'],
                        ),
                      ),
                      title: Text(
                        widget.document['products'][index]['productName'],
                        style: TextStyle(fontSize: 12),
                      ),
                      subtitle: Text(
                        '${widget.document['products'][index]['qty']} X PKR.${widget.document['products'][index]['price'].toStringAsFixed(0)} = PKR.${widget.document['products'][index]['total'].toStringAsFixed(0)}',
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12,
                    right: 12,
                    top: 8,
                    bottom: 8,
                  ),
                  child: Card(
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'Seller: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                widget.document['seller']['shopName'],
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          if (int.parse(widget.document['discount']) > 0)
                            Container(
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Discount: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${widget.document['discount']}%',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Text(
                                        'Discount Code: ',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      Text(
                                        '${widget.document['discountCode']}%',
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Text(
                                'Delivery Fee: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                'PKR.${widget.document['deliveryFee'].toString()}',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              height: 3,
              color: Colors.grey,
            ),
            _orderservices.statusContainer(widget.document, context),
            Divider(
              height: 3,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
