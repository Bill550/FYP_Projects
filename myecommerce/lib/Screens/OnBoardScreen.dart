import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:myecommerce/Constants.dart';

class OnBoardScreen extends StatefulWidget {
  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

final _controller = PageController(
  initialPage: 0,
);

int _currentPage = 0;

List<Widget> _pages = [
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/DeliveryAddress.png')),
      Text(
        'Set Your Delivery Address',
        style: kPaageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/Order.png')),
      Text(
        'Order online from Your Favourite Store',
        style: kPaageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
  Column(
    children: [
      Expanded(child: Image.asset('assets/images/Deliveries.png')),
      Text(
        'Quick deliver to your Doorstep',
        style: kPaageViewTextStyle,
        textAlign: TextAlign.center,
      ),
    ],
  ),
];

class _OnBoardScreenState extends State<OnBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: PageView(
            controller: _controller,
            children: _pages,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        DotsIndicator(
          dotsCount: _pages.length,
          position: _currentPage.toDouble(),
          decorator: DotsDecorator(
            size: const Size.square(9.0),
            activeSize: const Size(18.0, 9.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            activeColor: Theme.of(context).primaryColor,
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
