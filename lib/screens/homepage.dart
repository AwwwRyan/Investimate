import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tradesimulate/global.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradesimulate/reusable/stockbutton.dart';

import '../reusable/authbuttons.dart';

class homepage extends StatefulWidget {
  homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  var user_id;
  var rubiz;

  String responseData = '';
  @override
  void initState() {
    super.initState();
    fetchData();
    setPreferences();
  }

  Future<List<watchfour>> getfourwatchlist() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph = prefs.getString('user_id');
    List<watchfour> watchlistfourlist = [];

    var request =
        http.Request('GET', Uri.parse(global.url + '/watchlistfour/' + ph!));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var a = jsonDecode(data.toString());

      for (Map i in a) {
        double pChange = i['pChange'].toDouble();
        pChange = double.parse(pChange.toStringAsFixed(2));
        watchfour wfour = watchfour(
          stock_id: i['stock_id'],
          stockname: i['stockname'],
          lastPrice: i['lastPrice'],
          pChange: pChange,
        );
        watchlistfourlist.add(wfour);
      }

      return watchlistfourlist;
    } else {
      return []; // Return an empty list or handle the error appropriately
    }
  }

  fetchPortfolio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String user_id = prefs.getString('user_id')!;
    var request = http.Request(
        'GET', Uri.parse(global.url + '/portfolioheader/' + user_id!));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var res = jsonDecode(data);
      net = res['netvalue'].toStringAsFixed(2);
    } else {
    }
  }

  setPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      user_id = prefs.getString('user_id');
    });
  }

  Future<void> fetchData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? ph1 = prefs.getString('user_id');
    var url = Uri.parse(global.url + '/rubie/' + ph1!);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        responseData = response.body;
      });
    } else {
      setState(() {
        responseData = 'Error: ${response.reasonPhrase}';
      });
    }
    SharedPreferences prefs1 = await SharedPreferences.getInstance();
    rubiz = prefs1.setString('rubiz', responseData);
  }

  upadaterub(user_id, amount) async {
    var request = http.Request('PUT',
        Uri.parse(global.url + '/updaterubies/' + user_id + '/' + amount));
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
    } else {
      print(response.reasonPhrase);
    }
  }

  TextEditingController numberofrubiz = TextEditingController();
  String net = '';

  @override
  Widget build(BuildContext context) {
    double wd = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //rubiz
          Container(
            height: 100,
            color: Color(0xFF151515),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(child: Image(image: AssetImage('assets/rubiz.png'))),
              Container(
                width: 10,
              ),
              Container(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (responseData.isEmpty)
                    CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)
                  else
                    Text(
                      responseData,
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 32,
                        color: Color(0xFFD8D8D8),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                ],
              )),
              Container(
                width: 60,
              ),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 0.4),
                  shape: BoxShape.circle,
                ),
                child: InkWell(
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: 420,
                          color: Color(0xFF151515),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Row(
                                children: [
                                  Spacer(),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width - 100,
                                    child: TextField(
                                        style: TextStyle(
                                            color: Color(0xFFD8D8D8),
                                            fontSize: 22),
                                        controller: numberofrubiz,
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.start,
                                        readOnly: false,
                                        decoration: InputDecoration(
                                          fillColor: Color(0xFFD8D8D8),
                                          hintText: 'NUMBER OF RUBIZ',
                                          hintStyle: TextStyle(
                                              color: Colors.grey.shade600),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              borderSide: BorderSide(
                                                color: Color(0xFFD8D8D8),
                                              )),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              borderSide: BorderSide(
                                                color: Color(0xFFD8D8D8),
                                              )),
                                        )),
                                  ),
                                  Spacer(),
                                ],
                              ),
                              Container(
                                height: 16,
                              ),
                              authbuttons(
                                  backgroundcolor: Color(0xFF0CF2B4),
                                  textcolor: Color(0xFFD8D8D8),
                                  text: 'ADD MORE RUBIZ',
                                  width: 180,
                                  height: 50,
                                  onpressed: () async {
                                    String rubiz1 = responseData;
                                    double num2 = double.parse(rubiz1);
                                    double temp =
                                        double.parse(numberofrubiz.text);

                                    double var01 = num2 + temp;
                                    upadaterub(
                                        user_id, var01.toStringAsFixed(4));
                                    fetchData();
                                    numberofrubiz.text = ' ';
                                    Navigator.pop(context);
                                  }),
                              Container(
                                height: 200,
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(
                      Icons.add,
                      size: 30.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          ),
          //spacer
          Container(
            height: 14,
          ),
          //portfolio
          Container(
            height: 120,
            child: Row(
              children: [
                Container(
                  width: 18,
                ),
                Container(
                  width: wd - 18,
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
                                      " INVESTED RUBIZ",
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
                      //invested
                      Container(
                          child: Row(
                        children: [
                          if (responseData.isEmpty)
                            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),)
                          else
                            Text(
                              responseData,
                              style: TextStyle(
                                fontFamily: 'Raleway',
                                fontSize: 32,
                                color: Color(0xFFD8D8D8),
                              ),
                            ),
                          Text(
                            " RUBIZ LEFT",
                            style: TextStyle(
                              fontFamily: 'Raleway',
                              fontSize: 21,
                              color: Color(0xFFD8D8D8),
                            ),
                          ),
                        ],
                      )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          //spacer
          //watchlist
          Container(
              width: wd,
              decoration: BoxDecoration(
                color: Color(0xFF151515),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0)),
              ),
              child: Column(
                children: [
                  Container(
                    height: 14,
                  ),
                  //watchlist
                  Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    //spacer
                    Container(
                      width: 18,
                    ),
                    //title
                    Text(
                      "WATCHLIST",
                      style: TextStyle(
                        fontFamily: 'Raleway',
                        fontSize: 32,
                        color: Color(0xFFD8D8D8),
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ]),
                  Container(
                    height: 16,
                  ),

                  Center(
                    child: Container(
                      width: wd,
                      decoration: BoxDecoration(
                        color: Color(0xFF151515),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30.0),
                          topLeft: Radius.circular(30.0),
                        ),
                      ),
                      child: FutureBuilder<List<watchfour>>(
                        future: getfourwatchlist(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white),));
                          } else if (snapshot.hasError) {
                            return Center(
                                child: Text('Error: ${snapshot.error}'));
                          } else if (!snapshot.hasData ||
                              snapshot.data!.isEmpty) {
                            return Center(child: Text('No data available.'));
                          } else {
                            final watchlistData = snapshot.data;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                for (int i = 0;
                                    i < watchlistData!.length;
                                    i += 2)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16.0),
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          stockbutton(
                                            stocksymbol:
                                                watchlistData[i].stock_id,
                                            stockname:
                                                watchlistData[i].stockname,
                                            price: watchlistData[i].lastPrice,
                                            percent: watchlistData[i].pChange,
                                          ),
                                          if (i + 1 < watchlistData.length)
                                            stockbutton(
                                              stocksymbol:
                                                  watchlistData[i + 1].stock_id,
                                              stockname: watchlistData[i + 1]
                                                  .stockname,
                                              price: watchlistData[i + 1]
                                                  .lastPrice,
                                              percent:
                                                  watchlistData[i + 1].pChange,
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: wd,
                    height: 24,
                    decoration: BoxDecoration(
                      color: Color(0xFF151515),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30.0),
                          bottomRight: Radius.circular(30.0)),
                    ),
                  ),
                ],
              )),
        ],
      ),
    );
  }
/*
  Future<void> getname() async {
    var perf= await SharedPreferences.getInstance();
    name=perf.getString("drinkname")!;
    setState(() {

    });
  }
}*/
}

class watchfour {
  String stock_id, stockname;
  double lastPrice, pChange;

  watchfour({
    required this.stock_id,
    required this.stockname,
    required this.lastPrice,
    required this.pChange,
  });
}
