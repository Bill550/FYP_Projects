import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp/Provider/ProductProvider.dart';
import 'package:vendorapp/Widgets/CategoryList.dart';

class AddNewProduct extends StatefulWidget {
  static const String id = 'addNewProduct-screen';

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final _formKey = GlobalKey<FormState>();
  List<String> _collection = [
    'Featured Products',
    'Best Selling',
    'Recently Added'
  ];
  String dropDownValue;

  var _categoryTextController = TextEditingController();
  var _subCategoryTextController = TextEditingController();
  var _comparedPriceTextController = TextEditingController();
  var _brandTextController = TextEditingController();
  var _lowStockTextController = TextEditingController();
  var _stockTextController = TextEditingController();

  File _image;

  bool _visible = false;

  bool _track = false;

  String productName;
  String description;
  double price;
  double comparedPrice;
  String sku;
  String weight;
  double tax;

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);
    return DefaultTabController(
      length: 2,
      initialIndex: 1,
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Material(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: Container(
                          child: Text('Products / Add'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0),
                        child: TextButton.icon(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          icon: Icon(
                            Icons.save,
                            color: Colors.white,
                          ),
                          label: Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState.validate()) {
                              //only if filled neccessory field;
                              if (_categoryTextController.text.isNotEmpty) {
                                if (_subCategoryTextController
                                    .text.isNotEmpty) {
                                  if (_image != null) {
                                    //image should be selected
                                    // upload image to firestorage
                                    EasyLoading.show(status: 'Saving...');
                                    _provider
                                        .uploadProductImage(
                                            _image.path, productName)
                                        .then((url) {
                                      if (url != null) {
                                        EasyLoading.dismiss();

                                        //Upload Product Data to firestore
                                        _provider.saveProductDataToDB(
                                          context: context,
                                          comparedPrice: int.parse(
                                              _comparedPriceTextController
                                                  .text),
                                          brand: _brandTextController.text,
                                          collection: dropDownValue,
                                          description: description,
                                          lowStockQty: int.parse(
                                              _lowStockTextController.text),
                                          price: price,
                                          sku: sku,
                                          productName: productName,
                                          stockQty: int.parse(
                                              _stockTextController.text),
                                          tax: tax,
                                          weight: weight,
                                        );

                                        setState(() {
                                          _formKey.currentState.reset();
                                          _comparedPriceTextController.clear();
                                          _categoryTextController.clear();
                                          _subCategoryTextController.clear();
                                          _brandTextController.clear();
                                          _image = null;
                                          dropDownValue = null;
                                          _visible = false;
                                          _track = false;
                                        });
                                      } else {
                                        //Failed  Upload Product Data to firestore
                                        _provider.alertDialog(
                                          context: context,
                                          title: 'IMAGE UPLOAD',
                                          content:
                                              'Failed to upload product image',
                                        );
                                      }
                                    });
                                  } else {
                                    // image not selected
                                    _provider.alertDialog(
                                      context: context,
                                      title: 'PRODUCT IMAGE',
                                      content: 'Product image not selected',
                                    );
                                  }
                                } else {
                                  _provider.alertDialog(
                                    context: context,
                                    title: 'Sub-Category',
                                    content: 'Sub-Category not selected',
                                  );
                                }
                              } else {
                                _provider.alertDialog(
                                  context: context,
                                  title: 'Main Category',
                                  content: 'Main Category not selected',
                                );
                              }
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                indicatorColor: Theme.of(context).primaryColor,
                labelColor: Theme.of(context).primaryColor,
                unselectedLabelColor: Colors.black54,
                tabs: [
                  Tab(
                    text: 'GENERAL',
                  ),
                  Tab(
                    text: 'INVENTORY',
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    child: TabBarView(
                      children: [
                        ListView(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter product name';
                                      }
                                      setState(() {
                                        productName = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Product Name*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter description';
                                      }
                                      setState(() {
                                        description = value;
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 5,
                                    maxLength: 500,
                                    decoration: InputDecoration(
                                      labelText: 'About Product*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: () {
                                        _provider
                                            .getProductImage()
                                            .then((image) {
                                          setState(() {
                                            _image = image;
                                          });
                                        });
                                      },
                                      child: SizedBox(
                                        height: 150,
                                        width: 150,
                                        child: Card(
                                            child: _image == null
                                                ? Center(
                                                    child: Text('Select Iamge'))
                                                : Image.file(_image)),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter selling price';
                                      }
                                      setState(() {
                                        price = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Price*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _comparedPriceTextController,
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter compared price';
                                      }
                                      // not compulsory
                                      if (price > double.parse(value)) {
                                        //always comapred price should be higher
                                        return 'Compared price should be higher than price';
                                      }

                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Compared Price*',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
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
                                  TextFormField(
                                    //Not compulsory
                                    controller: _brandTextController,

                                    decoration: InputDecoration(
                                      labelText: 'Brand',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter SKU';
                                      }
                                      setState(() {
                                        sku = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'SKU',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 20, bottom: 10),
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
                                              controller:
                                                  _categoryTextController,
                                              validator: (value) {
                                                if (value.isEmpty) {
                                                  return 'Select Category Name';
                                                }
                                                return null;
                                              },
                                              decoration: InputDecoration(
                                                hintText: 'Not Selcted',
                                                labelStyle: TextStyle(
                                                    color: Colors.grey),
                                                enabledBorder:
                                                    UnderlineInputBorder(
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
                                        )
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: _visible,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 20),
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
                                                controller:
                                                    _subCategoryTextController,
                                                validator: (value) {
                                                  if (value.isEmpty) {
                                                    return 'Select Sub-Category Name';
                                                  }
                                                  return null;
                                                },
                                                decoration: InputDecoration(
                                                  hintText: 'Not Selcted',
                                                  labelStyle: TextStyle(
                                                      color: Colors.grey),
                                                  enabledBorder:
                                                      UnderlineInputBorder(
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
                                                builder:
                                                    (BuildContext context) {
                                                  return SubCategoryList();
                                                },
                                              ).whenComplete(() {
                                                setState(() {
                                                  _subCategoryTextController
                                                          .text =
                                                      _provider
                                                          .selectedSubCategory;
                                                });
                                              });
                                            },
                                            icon: Icon(Icons.edit_outlined),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter Weight';
                                      }
                                      setState(() {
                                        weight = value;
                                      });
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Weight. eg:- kg, gm, etc',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Enter tax %';
                                      }
                                      setState(() {
                                        tax = double.parse(value);
                                      });
                                      return null;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      labelText: 'Tax %',
                                      labelStyle: TextStyle(color: Colors.grey),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey[300],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SingleChildScrollView(
                          child: Column(
                            children: [
                              SwitchListTile(
                                value: _track,
                                onChanged: (selected) {
                                  setState(() {
                                    _track = !_track;
                                  });
                                },
                                title: Text('Track Inventory'),
                                activeColor: Theme.of(context).primaryColor,
                                subtitle: Text(
                                  'Switch ON to track inventory',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              Visibility(
                                visible: _track,
                                child: SizedBox(
                                  height: 300,
                                  width: double.infinity,
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            controller: _stockTextController,
                                            keyboardType: TextInputType.number,
                                            decoration: InputDecoration(
                                              labelText: 'Inventory Quantity* ',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey[300],
                                                ),
                                              ),
                                            ),
                                          ),
                                          TextFormField(
                                            keyboardType: TextInputType.number,
                                            //Not Compulsory
                                            controller: _lowStockTextController,
                                            decoration: InputDecoration(
                                              labelText:
                                                  'Inventory low Stock quantity* ',
                                              labelStyle:
                                                  TextStyle(color: Colors.grey),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors.grey[300],
                                                ),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
