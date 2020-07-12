import 'package:flutter/material.dart';
import 'package:mypiffb/field.dart';
import 'package:mypiffb/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'constant.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  TabController controller;
  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      if(controller.index == controller.length-1)
        SharedPreferences.getInstance().then((value) => value.setBool(kKeyStatus, true));
    });

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
            child: TabBarView(
              children: [
                _Page1(next: next, back: back),
                _Page2(next: next, back: back),
                _Page3(next: next, back: back),
              ],
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }

  void next() => controller.index != 2
      ? controller.animateTo(controller.index + 1)
      : Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (ctx) => HomeScreen()));
  void back() => controller.index != 0
      ? controller.animateTo(controller.index - 1)
      : Navigator.of(context).pop();
}

class _Page1 extends StatefulWidget {
  final Function next;
  final Function back;

  const _Page1({Key key, @required this.next, @required this.back})
      : super(key: key);

  @override
  __Page1State createState() => __Page1State();
}

class __Page1State extends State<_Page1> {
  String name;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '1 of 3',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 12),
        Text(
          'Register your personal details',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 12),
        Text(
          'In order to use FSKM FoodBank, please provide some authentication information. You only need to do this once.',
          style: TextStyle(fontSize: 16, fontFamily: 'robotobold'),
        ),
        SizedBox(height: 12),
        Field(label: 'Name', result: (value) => name = value,),
        Field(label: 'IC Number'),
        Field(label: 'Programme'),
        Field(label: 'Part'),
        Field(label: 'Email Address'),
        Field(label: 'Phone Number'),
        Spacer(),
        SizedBox(
          child: FlatButton(
              child: Text(
                'NEXT',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
              onPressed: () async{
                if (name != null && name.length> 0 ) {
                  final prefs =await SharedPreferences.getInstance();
                  prefs.setString(kKeyName, name);
                  widget.next();
                }else{
                  Toast.show('Please Fill all fields', context);
                }
              }),
          width: double.infinity,
          height: 48,
        ),
        SizedBox(
          width: double.infinity,
          child: FlatButton(
              child: Text(
                'BACK',
                style: TextStyle(color: Colors.black),
              ),
              onPressed: widget.back),
        )
      ],
    );
  }
}

class _Page2 extends StatelessWidget {
  final Function next;
  final Function back;

  const _Page2({Key key, @required this.next, @required this.back})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '2 of 3',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 12),
        Text(
          "Register your Parent's / Guardian's details (if applicable)",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 12),
        Text(
          'In order to use FSKM FoodBank, please provide some authentication information. You only need to do this once.',
          style: TextStyle(fontSize: 16, fontFamily: 'robotobold'),
        ),
        SizedBox(height: 12),
        Field(label: "Parent's / Guardian's Name"),
        Field(label: "Parent's / Guardian's IC Number"),
        Field(label: "Parent's / Guardian's Occupation"),
        Field(label: "Parent's / Guardian's Payslip"),
        Spacer(),
        SizedBox(
          child: FlatButton(
              child: Text(
                'NEXT',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
              onPressed: next),
          width: double.infinity,
          height: 48,
        ),
        SizedBox(
          width: double.infinity,
          child: FlatButton(
            child: Text(
              'BACK',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: back,
          ),
        )
      ],
    );
  }
}

class _Page3 extends StatelessWidget {
  final Function next;
  final Function back;

  const _Page3({Key key, @required this.next, @required this.back})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '3 of 3',
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 12),
        Text(
          "Register your Household's details (if applicable)",
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 12),
        Text(
          'In order to use FSKM FoodBank, please provide some authentication information. You only need to do this once.',
          style: TextStyle(fontSize: 16, fontFamily: 'robotobold'),
        ),
        SizedBox(height: 12),
        Field(label: "Birth order in Siblings"),
        Field(label: "Number of Siblings"),
        Spacer(),
        SizedBox(
          child: FlatButton(
              child: Text(
                'SUBMIT',
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.black,
              onPressed: next),
          width: double.infinity,
          height: 48,
        ),
        SizedBox(
          width: double.infinity,
          child: FlatButton(
            child: Text(
              'BACK',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: back,
          ),
        )
      ],
    );
  }
}
