import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
      title: 'RM 5',
      expiry: DateTime.now().add(Duration(days: 4)),
      claimed: false),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().add(Duration(days: 5)),
      claimed: false),
  Coupon(
      title: 'RM 5',
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
      title: 'RM 5',
      expiry: DateTime.now().subtract(Duration(days: 2)),
      claimed: true),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().subtract(Duration(days: 3)),
      claimed: true),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().subtract(Duration(days: 4)),
      claimed: false),
  Coupon(
      title: 'RM 5',
      expiry: DateTime.now().subtract(Duration(days: 5)),
      claimed: false),
];

class CouponsScreen extends StatefulWidget {
  @override
  _CouponsScreenState createState() => _CouponsScreenState();
}

class _CouponsScreenState extends State<CouponsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/wallpaper1.jpg'), fit: BoxFit.fill)),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () => Navigator.of(context).pop(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32),
                child: Text('Coupons'.toUpperCase(),
                    style: TextStyle(fontSize: 32)),
              ),
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
}

class Coupon {
  final String title;
  final DateTime expiry;
  final bool claimed;
  final DateFormat format = DateFormat("dd MMMM yyyy");

  Coupon({@required this.title, @required this.expiry, @required this.claimed});

  bool get expired => expiry.isBefore(DateTime.now());
  Color get iconColor => expired ? Colors.red: Colors.black ;
  String get date => "Expired on: ${format.format(expiry)}";
}

class _CouponTile extends StatefulWidget {
  final Coupon coupon;

  const _CouponTile({Key key, @required this.coupon}) : super(key: key);

  @override
  __CouponTileState createState() => __CouponTileState();
}

class __CouponTileState extends State<_CouponTile> {
  bool claimed;

  @override
  void initState() {
    super.initState();

    claimed = widget.coupon.claimed;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        Icons.card_giftcard,
        color: widget.coupon.iconColor,
      ),
      title: Text(widget.coupon.title),
      subtitle: Text(widget.coupon.date),
      trailing: claimed ?null:  Text('GET'),
      onTap: () => !claimed && !(widget.coupon.expired) ? openQR(context) : null,
    );
  }

  void openQR(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Show to claim'),
          content: Image.asset(
            'assets/qrcode1.jpg',
            height: 250,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Done',
                style: TextStyle(color: Colors.purpleAccent, fontSize: 18),
              ),
              onPressed: () {
                setState(() => claimed = true);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
