import 'package:flutter/material.dart';
import 'package:mypiffb/field.dart';
import 'package:mypiffb/register.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'constant.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  SharedPreferences prefs;
  String id;
  String password;
  String confirm;

  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((value) => prefs = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  'WELCOME!',
                  style: TextStyle(fontSize: 42, fontFamily: 'bungeeregular'),
                ),
                SizedBox(height: 12),
                Text(
                  'Please provide your Student ID along with a password to set up your account.',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 12),
                Field(label: 'Student ID', result: (value) => id = value),
                Field(
                    label: 'Password',
                    isHidden: true,
                    result: (value) => password = value),
                Field(
                    label: 'Confirm Password',
                    isHidden: true,
                    result: (value) => confirm = value),
                Spacer(),
                SizedBox(
                  child: FlatButton(
                    child: Text(
                      'REGISTER',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.black,
                    onPressed: () {
                      if (password == null || confirm == null || id == null)
                        Toast.show('Please fill all fields', context,
                            duration: 2);
                      else if (password.length == 0 ||
                          confirm.length == 0 ||
                          id.length == 0)
                        Toast.show('Please fill all fields', context,
                            duration: 2);
                      else if (password != confirm)
                        Toast.show(
                            'Password not match with confirm password', context,
                            duration: 2);
                      else {
                        prefs.setString(kKeyID, id);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (ctx) => RegisterScreen()));
                      }
                    },
                  ),
                  width: double.infinity,
                  height: 48,
                ),
                SizedBox(
                  width: double.infinity,
                  child: FlatButton(
                    child: Text(
                      'CANCEL',
                      style: TextStyle(color: Colors.black),
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
