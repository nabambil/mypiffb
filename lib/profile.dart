import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'constant.dart';
import 'main.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
                child: Text('My Profile'.toUpperCase(),
                    style: TextStyle(fontSize: 32)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32),
                child: Text(
                  'Hello !',
                  style: TextStyle(fontSize: 72, fontFamily: 'bungeeregular'),
                ),
              ),
              SizedBox(height: 12),
              FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return Container();
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32),
                    child: Text(
                      '${snapshot.data.getString(kKeyName) ?? "HI"}',
                      style: TextStyle(fontSize: 48, color: Colors.purpleAccent),
                    ),
                  );
                }
              ),
              SizedBox(height: 32),
              FutureBuilder<SharedPreferences>(
                future: SharedPreferences.getInstance(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) return Container();

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32),
                    child: Text(
                      'Student ID : ${snapshot.data.getString(kKeyID) ?? "-"}',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
                }
              ),
              Padding(
                padding:const EdgeInsets.symmetric(vertical: 12.0, horizontal: 32),
                child: Text(
                  'You (Applicable) to received donation, Congrats!',
                  style: TextStyle(fontSize: 24, color: Colors.purpleAccent),
                ),
              ),
              Spacer(),
              Container(
                margin: const EdgeInsets.all(24),
                child: FlatButton(
                  child: Text(
                    'LOGOUT',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.black,
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool(kKeyStatus, false);
                    prefs.setString(kKeyName, null);
                    prefs.setString(kKeyID, null);
                    Navigator.of(context).pop();
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (ctx) => HomeScreen()));
                  },
                ),
                width: double.infinity,
                height: 48,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
