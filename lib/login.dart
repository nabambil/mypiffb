import 'package:flutter/material.dart';
import 'package:mypiffb/constant.dart';
import 'package:mypiffb/main.dart';
import 'package:mypiffb/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'field.dart';

final List<User> users = [
  User('2020838272', 'Awesome223', 'Shahrul'),
  User('2019870116', 'Unique2019', 'Afiqah'),
  User('2018287958', 'Shasha1997', 'Sharifah'),
];

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String studentID;
  String password;
  GlobalKey<State> _keyLoader = new GlobalKey<State>();

  @override
  void dispose() {
    _keyLoader = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyLoader,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/wallpaper1.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'HELLO THERE!',
                  style: TextStyle(fontSize: 42, fontFamily: 'bungeeregular'),
                ),
                Text(
                  'WELCOME BACK',
                  style: TextStyle(fontSize: 42, fontFamily: 'bungeeregular'),
                ),
                SizedBox(height: 12),
                Text(
                  'Login to continue to FSKM FoodBank as Donee',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 12),
                Field(
                    label: 'Student ID', result: (value) => studentID = value),
                Field(
                    label: 'Password',
                    isHidden: true,
                    result: (value) => password = value),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    'Forgot Password?'.toUpperCase(),
                    textAlign: TextAlign.end,
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                Spacer(),
                SizedBox(
                  child: FlatButton(
                    child: Text(
                      'LOGIN',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                    onPressed: () => _handleSubmit(context),
                  ),
                  width: double.infinity,
                  height: 48,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      "DON'T HAVE AN ACCOUNT? REGISTER",
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (ctx) => WelcomeScreen())),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _handleSubmit(BuildContext context) async {
    bool anyUser = false;
    try {
      for (var element in users) {
        if (await element.checkUser(studentID, password)){
          anyUser = true;
          break;
        }
      }
      if (anyUser == false)
        throw'Incorrect student id or password, try again.';

      Navigator.of(context).pop(); //close the dialoge
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => HomeScreen()));
    } catch (error) {
      Toast.show(error, context, duration: 2, gravity: 1);
    }
  }
}

class User {
  final String id;
  final String password;
  final String name;

  User(this.id, this.password, this.name);

  Future<bool> checkUser(String student_id, String student_password) async {
    if (student_id == null || student_password == null || student_id.length == 0 || student_password.length == 0) throw 'Please fill all fields';
    if (student_id == id && password == student_password) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(kKeyStatus, true);
      prefs.setString(kKeyName, name);
      prefs.setString(kKeyID, id);
      return Future.value(true);
    }
    return Future.value(false);
  }
}