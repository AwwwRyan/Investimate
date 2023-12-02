import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tradesimulate/reusable/authbuttons.dart';
import 'package:tradesimulate/screens/welcome3.dart';

class welcometwo extends StatelessWidget {
  const welcometwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141414),
      body: Column(
        children: [
          Spacer(),
          SvgPicture.asset('assets/welcome2.svg'),
          Container(height: 75),
          Row(
            children: [
              Spacer(),
              Spacer(),
              Spacer(),
              Spacer(),
              authbuttons(
                  backgroundcolor: Color(0xFF0CF2B4),
                  textcolor: Color(0xFFD8D8D8),
                  text: 'NEXT',
                  width: 150,
                  height: 50,
                  onpressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => welcomethree()));
                  }),
              Spacer(),
            ],
          ),
          Spacer(),


        ],
      ),

    );
  }
}
