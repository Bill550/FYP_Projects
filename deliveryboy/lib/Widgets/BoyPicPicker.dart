import 'dart:io';
import 'package:deliveryboy/Providers/AuthProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoyPicCard extends StatefulWidget {
  @override
  _BoyPicCardState createState() => _BoyPicCardState();
}

class _BoyPicCardState extends State<BoyPicCard> {
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
          height: 150,
          width: 150,
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: _image == null
                  ? Center(
                      child: Text(
                        'Add Boy logo',
                        style: TextStyle(color: Colors.grey),
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
