import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradesimulate/screens/portfolio.dart';
import 'package:tradesimulate/screens/search.dart';
import 'package:tradesimulate/screens/stocks.dart';
import 'package:tradesimulate/screens/watchlist.dart';
import 'package:tradesimulate/global.dart';
import 'homepage.dart';

class bottomnav extends StatefulWidget {
  const bottomnav({Key? key}) : super(key: key);

  @override
  State<bottomnav> createState() => _bottomnavState();
}

class _bottomnavState extends State<bottomnav> {
  @override
  void initState() {
    super.initState();
  }

  List pages = [
    watchlist(),
    homepage(),
    searching(),
    portfolio(),
  ];
  int currindex = 1;

  void OnTabChange(int index) {
    setState(() {
      currindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.black,
      centerTitle: true,
      title: SvgPicture.asset('assets/title.svg'),
      automaticallyImplyLeading: false,
    ),
      body: pages[currindex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.black,

        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: GNav(
            onTabChange: OnTabChange,
            backgroundColor: Colors.black,
            color: Color(0xFFFFFFFF),
            activeColor: Color(0xFFFFFFFF),
            tabBackgroundColor: Color(0xFFF666666),
            padding: EdgeInsets.all(12),
            gap: 5,
            selectedIndex: currindex,
            tabs: [
              GButton(
                icon: Icons.bar_chart_rounded,
                text: 'watchlist',
              ),
              GButton(
                icon: Icons.home,
                text: 'home',
              ),
              GButton(
                icon: Icons.search,
                text: 'search',
              ),
              GButton(
                icon: Icons.currency_rupee_rounded,
                text: 'portfolio',

              ),
            ],
          ),
        ),
      ),
    );
  }
}
