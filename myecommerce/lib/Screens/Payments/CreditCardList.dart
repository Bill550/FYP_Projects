import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:myecommerce/Screens/Payments/CreateNewCardScreen.dart';
import 'package:myecommerce/Services/Payments/Stripe-Payment-Service.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class CreditCardList extends StatelessWidget {
  static const String id = 'credit-card-list';
  @override
  Widget build(BuildContext context) {
    StripeService _stripeService = StripeService();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Manage Credit Cards',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              pushNewScreenWithRouteSettings(
                context,
                settings: RouteSettings(name: CreateNewCardScreen.id),
                screen: CreateNewCardScreen(),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
          )
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stripeService.cards.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No Credit Card added in your account'),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      pushNewScreenWithRouteSettings(
                        context,
                        settings: RouteSettings(name: CreateNewCardScreen.id),
                        screen: CreateNewCardScreen(),
                        withNavBar: false,
                        pageTransitionAnimation:
                            PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Text(
                      'Add Card',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Theme.of(context).primaryColor),
                    ),
                  )
                ],
              ),
            );
          }

          return Container(
            padding: EdgeInsets.only(
              left: 8,
              right: 8,
              top: 10,
              bottom: 10,
            ),
            child: ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                var card = snapshot.data.docs[index];
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: Container(
                    color: Colors.white,
                    child: CreditCardWidget(
                      cardNumber: card['cardNumber'],
                      expiryDate: card['expiryDate'],
                      cardHolderName: card['cardHolderName'],
                      cvvCode: card['cvvCode'],
                      showBackView: false,
                    ),
                  ),
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () {
                        EasyLoading.show(status: 'Please wait...');
                        _stripeService
                            .deleteCreditCard(card.id)
                            .whenComplete(() {
                          EasyLoading.showSuccess('card successfully removed');
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
