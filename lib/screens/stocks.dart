import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tradesimulate/reusable/stockdata.dart';
import 'package:tradesimulate/screens/bottomnav.dart';
import 'package:http/http.dart' as http;
import 'package:tradesimulate/global.dart';

import '../reusable/authbuttons.dart';

class stocks extends StatefulWidget {
  final String stockid;
  stocks({required this.stockid});
  @override
  State<stocks> createState() => _stocksState();
}

loginUser(user_id, stock_id, ideal_buy, ideal_sell) async {
  var request =
      http.MultipartRequest('POST', Uri.parse(global.url + '/watchlist/'));
  request.fields.addAll({
    'user_id': user_id,
    'stock_id': stock_id,
    'ideal_buy': ideal_buy,
    'ideal_sell': ideal_sell,
  });

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return "done";
  } else {
    print(response.reasonPhrase);
  }

  return " ";
}

fetchData(user_id) async {
  var url = Uri.parse(global.url + '/rubie/' + user_id);
  var response = await http.get(url);

  if (response.statusCode == 200) {
  } else {
    print(response.reasonPhrase);
  }
  var rubiz1 = response.body;
  return rubiz1;
}

upadaterub(user_id, amount) async {
  var request = http.Request(
      'PUT', Uri.parse(global.url + '/updaterubies/' + user_id + '/' + amount));
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    print(await response.stream.bytesToString());
  } else {
    print(response.reasonPhrase);
  }
}

selling(user_id, stock_id, amount, holdings) async {
  var request =
      http.MultipartRequest('POST', Uri.parse(global.url + '/portfolio/sell'));
  request.fields.addAll({
    'user_id': user_id,
    'stock_id': stock_id,
    'amount': amount,
    'holdings': holdings
  });
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return 'done';
  } else {
    print(response.reasonPhrase);
  }
  return " ";
}

buying(user_id, stock_id, amount, int holdings) async {
  var request =
      http.MultipartRequest('POST', Uri.parse(global.url + '/portfolio/buy'));
  request.fields.addAll({
    'user_id': user_id,
    'stock_id': stock_id,
    'amount': amount,
    'holdings': holdings.toString()
  });
  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    return 'done';
  } else {
    print(response.reasonPhrase);
  }
  return " ";
}

class _stocksState extends State<stocks> {
  var user_id = '';
  var rubiz1 = 0;

  Future<List> fetchStockData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user_id = prefs.getString('user_id')!;

