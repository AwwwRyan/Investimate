import 'package:flutter/cupertino.dart';

class stockdata extends StatelessWidget {
  final double number;
  final String text;
  stockdata({Key? key,
  required this.number,
  required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children:[
      Text(
        number.toString(),
      style: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 24,
        color: Color(0xFFD8D8D8),
      ),),
    Text(text,
      style: TextStyle(
        fontFamily: 'Raleway',
        fontSize: 24,
        color: Color(0xFFD8D8D8),
      ),
    ),]);
  }
}
