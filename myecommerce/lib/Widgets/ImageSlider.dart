import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class ImageSlider extends StatefulWidget {
  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _index = 0;
  int _datalength = 1;

  @override
  void initState() {
    getSliderImageFromDB();
    super.initState();
  }

  Future getSliderImageFromDB() async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore.collection('slider').get();
    if (mounted) {
      setState(() {
        _datalength = snapshot.docs.length;
      });
    }

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (_datalength != 0)
            FutureBuilder(
              future: getSliderImageFromDB(),
              builder: (_, snapshot) {
                return snapshot.data == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 0.0),
                        child: CarouselSlider.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, int index, int) {
                            DocumentSnapshot sliderImages =
                                snapshot.data[index];
                            Map getImages = sliderImages.data();
                            return SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                getImages['image'],
                                fit: BoxFit.fill,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            viewportFraction: 1,
                            initialPage: 0,
                            autoPlay: true,
                            height: 150,
                            onPageChanged: (int i, carouselPageChangedReason) {
                              setState(() {
                                _index = i;
                              });
                            },
                          ),
                        ),
                      );
              },
            ),
          if (_datalength != 0)
            DotsIndicator(
              dotsCount: _datalength,
              position: _index.toDouble(),
              decorator: DotsDecorator(
                size: const Size.square(5.0),
                activeSize: const Size(18.0, 5.0),
                activeShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0)),
                activeColor: Theme.of(context).primaryColor,
              ),
            ),
        ],
      ),
    );
  }
}