    List<_SalesData> graphdata = [];
    var request = http.Request(
        'GET',
        Uri.parse(
            global.url + '/graphstocks/' + widget.stockid.toString() + '/90'));
    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();
    if (response.statusCode == 200) {
      var a = jsonDecode(data.toString());

      for (Map i in a) {
        graphdata.add(_SalesData(i['date'].toString(), i['prevclose']));
      }
      return graphdata;
    } else {
      print('Failed to fetch data');
    }
    return [];
  }

  String stockname = '';
  double pChange = 0.0;
  double lastPrice = 0.0;
  double change = 0.0;
  double previousClose = 0.0;
  double open = 0.0;
  double close = 0.0;
  double vwap = 0.0;
  String upperCP = '';
  double basePrice = 0.0;
  @override
  void initState() {
    super.initState();
    fetchStocks();
  }

  fetchStocks() async {
    var request = http.Request(
        'GET', Uri.parse(global.url + '/stock/' + widget.stockid.toString()));

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var data = await response.stream.bytesToString();
      var res = jsonDecode(data);

      // Check if the properties exist and are not null
      stockname = res['stockname'] != null ? res['stockname'].toString() : '';
      pChange = res['pChange'] != null
          ? double.parse(res['pChange'].toStringAsFixed(2))
          : 0.0;
      lastPrice = res['priceInfo'] != null
          ? double.parse(res['priceInfo'].toStringAsFixed(2))
          : 0.0;
      change = res['change'] != null
          ? double.parse(res['change'].toStringAsFixed(2))
          : 0.0;
      previousClose = res['prevClose'] != null
          ? double.parse(res['prevClose'].toStringAsFixed(2))
          : 0.0;
      open = res['open'] != null
          ? double.parse(res['open'].toStringAsFixed(2))
          : 0.0;
      close = res['close'] != null
          ? double.parse(res['close'].toStringAsFixed(2))
          : 0.0;
      vwap = res['vwap'] != null
          ? double.parse(res['vwap'].toStringAsFixed(2))
          : 0.0;
      upperCP = res['upperCP'] != null ? res['upperCP'].toString() : '';
      basePrice = res['basePrice'] != null
          ? double.parse(res['basePrice'].toStringAsFixed(2))
          : 0.0;
    } else {
      print(response.reasonPhrase);
    }
  }

  TextEditingController ideal_buy = TextEditingController();
  TextEditingController ideal_sell = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController holdings = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF000000),
        appBar: AppBar(
          backgroundColor: Colors.black,
          centerTitle: true,
          title: SvgPicture.asset('assets/title.svg'),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            Container(
              height: 100,

              child: InkWell(
                onTap: () {

                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => stocks(stockid: widget.stockid)));
                },
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Icon(
                    Icons.refresh,
                    size: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: 20,
            )
          ],
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => bottomnav()));
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),

        ),

        body: Column(children: [
          Container(
            height: 8,
          ),
          //stock price
          Container(
            height: 100,
            child: Row(
              children: [
                Container(
                  width: 18,
                ),
                Container(
                  width: MediaQuery.of(context).size.width * (2 / 3) + 18,
                  child: FutureBuilder(
                      future: fetchStocks(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          );
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // /info
                            children: [
                              //heading
                              Container(
                                height: 40,
                                child: Text(
                                  stockname,
                                  style: TextStyle(
                                    fontFamily: 'Raleway',
                                    fontSize: 28,
                                    color: Color(0xFFD8D8D8),
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              //current net
                              Container(
                                  child: Row(
                                children: [
                                  Text(
                                    "₹" + lastPrice.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 28,
                                      color: Color(0xFFD8D8D8),
                                    ),
                                  ),
                                  Text(
                                    "  Rate",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 21,
                                      color: Color(0xFFD8D8D8),
                                    ),
                                  ),
                                ],
                              )),
                              //invested
                              Container(
                                  child: Row(
                                children: [
                                  Text(
                                    change.toString(),
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 21,
                                      color: Color(0xFFD8D8D8),
                                    ),
                                  ),
                                  Text(
                                    "  NET CHANGE",
                                    style: TextStyle(
                                      fontFamily: 'Raleway',
                                      fontSize: 16,
                                      color: Color(0xFFD8D8D8),
                                    ),
                                  ),
                                ],
                              )),
                            ],
                          );
                        }
                      }),
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
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          20,
                                      child: TextField(
                                          style: TextStyle(
                                              color: Color(0xFFD8D8D8),
                                              fontSize: 22),
                                          keyboardType: TextInputType.number,
                                          controller: ideal_buy,
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            fillColor: Color(0xFFD8D8D8),
                                            hintText: 'ideal buy',
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
                                    Container(
                                      width: MediaQuery.of(context).size.width /
                                              2 -
                                          20,
                                      child: TextField(
                                          style: TextStyle(
                                              color: Color(0xFFD8D8D8),
                                              fontSize: 22),
                                          keyboardType: TextInputType.number,
                                          controller: ideal_sell,
                                          textAlign: TextAlign.start,
                                          decoration: InputDecoration(
                                            fillColor: Color(0xFFD8D8D8),
                                            hintText: 'ideal sell',
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
                                    text: 'ADD TO WATCHLIST',
                                    width: 200,
                                    height: 50,
                                    onpressed: () async {
                                      if (double.parse(ideal_buy.text) >=
                                          lastPrice) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  backgroundColor: Colors.grey
                                                      .shade800, // Background color of the dialog
                                                  title: Text(
                                                    'IDEAL BUY IS GREATER THAN CURRENT PRICE',
                                                    style: TextStyle(
                                                      fontFamily: 'Raleway',
                                                      fontSize: 18,
                                                      color: Color(0xFFD8D8D8),
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ));
                                            });
                                      } else if (double.parse(
                                              ideal_sell.text) <=
                                          lastPrice) {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                  backgroundColor: Colors.grey
                                                      .shade800, // Background color of the dialog
                                                  title: Text(
                                                    'IDEAL SELL IS LESS THAN CURRENT PRICE',
                                                    style: TextStyle(
                                                      fontFamily: 'Raleway',
                                                      fontSize: 18,
                                                      color: Color(0xFFD8D8D8),
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ));
                                            });
                                      } else {
                                        await loginUser(user_id, widget.stockid,
                                            ideal_buy.text, ideal_sell.text);

                                        Navigator.pop(context);
                                      }
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
              ],
            ),
          ),
          //stock data
          Container(
            height: MediaQuery.of(context).size.height - 260,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(children: [
                Container(
                  height: MediaQuery.of(context).size.height / 3.5,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Center(
                    child: FutureBuilder(
                        future: fetchStockData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List graphdata = snapshot.data ?? [];

                            return SfCartesianChart(
                                plotAreaBorderWidth: 0,
                                primaryXAxis: CategoryAxis(
                                  majorGridLines: MajorGridLines(width: 0),
                                  //Hide the axis line of x-axis
                                  axisLine: AxisLine(width: 0),
                                  isVisible: false,
                                ),
                                palette: <Color>[Colors.white],
                                primaryYAxis: NumericAxis(
                                  majorGridLines: MajorGridLines(width: 0),
                                  axisLine: AxisLine(width: 0),
                                  isVisible: false,
                                ),
                                tooltipBehavior: TooltipBehavior(enable: true),
                                series: <ChartSeries<dynamic, String>>[
                                  LineSeries<dynamic, String>(
                                    dataSource: graphdata,
                                    xValueMapper: (dynamic sales, _) =>
                                        sales.date,
                                    yValueMapper: (dynamic sales, _) =>
                                        sales.prevclose,
                                  )
                                ]);
                          }
                        }),
                  ),
                ),
                FutureBuilder(
                    future: fetchStocks(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                    width:
                                    MediaQuery.of(context).size.width / 3,
                                    child: stockdata(
                                        number: pChange, text: 'pChange')),
                                Container(
                                    width:
                                    MediaQuery.of(context).size.width / 3,
                                    child: stockdata(
                                        number: previousClose,
                                        text: 'prev close')),
                                Container(
                                    width:
                                    MediaQuery.of(context).size.width / 3,
                                    child:
                                    stockdata(number: open, text: 'open')),
                              ],
                            ),
                            Container(
                              height: 18,
                            ),
                            Row(
                              children: [
                                Container(
                                    width:
                                    MediaQuery.of(context).size.width / 3,
                                    child: stockdata(
                                        number: close, text: 'close')),
                                Container(
                                    width:
                                    MediaQuery.of(context).size.width / 3,
                                    child:
                                    stockdata(number: vwap, text: 'vwap')),
                                Container(
                                  width: MediaQuery.of(context).size.width / 3,
                                  child: Column(children: [
                                    Text(
                                      upperCP,
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 24,
                                        color: Color(0xFFD8D8D8),
                                      ),
                                    ),
                                    Text(
                                      'UpperCP',
                                      style: TextStyle(
                                        fontFamily: 'Raleway',
                                        fontSize: 24,
                                        color: Color(0xFFD8D8D8),
                                      ),
                                    ),
                                  ]),
                                ),
                              ],
                            ),
                            Container(
                              height: 137,
                            ),
                          ],
                        );
                      }
                    }),



                //buy sell
                Container(
                  child: Row(
                    children: [
                      Spacer(),
                      //sell button
                      authbuttons(
                          backgroundcolor: Colors.red,
                          textcolor: Colors.white,
                          text: 'SELL',
                          width: 160,
                          height: 60,
                          onpressed: () {
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
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            child: TextField(
                                                style: TextStyle(
                                                    color: Color(0xFFD8D8D8),
                                                    fontSize: 22),
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: amount,
                                                textAlign: TextAlign.start,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  fillColor: Color(0xFFD8D8D8),
                                                  hintText: 'AMOUNT',
                                                  hintStyle: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFD8D8D8),
                                                          )),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFD8D8D8),
                                                          )),
                                                )),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            child: TextField(
                                                style: TextStyle(
                                                    color: Color(0xFFD8D8D8),
                                                    fontSize: 22),
                                                onChanged: (value) {
                                                  amount.text =
                                                      (int.parse(value) *
                                                              lastPrice)
                                                          .toStringAsFixed(2);
                                                },
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: holdings,
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  fillColor: Color(0xFFD8D8D8),
                                                  hintText: 'HOLDINGS',
                                                  hintStyle: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFD8D8D8),
                                                          )),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFD8D8D8),
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
                                          text: 'SELL',
                                          width: 200,
                                          height: 50,
                                          onpressed: () async {
                                            double amt = lastPrice *
                                                (int.parse(holdings.text));
                                            String rubiz1 =
                                                await fetchData(user_id);
                                            double num2 = double.parse(rubiz1);
                                            amt = amt + num2;
                                            upadaterub(user_id,
                                                amt.toStringAsFixed(4));
                                            var result = await selling(
                                                user_id,
                                                widget.stockid,
                                                amt.toString(),
                                                holdings.text);
                                            if (result == 'done') {
                                              Navigator.pop(context);
                                              amount.text = '';
                                              holdings.text = '';
                                            }
                                          }),

                                      Container(
                                        height: 200,
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                      Spacer(),
                      //buy button
                      authbuttons(
                          backgroundcolor: CupertinoColors.systemGreen,
                          textcolor: Colors.white,
                          text: 'BUY',
                          width: 160,
                          height: 60,
                          onpressed: () {
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
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            child: TextField(
                                                style: TextStyle(
                                                    color: Color(0xFFD8D8D8),
                                                    fontSize: 22),
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: amount,
                                                onChanged: (value) {
                                                  holdings.text =
                                                      ((int.parse(value) /
                                                                  lastPrice)
                                                              .floor())
                                                          .toStringAsFixed(2);
                                                },
                                                textAlign: TextAlign.start,
                                                decoration: InputDecoration(
                                                  fillColor: Color(0xFFD8D8D8),
                                                  hintText: 'AMOUNT',
                                                  hintStyle: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFD8D8D8),
                                                          )),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFD8D8D8),
                                                          )),
                                                )),
                                          ),
                                          Spacer(),
                                          Container(
                                            width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    2 -
                                                20,
                                            child: TextField(
                                                style: TextStyle(
                                                    color: Color(0xFFD8D8D8),
                                                    fontSize: 22),
                                                keyboardType:
                                                    TextInputType.number,
                                                controller: holdings,
                                                textAlign: TextAlign.start,
                                                readOnly: true,
                                                decoration: InputDecoration(
                                                  fillColor: Color(0xFFD8D8D8),
                                                  hintText: 'HOLDINGS',
                                                  hintStyle: TextStyle(
                                                      color:
                                                          Colors.grey.shade600),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFD8D8D8),
                                                          )),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(18),
                                                          borderSide:
                                                              BorderSide(
                                                            color: Color(
                                                                0xFFD8D8D8),
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
                                          text: 'BUY',
                                          width: 200,
                                          height: 50,
                                          onpressed: () async {
                                            double amt =
                                                (double.tryParse(amount.text)! /
                                                            lastPrice)
                                                        .floor() *
                                                    lastPrice;
                                            var hol =
                                                (double.tryParse(amount.text)! /
                                                        lastPrice)
                                                    .floor();

                                            String rubiz1 =
                                                await fetchData(user_id);
                                            double num2 = double.parse(rubiz1);
                                            if (num2<amt){
                                              showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                        backgroundColor: Colors.grey
                                                            .shade800, // Background color of the dialog
                                                        title: Text(
                                                          'NOT ENOUGH RUBIES, GET THEM FROM HOME',
                                                          style: TextStyle(
                                                            fontFamily: 'Raleway',
                                                            fontSize: 18,
                                                            color: Color(0xFFD8D8D8),
                                                            fontWeight:
                                                            FontWeight.w900,
                                                          ),
                                                        ));
                                                  }).then((value) {
                                                // Close the AlertDialog after 2 seconds
                                                Future.delayed(Duration(seconds: 2), () {
                                                  Navigator.of(context).pop();
                                                });
                                              });

                                            }
                                            else{
                                              amt = num2 - amt;

                                              upadaterub(user_id,
                                                  amt.toStringAsFixed(4));

                                              var result = await buying(
                                                  user_id,
                                                  widget.stockid,
                                                  amt.toString(),
                                                  hol);
                                              if (result == 'done') {
                                                Navigator.pop(context);
                                                amount.text = '';
                                                holdings.text = '';
                                                showDialog(
                                                  context: context,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor: Colors.grey.shade800,
                                                      title: Text(
                                                        'SUCCESSFULLY ADDED',
                                                        style: TextStyle(
                                                          fontFamily: 'Raleway',
                                                          fontSize: 18,
                                                          color: Color(0xFFD8D8D8),
                                                          fontWeight: FontWeight.w900,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ).then((value) {
                                                  // Close the AlertDialog after 2 seconds
                                                  Future.delayed(Duration(seconds: 2), () {
                                                    Navigator.of(context).pop();
                                                  });
                                                });
                                              }
                                            }

                                          }),
                                      Container(
                                        height: 200,
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          }),
                      Spacer(),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ]));
  }
}

class _SalesData {
  _SalesData(this.date, this.prevclose);

  final String date;
  final double prevclose;
}

class StockData {
  final String date;
  final double prevClose;

  StockData({
    required this.date,
    required this.prevClose,
  });

  factory StockData.fromJson(Map<String, dynamic> json) {
    if (json['date'] is String && json['prevclose'] is double) {
      return StockData(
        date: json['date'],
        prevClose: json['prevclose'],
      );
    } else {
      throw FormatException('Invalid data format in JSON.');
    }
  }
}