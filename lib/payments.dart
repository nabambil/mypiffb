import 'package:flutter/material.dart';

class PaymentStatScreen extends StatelessWidget {
  final int amount;

  const PaymentStatScreen({Key key, this.amount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 100),
            Text('Thank you for your donations !', style: TextStyle(fontSize: 42, fontFamily: 'bungeeregular'),),
            SizedBox(height: 12),
            Text('RM $amount',style: TextStyle(fontSize: 72, color: Colors.purpleAccent),),
            SizedBox(height: 32),
            Text('Your donations will help our student from hunger.',style: TextStyle(fontSize: 20),),
            Spacer(),
            SizedBox(
              child: FlatButton(
                child: Text(
                  'THANKS! ❤️',
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.black,
                onPressed: () => Navigator.of(context).pop()
              ),
              width: double.infinity,
              height: 48,
            ),
          ],
        ),
      ),
    );
  }
}
