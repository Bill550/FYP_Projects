import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:vendorapp/Services/Firebase_services.dart';

class AddEditCoupon extends StatefulWidget {
  static const String id = 'update-coupon';
  final DocumentSnapshot document;

  AddEditCoupon({this.document});

  @override
  _AddEditCouponState createState() => _AddEditCouponState();
}

class _AddEditCouponState extends State<AddEditCoupon> {
  final _formKey = GlobalKey<FormState>();

  FirebaseServices _services = FirebaseServices();

  DateTime _selectedDate = DateTime.now();

  var titleText = TextEditingController();
  var discountText = TextEditingController();
  var dateText = TextEditingController();
  var detailsText = TextEditingController();

  bool _active = false;

  _selectDate(context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2050),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        String formattedText = DateFormat('yyyy-MM-dd').format(_selectedDate);

        dateText.text = formattedText;
      });
    }
  }

  @override
  void initState() {
    if (widget.document != null) {
      setState(() {
        titleText.text = widget.document['title'];
        discountText.text = widget.document['discountRate'].toString();
        detailsText.text = widget.document['details'];
        dateText.text = widget.document['expiry'].toDate().toString();
        _active = widget.document['active'];
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Add / Edit Coupon',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: titleText,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Coupon title';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Coupon Title',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              TextFormField(
                controller: discountText,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Discount %';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Discount %',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              TextFormField(
                keyboardType: TextInputType.number,
                controller: dateText,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Apply Expiry Date';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Expiry Date',
                  labelStyle: TextStyle(color: Colors.grey),
                  suffixIcon: InkWell(
                    child: Icon(Icons.date_range_outlined),
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              TextFormField(
                controller: detailsText,
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Enter Coupon details';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: 'Coupon Details',
                  labelStyle: TextStyle(color: Colors.grey),
                ),
              ),
              ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              SwitchListTile(
                activeColor: Theme.of(context).primaryColor,
                contentPadding: EdgeInsets.zero,
                title: Text('Activate Coupon'),
                value: _active,
                onChanged: (bool newValue) {
                  setState(() {
                    _active = !_active;
                  });
                },
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          print('Validate');
                          EasyLoading.show(status: 'Please wait...');
                          _services
                              .saveCoupon(
                            document: widget.document,
                            title: titleText.text.toUpperCase(),
                            details: detailsText.text,
                            discountRate: int.parse(discountText.text),
                            expiry: _selectedDate,
                            active: _active,
                          )
                              .then((value) {
                            setState(() {
                              titleText.clear();
                              discountText.clear();
                              detailsText.clear();
                              _active = false;
                            });
                            EasyLoading.showSuccess(
                                'Saved coupon successfully');
                          });
                        }
                      },
                      child: Text(
                        'Submit',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
