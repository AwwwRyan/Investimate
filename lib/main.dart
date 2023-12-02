import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradesimulate/screens/bottomnav.dart';
import 'package:tradesimulate/screens/login.dart';
import 'package:tradesimulate/screens/welcome1.dart';

void main() async {

  runApp(home());
}

class home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Raleway'
        ),
        home: MyHomePage());
  }
}

class MyHomePage extends StatefulWidget {
  @override
  SplashScreenState createState() => SplashScreenState();
}


class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) => loginscreen()
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFF141414),
        child:
        Container(
            child: new Image.asset('assets/title.png'),
          alignment: Alignment.center,),
    );
  }
}