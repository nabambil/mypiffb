import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mypiffb/payments.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'card.dart';

final List<Coupon> coupons = [
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().add(Duration(days: 1)),
      claimed: true),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().add(Duration(days: 2)),
      claimed: true),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().add(Duration(days: 3)),
      claimed: true),
  Coupon(
      title: 'RM 10',
      expiry: DateTime.now().add(Duration(days: 4)),
      claimed: false),
  Coupon(
      title: 'RM 20',
      expiry: DateTime.now().add(Duration(days: 5)),
      claimed: false),
  Coupon(
      title: 'RM 10',
      expiry: DateTime.now().add(Duration(days: 6)),
      claimed: false),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().add(Duration(days: 7)),
      claimed: false),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().subtract(Duration(days: 1)),
      claimed: true),
  Coupon(
      title: 'RM 10',
      expiry: DateTime.now().subtract(Duration(days: 2)),
      claimed: true),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().subtract(Duration(days: 3)),
      claimed: true),
  Coupon(
      title: 'RM 50',
      expiry: DateTime.now().subtract(Duration(days: 4)),
      claimed: false),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().subtract(Duration(days: 5)),
      claimed: false),
];

class DonationsScreen extends StatefulWidget {
  @override
  _DonationsScreenState createState() => _DonationsScreenState();
}

class _DonationsScreenState extends State<DonationsScreen> {
  Token _paymentToken;

  PaymentMethod _paymentMethod;

  String _error;

  final String _currentSecret = null;
  PaymentIntentResult _paymentIntent;

  Source _source;

  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );

  @override
  void initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51H3iQDKN4QkqGLhQXFR5Wh1CagXCbmihCaoFqOrG8utIfJixJtoKFsFMVwgmoQBAU7AbXD8U1WHF9Dm5m2uuZvYa00UF89mcl7",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/wallpaper1.jpg'), fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Spacer(),
                  FlatButton(
                    child: Text('Donate Now', style: TextStyle(fontSize: 20)),
                    onPressed: () => Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) => CardScreen()))
                        .then((value) =>
                            value ? _settingModalBottomSheet(context) : null),
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32),
                child: Text('Donations'.toUpperCase(),
                    style: TextStyle(fontSize: 32)),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 32),
                child: Text(
                    'Your donation most welcome and will cheerish our students.',
                    style: TextStyle(fontSize: 18, fontFamily: 'robotobold')),
              ),
              SizedBox(height: 12),
              Expanded(
                child: ListView.separated(
                    itemBuilder: (ctx, index) => _CouponTile(
                          coupon: coupons[index],
                        ),
                    separatorBuilder: (ctx, index) => Divider(thickness: 1),
                    itemCount: coupons.length),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _settingModalBottomSheet(context) {
    ListTile _tile(int amount) => new ListTile(
          leading: Icon(Icons.payment),
          title: new Text('RM $amount'),
          onTap: () {
            Navigator.of(context).pop();
            _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Loading...')));

            StripePayment.createSourceWithParams(SourceParams(
              type: 'ideal',
              amount: amount,
              currency: 'myr',
              returnURL: 'example://stripe-redirect',
            )).then((source) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (ctx) => PaymentStatScreen(
                        amount: amount,
                      )));
            }).catchError((err) {
              _scaffoldKey.currentState
                  .showSnackBar(SnackBar(content: Text('Payment Failed')));
            });
          },
        );
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
              height: 320,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Text(
                      'Choose amount you want to donate :',
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  new Wrap(
                      children: [5, 10, 20, 50].map((e) => _tile(e)).toList()),
                ],
              ));
        });
  }
}

class Coupon {
  final String title;
  final DateTime expiry;
  final bool claimed;
  final DateFormat format = DateFormat("dd MMMM yyyy");

  Coupon({@required this.title, @required this.expiry, @required this.claimed});

  bool get expired => expiry.isBefore(DateTime.now());
  Color get iconColor => expired ? Colors.red : Colors.black;
  String get date =>
      "Donated on: ${format.format(expiry.subtract(Duration(days: 30)))}";
}

class _CouponTile extends StatelessWidget {
  final Coupon coupon;

  const _CouponTile({Key key, @required this.coupon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.payment),
      title: Text(coupon.title),
      subtitle: Text(coupon.date),
    );
  }
}
