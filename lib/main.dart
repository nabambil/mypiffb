import 'package:flutter/material.dart';
import 'package:mypiffb/activities.dart';
import 'package:mypiffb/constant.dart';
import 'package:mypiffb/coupons.dart';
import 'package:mypiffb/donation.dart';
import 'package:mypiffb/login.dart';
import 'package:mypiffb/profile.dart';
import 'package:mypiffb/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'fredokaoneregular',
        primaryColor: Colors.purpleAccent,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.purpleAccent,
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.only(
              bottomLeft: const Radius.circular(40.0),
              bottomRight: const Radius.circular(40.0)),
        ),
        title: FutureBuilder<SharedPreferences>(
            future: SharedPreferences.getInstance(),
            builder: (context, snapshot) {
              if (snapshot.data == null)
                return Text("Hello, Guest");
              else if (snapshot.data.getBool(kKeyStatus) == false)
                return Text("Hello, Guest");
              else
                return Text(
                    "Hello, ${snapshot.data.getString(kKeyName) ?? 'Guest'}");
            }),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60.0), child: _BuildBottom()),
      ),
      endDrawer: _BuildDrawer(),
      body: _BuildBody(),
    );
  }
}

class _BuildBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/wallpaper1.jpg'), fit: BoxFit.fill)),
      child: GridView.count(
          padding: const EdgeInsets.all(12.0),
          crossAxisCount: 2,
          mainAxisSpacing: 12.0,
          crossAxisSpacing: 12.0,
          children: List.generate(
              2,
              (index) => _BuildTile(
                    index: index,
                  ))),
    );
  }
}

class _BuildTile extends StatelessWidget {
  final int index;

  const _BuildTile({Key key, this.index}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => action(context),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Icon(icon, size: 80, color: Colors.purpleAccent),
            ),
            SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.purpleAccent),
            ),
          ],
        ),
      ),
    );
  }

  String get title {
    if (index == 0)
      return 'Coupons';
    else if (index == 1)
      return 'Donations';
    // else if (index == 2)
    //   return 'Redeem Coupon';
    else
      return 'text';
  }

  IconData get icon {
    if (index == 0)
      return Icons.card_giftcard;
    else if (index == 1)
      return Icons.account_balance_wallet;
    // else if (index == 2)
    //   return Icons.card_giftcard;
    else
      return Icons.crop;
  }

  void action(BuildContext context) async {
    if (index == 0) {
      final prefs = await SharedPreferences.getInstance();
      final login = prefs.getBool(kKeyStatus);
      if (login == false)
        alert(context);
      else if (login == true)
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (ctx) => CouponsScreen()));
      else
        alert(context);
    } else if (index == 1)
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (ctx) => DonationsScreen()));
    else
      print('button tapped');
  }

  void alert(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Student Only'),
          content: Text(
              'To redeem food coupon you need to register as donee or login'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Register',
                style: TextStyle(color: Colors.purpleAccent, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => WelcomeScreen()));
              },
            ),
            FlatButton(
              child: Text(
                'Login',
                style: TextStyle(color: Colors.purpleAccent, fontSize: 18),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (ctx) => LoginScreen()));
              },
            ),
          ],
        );
      },
    );
  }
}

class _BuildBottom extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.purpleAccent,
        borderRadius: new BorderRadius.only(
            bottomLeft: const Radius.circular(40.0),
            bottomRight: const Radius.circular(40.0)),
      ),
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        child: TextField(
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: const BorderRadius.all(const Radius.circular(40.0)),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            filled: true,
            hintText: 'Search',
            fillColor: Colors.white70,
            suffixIcon: Icon(Icons.search),
          ),
        ),
      ),
    );
  }
}

class _BuildDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<SharedPreferences>(
          future: SharedPreferences.getInstance(),
          builder: (context, snapshot) {
            if (snapshot.data == null) return Container();
            final isLogin = snapshot.data.getBool(kKeyStatus);

            return Column(children: [
              DrawerHeader(
                padding: const EdgeInsets.all(12),
                child: Container(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 5)),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'FSKM',
                          style: TextStyle(color: Colors.white, fontSize: 32),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'FOOD BANK',
                          style: TextStyle(color: Colors.white, fontSize: 32),
                        ),
                      ],
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.purpleAccent,
                ),
              ),
              if (isLogin == true)
                _tile(
                    leading: Icons.access_time,
                    title: 'My Activity',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => ActivitiesScreen()));
                    }),
              if (isLogin == true)
                _tile(
                    leading: Icons.person,
                    title: 'My Profile',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => ProfileScreen()));
                    }),
              if (isLogin == false || isLogin == null)
                _tile(
                    leading: Icons.create,
                    title: 'Register As Donee',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => WelcomeScreen()));
                    }),
              Spacer(),
              if (isLogin == true)
                _tile(
                    leading: Icons.transit_enterexit,
                    title: 'Logout',
                    onTap: () {
                      snapshot.data.setBool(kKeyStatus, false);
                      snapshot.data.setString(kKeyName, null);
                      snapshot.data.setString(kKeyID, null);
                      Navigator.of(context).pop();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (ctx) => HomeScreen()));
                    }),
              if (isLogin == false || isLogin == null)
                _tile(
                    leading: Icons.transit_enterexit,
                    title: 'Login',
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (ctx) => LoginScreen()));
                    }),
            ]);
          }),
    );
  }

  ListTile _tile({String title, IconData leading, Function onTap}) => ListTile(
        leading: Icon(
          leading,
          color: Colors.purpleAccent,
          size: 32,
        ),
        title: Text(
          title,
          style: TextStyle(color: Colors.purpleAccent, fontSize: 18),
        ),
        onTap: onTap,
      );
}
