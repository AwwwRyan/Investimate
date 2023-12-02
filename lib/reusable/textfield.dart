import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradesimulate/screens/signup.dart';

class textfield extends StatelessWidget {
final  TextInputType keyboardtype ;
final String hinttext;
final TextEditingController t;

  textfield({Key? key,
    required this.keyboardtype,
    required this.hinttext,
    required this.t,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      child: TextField(
          style: TextStyle(color: Color(0xFFD8D8D8), fontSize: 24),
          keyboardType: keyboardtype,
          controller: t,
          textAlign: TextAlign.start,
          decoration: InputDecoration(
            fillColor: Color(0xFFD8D8D8),
            hintText: hinttext,
            hintStyle: TextStyle(color: Colors.grey.shade600),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Color(0xFFD8D8D8),
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide(
                  color: Color(0xFFD8D8D8),
                )),
          )),
    );
  }
}
