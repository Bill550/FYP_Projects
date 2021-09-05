import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vendorapp/Constants.dart';
import 'package:vendorapp/Provider/AuthProvider.dart';

class ShopPicCard extends StatefulWidget {
  @override
  _ShopPicCardState createState() => _ShopPicCardState();
}

class _ShopPicCardState extends State<ShopPicCard> {
  File _image;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: InkWell(
        onTap: () {
          _authData.getImage().then((image) {
            setState(() {
              _image = image;
            });

            if (image != null) {
              _authData.isPicAvil = true;
            }
            print(_image.path);
          });
        },
        child: SizedBox(
          height: 120,
          width: 120,
          child: Card(
            color: darkGreyColor,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _image == null
                  ? Center(
                      child: Text(
                        'Add Shop logo',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : Image.file(
                      _image,
                      fit: BoxFit.fill,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
