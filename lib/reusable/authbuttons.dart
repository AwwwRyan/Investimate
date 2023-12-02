import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradesimulate/screens/signup.dart';

class authbuttons extends StatelessWidget {
  final Color backgroundcolor;
  final Color textcolor;
  final String text;
  double width;
  double height;
  final Function() onpressed;


  authbuttons({Key? key,
    required this.backgroundcolor,
    required this.textcolor,
    required this.text,
    required this.width,
    required this.height,
  required this.onpressed}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: ElevatedButton(
        child: Text(
          text,
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(backgroundcolor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  side: BorderSide(color: textcolor, width: 1),
                )
            )
        ),



        onPressed: onpressed,
      ),
    );
  }
}
