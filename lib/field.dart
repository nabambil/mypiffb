import 'package:flutter/material.dart';

class Field extends StatefulWidget {
  final String label;
  final bool isHidden;
  final Function(String) result;

  const Field({Key key, this.label, this.isHidden = false, this.result}) : super(key: key);

  @override
  _FieldState createState() => _FieldState(isHidden);
}

class _FieldState extends State<Field> {
  bool secured;

  _FieldState(this.secured);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical:6.0),
      child: TextField(
        onChanged: widget.result,
        decoration: InputDecoration(
          labelText: widget.label,
          suffixIcon: widget.isHidden == false ? null : IconButton(
            icon: Icon(Icons.remove_red_eye),
            onPressed: () => setState(() => secured = !secured),
          ),
          border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.purpleAccent)),
        ),
        obscureText: secured,
      ),
    );
  }
}
