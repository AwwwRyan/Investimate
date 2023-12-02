import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tradesimulate/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradesimulate/screens/stocks.dart';

class portfolio extends StatefulWidget {
  const portfolio({Key? key}) : super(key: key);

  @override
  State<portfolio> createState() => _portfolioState();
}

class _portfolioState extends State<portfolio> {
List portlist = [];

Future<List<portfoliolist>> getportfolio() async {
  final response = await http.get(
      Uri.parse(global.url+'/portfoliolist/$user_id'));

  if (response.statusCode == 200) {
    final List<dynamic> data = jsonDecode(response.body);
    List<portfoliolist> portlist = [];
    print(data);

    for (Map<String, dynamic> item in data) {
      portfoliolist port = portfoliolist(
        stock_id: item['stock_id'],
        lastprice: item['lastprice'].toDouble(), // Convert to double
        amount: (item['holdings']*item['lastprice']).toDouble(),
        change: item['change'].toDouble(),// Convert to double
      );
      portlist.add(port);
    }

    return portlist;
  } else {
    throw Exception('Failed to load portfolio');
  }
}

fetchPortfolio() async{
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String user_id = prefs.getString('user_id')!;
  print(user_id);
  var request = http.Request('GET', Uri.parse(global.url+'/portfolioheader/'+user_id!));
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var data = await response.stream.bytesToString();
    var res = jsonDecode(data);
    net=res['netvalue'].toStringAsFixed(2);
  }
  else {
    print(response.reasonPhrase);
  }

}


String invested = '';
  String net = '';
  String user_id='';
  @override
  void initState() {
    super.initState();
    setPreferences();

  }

  setPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      invested = prefs.getString('netvalue')!;
      user_id = prefs.getString('user_id')!;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Column(
        children: [
          Container(
            height: 10,
          ),
          Container(
            height: 140,
            child: Row(
              children: [
                Container(
                  width: 18,
                ),
                Container(
                  width: MediaQuery.of(context).size.width -18,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // /info
                    children: [
                      //heading
                      Container(
                        height: 40,
                        child: Text(
                          "PORTFOLIO",
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 32,
                            color: Color(0xFFD8D8D8),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        height: 32,
                        child: Text(
                          "SUMMARY",
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 26,
                            color: Colors.grey,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      //current net
                      Container(
                          child: FutureBuilder(
                            future: fetchPortfolio(),
                            builder: (context,snapshot){
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),);
                              } else if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              } else{
                                return Row(
                                  children: [
                                    Text(
                                      net,
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 28,
                                        color: Color(0xFFD8D8D8),
                                      ),
                                    ),
                                    Text(
                                      " TOTAL INVESTED RUBIZ",
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 21,
                                        color: Color(0xFFD8D8D8),
                                      ),
                                    ),

                                  ],
                                );
                              }
                            },
                          )
                      ),

                    ],
                  ),
                ),

              ],
            ),
          ),
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
                  width: 10,
                ),
                Container(
                  child: Text(
                    'STOCK',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 20,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * (4 / 8) - 40,
                ),
                Container(
                  child: Text(
                    'LAST PRICE',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 20,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * (2 / 8)+20,
                ),
                Container(
                  child: Text(
                    'INVESTED',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 20,
                      color: Color(0xFFFFFFFF),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width * (2 / 8),
                ),
              ],
            ),
          ),
          Container(
            height: 442.6,
            child: Column(
              children: [
                Expanded(
                  child: FutureBuilder<List<portfoliolist>>(
                    future: getportfolio(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),);
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        List<portfoliolist> portfolioData = snapshot.data ?? [];

                        return ListView.builder(
                          itemCount: portfolioData.length,

                          itemBuilder: (context, index) {
                            portfoliolist data = portfolioData[index];
                            Color borderColor = data.change >= 0 ? Colors.green : Colors.red;

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
                                        context,
                                        MaterialPageRoute(builder: (context) => stocks(stockid: data.stock_id)),
                                      );
                                    },
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 40,
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 10,
                                              ),
                                              Container(
                                                child: Text(
                                                  data.stock_id,
                                                  style: TextStyle(
                                                    fontFamily: 'Raleway',
                                                    fontSize: 21,
                                                    color: Color(0xFFD8D8D8),
                                                  ),
                                                ),
                                                width: MediaQuery.of(context).size.width * (4 / 8) - 28,
                                              ),
                                              Container(
                                                child: Center(
                                                  child: Text(
                                                    data.lastprice.toStringAsFixed(2),
                                                    style: TextStyle(
                                                      fontFamily: 'Raleway',
                                                      fontSize: 21,
                                                      color: Color(0xFFD8D8D8),
                                                    ),
                                                  ),
                                                ),
                                                width: MediaQuery.of(context).size.width * (2 / 8),
                                              ),
                                              Container(
                                                child: Center(
                                                  child: Text(
                                                    data.amount.toStringAsFixed(2),
                                                    style: TextStyle(
                                                      fontFamily: 'Raleway',
                                                      fontSize: 21,
                                                      color: Color(0xFFD8D8D8),
                                                    ),
                                                  ),
                                                ),
                                                width: MediaQuery.of(context).size.width * (2 / 8),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 2),
                              ],
                            );
                          },
                        );
                      }
                    },
                  )

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class portfoliolist {
  String stock_id;
  double lastprice, amount,change;

  portfoliolist(
      {required this.stock_id, required this.lastprice, required this.amount, required this.change});
}
