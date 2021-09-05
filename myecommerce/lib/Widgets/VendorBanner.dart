import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:myecommerce/Providers/StoreProvider.dart';
import 'package:provider/provider.dart';

class VendorBanner extends StatefulWidget {
  @override
  _VendorBannerState createState() => _VendorBannerState();
}

class _VendorBannerState extends State<VendorBanner> {
  int _index = 0;
  int _datalength = 1;

  @override
  void didChangeDependencies() {
    var _store = Provider.of<StoreProvider>(context);

    getSliderImageFromDB(_store);
    super.didChangeDependencies();
  }

  Future getSliderImageFromDB(StoreProvider _store) async {
    var _firestore = FirebaseFirestore.instance;
    QuerySnapshot snapshot = await _firestore
        .collection('vendorBanner')
        .where('sellerUid', isEqualTo: _store.storeDetails['uid'])
        .get();
    if (mounted) {
      setState(() {
        _datalength = snapshot.docs.length;
      });
    }

    return snapshot.docs;
  }

  @override
  Widget build(BuildContext context) {
    var _store = Provider.of<StoreProvider>(context);

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          if (_datalength != 0)
            FutureBuilder(
              future: getSliderImageFromDB(_store),
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
                                getImages['imageUrl'],
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
