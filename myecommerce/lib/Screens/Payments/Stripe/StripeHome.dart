import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:myecommerce/Providers/OrderProvider.dart';
import 'package:myecommerce/Screens/Payments/CreateNewCardScreen.dart';
import 'package:myecommerce/Screens/Payments/Stripe/existing-cards.dart';
import 'package:myecommerce/Services/Payments/Stripe-Payment-Service.dart';
import 'package:provider/provider.dart';

class StripeHome extends StatefulWidget {
  static const String id = 'stripe-home';

  StripeHome({Key key}) : super(key: key);

  @override
  StripeHomeState createState() => StripeHomeState();
}

class StripeHomeState extends State<StripeHome> {
  onItemPress(BuildContext context, int index, amount,
      OrderProvider orderProvider) async {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, CreateNewCardScreen.id);
        break;
      case 1:
        payViaNewCard(context, amount, orderProvider);
        break;
      case 2:
        Navigator.pushNamed(context, ExistingCardsPage.id);
        break;
    }
  }

  payViaNewCard(
      BuildContext context, amount, OrderProvider orderProvider) async {
    await EasyLoading.show(status: 'Please wait...');
    var response = await StripeService.payWithNewCard(
      amount: '${amount}00',
      currency: 'PKR',
      //TODO: Need to change PRK INTO USD OR AUD
    );
    if (response.success == true) {
      orderProvider.success = true;
    }
    await EasyLoading.dismiss();
    ScaffoldMessenger.of(context)
        .showSnackBar(
          SnackBar(
            content: Text(response.message),
            duration: new Duration(
              milliseconds: response.success == true ? 1200 : 3000,
            ),
          ),
        )
        .closed
        .then((_) {
      Navigator.pop(context);
    });
  }

  @override
  void initState() {
    super.initState();
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Column(
        children: [
          //TODO: EasyPaisa
          Material(
            elevation: 4,
            child: SizedBox(
              // height: 140,
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                child: Image.network(
                  'https://easypaisa.com.pk/wp-content/uploads/2019/10/Header-Icon.png',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey),
          //TODO: PayPal

          Material(
            elevation: 4,
            child: SizedBox(
              // height: 140,
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                child: Image.network(
                  'https://newsroom.mastercard.com/wp-content/uploads/2016/09/paypal-logo.png',
                  // fit: BoxFit.cover,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          Divider(color: Colors.grey),
          Material(
            elevation: 4,
            child: SizedBox(
              // height: 140,
              height: 56,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.only(left: 40, right: 40, top: 10),
                child: Image.network(
                  'https://stripe.com/img/v3/newsroom/social.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                Icon icon;
                Text text;

                switch (index) {
                  case 0:
                    icon = Icon(Icons.add_circle, color: theme.primaryColor);
                    text = Text('Add cards');
                    break;
                  case 1:
                    icon =
                        Icon(Icons.payment_outlined, color: theme.primaryColor);
                    text = Text('Pay via new card');
                    break;
                  case 2:
                    icon = Icon(Icons.credit_card, color: theme.primaryColor);
                    text = Text('Pay via existing card');
                    break;
                }

                return InkWell(
                  onTap: () {
                    onItemPress(
                        context, index, orderProvider.amount, orderProvider);
                  },
                  child: ListTile(
                    title: text,
                    leading: icon,
                  ),
                );
              },
              separatorBuilder: (context, index) => Divider(
                color: theme.primaryColor,
              ),
              itemCount: 3,
            ),
          ),
        ],
      ),
    );
  }
}
