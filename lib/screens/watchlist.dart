import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradesimulate/screens/stocks.dart';
import 'package:tradesimulate/global.dart';
class watchlist extends StatefulWidget {
  @override
  State<watchlist> createState() => _watchlistState();
}

class _watchlistState extends State<watchlist> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<watch>> getWatchlistData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('user_id');
    List<watch> wllist = [];

    var request = http.Request('GET',
        Uri.parse(global.url+'/watchlistview/'+ph!));

    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    print(data);
    if (response.statusCode == 200) {
      var a = jsonDecode(data.toString());
      for (Map i in a){
        watch wt= watch(
          stock_id: i['stock_id'],
          lastPrice: i['lastPrice'],
          ideal_buy: i['ideal_buy'],
          ideal_sell: i['ideal_sell'],
          change: i['change']
        );

        wllist.add(wt);
      }
      return wllist;
    } else {
      print(response.reasonPhrase);
    }
    return wllist;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF000000),
        body: Column(
          children: [
            Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)),
              ),
              child: Row(
                children: [

                  Container(
                    child: Center(
                      child: Text(
                        'STOCK',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * (1/4) ,
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'PRICE',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * (1/4),
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'IEDAL BUY',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * (1/4),
                  ),
                  Container(
                    child: Center(
                      child: Text(
                        'IDEAL SELL',
                        style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 16,
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    width: MediaQuery.of(context).size.width * (1/4),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height - 233,
              width: MediaQuery.of(context).size.width,
              color: Colors.black,
              child: Column(
                children: [
                  FutureBuilder<List<watch>>(
                    future: getWatchlistData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return Center(
                          child: Text('No data available.'),
                        );
                      } else {
                        List<watch>? wllist = snapshot.data;

                        return Expanded(
                          child: ListView.builder(
                            itemCount: wllist?.length,
                            itemBuilder: (context, index) {

                              watch? data = wllist?[index];
                              Color borderColor = data!.change >= 0 ? Colors.green : Colors.red;

                              return Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: borderColor, width: 1.0), // Adjust border width as needed
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => stocks(stockid: data.stock_id)));},
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            child: Center(
                                              child: Text(
                                                data!.stock_id,
                                                style: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  fontSize: 21,
                                                  color: Color(0xFFD8D8D8),
                                                ),
                                              ),
                                            ),
                                            width: MediaQuery.of(context).size.width / 4 - 8,
                                          ),
                                          Container(
                                            child: Center(
                                              child: Text(
                                                data?.lastPrice?.toStringAsFixed(2) ?? 'N/A',
                                                style: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  fontSize: 21,
                                                  color: Color(0xFFD8D8D8),
                                                ),
                                              ),
                                            ),
                                            width: MediaQuery.of(context).size.width / 4 - 8,
                                          ),
                                          Container(
                                            child: Center(
                                              child: Text(
                                                data?.ideal_buy?.toStringAsFixed(2) ?? 'N/A',
                                                style: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  fontSize: 21,
                                                  color: Color(0xFFD8D8D8),
                                                ),
                                              ),
                                            ),
                                            width: MediaQuery.of(context).size.width / 4 - 8,
                                          ),
                                          Container(
                                            child: Center(
                                              child: Text(
                                                data?.ideal_sell?.toStringAsFixed(2) ?? 'N/A',
                                                style: TextStyle(
                                                  fontFamily: 'Raleway',
                                                  fontSize: 21,
                                                  color: Color(0xFFD8D8D8),
                                                ),
                                              ),
                                            ),
                                            width: MediaQuery.of(context).size.width / 4 - 8,

                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                ],
                              );
                            },
                          ),
                        );
                      }
                    },
                  )
                ],
              ),

            )
          ],
        ));
  }
}

class watch {
  String stock_id;
  double lastPrice, ideal_sell, ideal_buy,change;
  watch(
      {required this.stock_id,
      required this.lastPrice,
      required this.ideal_buy,
      required this.ideal_sell,
        required this.change});
}
