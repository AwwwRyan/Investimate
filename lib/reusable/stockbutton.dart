import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tradesimulate/screens/stocks.dart';

class stockbutton extends StatelessWidget {
  final String stocksymbol;
  final String stockname;
  final double price;
  final double percent;

  stockbutton({
    Key? key,
    required this.stocksymbol,
    required this.stockname,
    required this.price,
    required this.percent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (MediaQuery.of(context).size.width) / 3,
      width: (MediaQuery.of(context).size.width) / 3,
      child: ElevatedButton(
        child: Column(
          children: [
            Spacer(),
            Text(stocksymbol,
            style: TextStyle(
              fontFamily: 'Raleway',
              fontSize: 26,
              color: Color(0xFFD8D8D8),
            ),
              ),
            Container(
              child: Text(stockname,
              style: TextStyle(
                fontFamily: 'Raleway',
                fontSize: 18,
                color: Color(0xFFD8D8D8),
              ),),
              width: (MediaQuery.of(context).size.width) / 3,
            ),
            Container(height: 8,),
            Row(
              children: [
                Text(price.toString(),
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  color: Color(0xFFD8D8D8),
                ),),
                Spacer(),
                Text(percent.toString(),
                style: TextStyle(
                  fontFamily: 'Raleway',
                  fontSize: 18,
                  color: Color(0xFFD8D8D8),
                ),)
              ],
            ),
            Spacer(),
          ],
        ),
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.grey.shade800),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(color: Colors.black, width: 0.4),
            ))),
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => stocks(stockid: stocksymbol)));
        },
      ),
    );
  }
}
