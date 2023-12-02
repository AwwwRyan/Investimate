import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tradesimulate/screens/bottomnav.dart';
import 'package:http/http.dart' as http;
import 'package:tradesimulate/screens/stocks.dart';
import 'package:tradesimulate/global.dart';

class searching extends StatefulWidget {
  const searching({Key? key}) : super(key: key);

  @override
  State<searching> createState() => _searchingState();
}

class _searchingState extends State<searching> {
  @override
  Future<List<search>> getSearchData(searchstr) async {
    List<search> searchlist = [];
    print(global.url);
    var request = http.Request(
        'GET', Uri.parse(global.url+'/searching/$searchstr'));

    http.StreamedResponse response = await request.send();
    var data = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      var a = jsonDecode(data.toString());

      for (Map i in a) {
        String stockId = i['stoc_id'] ?? ''; // If 'stock_id' is 'null', use an empty string
        double lastPrice = i['last_price'] ?? 0.0; // If 'lastPrice' is 'null', use 0.0
        double pChange = i['percent_change'] ?? 0.0; // If 'pChange' is 'null', use 0.0

        search s = search(
          stock_id: stockId,
          lastPrice: lastPrice,
          pChange: pChange,
        );

        searchlist.add(s);
      }

      // Print the values in searchlist to the console
      print("Values in searchlist:");
      searchlist.forEach((item) {
        print("Stock ID: ${item.stock_id}, Last Price: ${item.lastPrice}, PChange: ${item.pChange}");
      });

      return searchlist;
    } else {
      print(response.reasonPhrase);
    }

    return searchlist;
  }

  var t=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF000000),
      body: WillPopScope(onWillPop: () async{
        Get.offAll(bottomnav());
        return false;
      },
      child:SingleChildScrollView( scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Search bar
            Container(
              width: MediaQuery.sizeOf(context).width - 40,
              child: TextField(
                controller: t,
                style: TextStyle(color: Color(0xFFD8D8D8), fontSize: 24),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.white),
                  hintText: 'SEARCH',
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  fillColor: Color(0xFFD8D8D8),
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
                ),
                onChanged: (value) {
                  setState(() {
                    //searchQuery = value;
                  });
                },
              ),
            ),
            //builder
            Container(width: MediaQuery.sizeOf(context).width,
              height: MediaQuery.sizeOf(context).height-242,
              color: Colors.black,
              child: Column(
                children: [
                  FutureBuilder<List<search>>(
                    future: getSearchData(t.text),
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
                        List<search>? searchlist = snapshot.data;

                        return Expanded(
                          child: ListView.builder(
                            itemCount: searchlist?.length,
                            itemBuilder: (context, index) {
                              search? data = searchlist?[index];

                              return Column(
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => stocks(stockid: data.stock_id)));},
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: MediaQuery.of(context).size.width/3,
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
                                          width: MediaQuery.of(context).size.width / 3-40,
                                        ),
                                        Container(

                                          child: Center(

                                            child: Text(
                                              data?.pChange?.toStringAsFixed(2) ?? 'N/A',
                                              style: TextStyle(
                                                fontFamily: 'Raleway',
                                                fontSize: 21,
                                                color: Color(0xFFD8D8D8),
                                              ),
                                            ),
                                          ),
                                          width: MediaQuery.of(context).size.width / 3,
                                        ),

                                      ],
                                    ),
                                  ),
                                  Divider( // Add a Divider between each row
                                    color: Colors.grey.shade800,
                                    thickness: 0.5,
                                  ),
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

            // List of items


          ],
        ),),)
    );
  }
}

class search{
  String stock_id;
  double lastPrice,pChange;
  search(
  {
    required this.stock_id,
    required this.lastPrice,
    required this.pChange,
}
      );
}
