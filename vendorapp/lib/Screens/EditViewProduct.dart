import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp/Provider/ProductProvider.dart';
import 'package:vendorapp/Services/Firebase_services.dart';
import 'package:vendorapp/Widgets/CategoryList.dart';

class EditViewProduct extends StatefulWidget {
  final String productId;

  EditViewProduct({this.productId});
  @override
  _EditViewProductState createState() => _EditViewProductState();
}

class _EditViewProductState extends State<EditViewProduct> {
  FirebaseServices _services = FirebaseServices();

  final _formKey = GlobalKey<FormState>();

  List<String> _collection = [
    'Featured products',
    'Best Selling',
    'Recently Added'
  ];
  String dropDownValue;

  var _brandText = TextEditingController();
  var _skuText = TextEditingController();
  var _productNameText = TextEditingController();
  var _weightText = TextEditingController();
  var _priceText = TextEditingController();
  var _comparedPriceText = TextEditingController();
  var _descriptionText = TextEditingController();
  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _stockTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _taxTextController = TextEditingController();

  double discount;
  String image;
  String categoryImage;
  File _image;
  bool _visible = false;
  bool _editing = true;

  DocumentSnapshot doc;

  @override
  void initState() {
    getProductDetails();
    super.initState();
  }

  Future<void> getProductDetails() async {
    _services.products
        .doc(widget.productId)
        .get()
        .then((DocumentSnapshot document) {
      if (document.exists) {
        setState(() {
          doc = document;
          _brandText.text = document['brand'];
          _skuText.text = document['sku'];
          _productNameText.text = document['productName'];
          _weightText.text = document['weight'];
          _priceText.text = document['price'].toString();
          _comparedPriceText.text = document['comparedPrice'].toString();

          var difference = int.parse(_comparedPriceText.text) -
              double.parse(_priceText.text);

          discount = (difference / int.parse(_comparedPriceText.text) * 100);

          image = document['productImage'];
          categoryImage = document['category']['categoryImage'];

          _descriptionText.text = document['description'];

          _categoryTextController.text = document['category']['mainCategory'];
          _subCategoryTextController.text = document['category']['subCategory'];

          dropDownValue = document['collection'];

          _stockTextController.text = document['stockQty'].toString();
          _lowStockTextController.text = document['lowStockQty'].toString();

          _taxTextController.text = document['tax'].toString();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _editing = false;
              });
            },
            child: Text(
              'Edit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        height: 60,
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  color: Color(0xff232931),
                  child: Center(
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: AbsorbPointer(
                absorbing: _editing,
                child: InkWell(
                  onTap: () {
                    if (_formKey.currentState.validate()) {
                      EasyLoading.show(status: 'Svaing...');
                      if (_image != null) {
                        _provider
                            .uploadProductImage(
                                _image.path, _productNameText.text)
                            .then((url) {
                          if (url != null) {
                            EasyLoading.dismiss();
                            _provider.updateProductDataToDB(
                              context: context,
                              productName: _productNameText.text,
                              weight: _weightText.text,
                              tax: double.parse(_taxTextController.text),
                              stockQty: int.parse(_stockTextController.text),
                              sku: _skuText.text,
                              price: double.parse(_priceText.text),
                              lowStockQty:
                                  int.parse(_lowStockTextController.text),
                              description: _descriptionText.text,
                              collection: dropDownValue,
                              brand: _brandText.text,
                              comparedPrice: int.parse(_comparedPriceText.text),
                              productId: widget.productId,
                              image: image,
                              category: _categoryTextController.text,
                              subCategory: _subCategoryTextController.text,
                              categoryImage: categoryImage,
                            );
                          }
                        });
                      } else {
                        _provider.updateProductDataToDB(
                          context: context,
                          productName: _productNameText.text,
                          weight: _weightText.text,
                          tax: double.parse(_taxTextController.text),
                          stockQty: int.parse(_stockTextController.text),
                          sku: _skuText.text,
                          price: double.parse(_priceText.text),
                          lowStockQty: int.parse(_lowStockTextController.text),
                          description: _descriptionText.text,
                          collection: dropDownValue,
                          brand: _brandText.text,
                          comparedPrice: int.parse(_comparedPriceText.text),
                          productId: widget.productId,
                          image: image,
                          category: _categoryTextController.text,
                          subCategory: _subCategoryTextController.text,
                          categoryImage: categoryImage,
                        );
                        EasyLoading.dismiss();
                      }
                      _provider.resetProvider();
                    }
                  },
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    child: Center(
                      child: Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: doc == null
          ? Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    AbsorbPointer(
                      absorbing: _editing,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'BRAND: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    height: 30,
                                    child: TextFormField(
                                      controller: _brandText,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.only(
                                            left: 10, right: 10),
                                        hintText: 'Brand',
                                        hintStyle: TextStyle(
                                          color: Colors.grey,
                                        ),
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .primaryColor
                                            .withOpacity(.1),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                // mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'SKU: ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                  Container(
                                    width: 80,
                                    child: TextFormField(
                                      controller: _skuText,
                                      style: TextStyle(fontSize: 12),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        contentPadding: EdgeInsets.zero,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20,
                            child: TextFormField(
                              controller: _productNameText,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                              ),
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                          SizedBox(
                            height: 30,
                            child: TextFormField(
                              controller: _weightText,
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.zero,
                                border: InputBorder.none,
                                prefixText: 'Weight: ',
                                prefixStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 0, right: 8),
                                child: Container(
                                  width: 80,
                                  child: TextFormField(
                                    controller: _priceText,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: 'PKR: ',
                                    ),
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8, right: 8),
                                child: Container(
                                  width: 80,
                                  child: TextFormField(
                                    controller: _comparedPriceText,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.zero,
                                      border: InputBorder.none,
                                      prefixText: 'PKR: ',
                                    ),
                                    style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(3),
                                  color: Colors.red,
                                ),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Text(
                                    '${discount.toStringAsFixed(0)}% OFF',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Inclusive of all taxes',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () {
                              _provider.getProductImage().then((image) {
                                setState(() {
                                  _image = image;
                                });
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: _image != null
                                  ? Image.file(
                                      _image,
                                      height: 300,
                                    )
                                  : Image.network(
                                      image,
                                      height: 300,
                                    ),
                            ),
                          ),
                          Text(
                            'About this product',
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8),
                            child: TextFormField(
                              controller: _descriptionText,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              style: TextStyle(color: Colors.grey),
                              decoration:
                                  InputDecoration(border: InputBorder.none),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 10),
                            child: Row(
                              children: [
                                Text(
                                  'Category',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: AbsorbPointer(
                                    absorbing:
                                        true, //this will stop user entering category name manually
                                    child: TextFormField(
                                      controller: _categoryTextController,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Select Category Name';
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Not Selcted',
                                        labelStyle:
                                            TextStyle(color: Colors.grey),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: _editing ? false : true,
                                  child: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CategoryList();
                                        },
                                      ).whenComplete(() {
                                        setState(() {
                                          _categoryTextController.text =
                                              _provider.selectedCategory;
                                          _visible = true;
                                        });
                                      });
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Visibility(
                            visible: _visible,
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 10, bottom: 20),
                              child: Row(
                                children: [
                                  Text(
                                    'Sub Category',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 16,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: AbsorbPointer(
                                      absorbing: true,
                                      child: TextFormField(
                                        controller: _subCategoryTextController,
                                        validator: (value) {
                                          if (value.isEmpty) {
                                            return 'Select Sub-Category Name';
                                          }
                                          return null;
                                        },
                                        decoration: InputDecoration(
                                          hintText: 'Not Selcted',
                                          labelStyle:
                                              TextStyle(color: Colors.grey),
                                          enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.grey[300],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SubCategoryList();
                                        },
                                      ).whenComplete(() {
                                        setState(() {
                                          _subCategoryTextController.text =
                                              _provider.selectedSubCategory;
                                        });
                                      });
                                    },
                                    icon: Icon(Icons.edit_outlined),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Container(
                            child: Row(
                              children: [
                                Text(
                                  'Collection',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(width: 10),
                                DropdownButton<String>(
                                  hint: Text('Select Collection'),
                                  value: dropDownValue,
                                  icon: Icon(Icons.arrow_drop_down),
                                  onChanged: (String value) {
                                    setState(() {
                                      dropDownValue = value;
                                    });
                                  },
                                  items: _collection
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Text('Stock: '),
                              Expanded(
                                child: TextFormField(
                                  controller: _stockTextController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Low Stock: '),
                              Expanded(
                                child: TextFormField(
                                  controller: _lowStockTextController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text('Tax %: '),
                              Expanded(
                                child: TextFormField(
                                  controller: _taxTextController,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    border: InputBorder.none,
                                  ),
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
