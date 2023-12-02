import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradesimulate/controller/apicall1.dart';
import 'package:tradesimulate/reusable/authbuttons.dart';
import 'package:tradesimulate/reusable/textfield.dart';
import 'package:tradesimulate/screens/bottomnav.dart';
import 'package:http/http.dart' as http;
import 'package:tradesimulate/global.dart';
import 'signup.dart';

class loginscreen extends StatefulWidget {
  loginscreen({Key? key}) : super(key: key);

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  @override
  void initState() {
    super.initState();
  }

  var abc = Get.put(signupcontrol());

  TextEditingController id = TextEditingController();
  TextEditingController password = TextEditingController();

   loginUser(String id, String password) async {
    var request = http.MultipartRequest('POST', Uri.parse(global.url+'/loginpage/'));
    request.fields.addAll({
      'id': id.toString(),
      'password': password,
    });
    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      var resp=await response.stream.bytesToString();
      var res=jsonDecode(resp);
      return res["status"];    }
    else {
      print(response.reasonPhrase);
    }
return " ";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141414),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              height: 150,
            ),
            SvgPicture.asset('assets/illustration.svg'),
            Container(
              height: 15,
            ),
            SvgPicture.asset('assets/inverstimate.svg'),
            Container(
              height: 30,
            ),

            textfield(keyboardtype: TextInputType.number,hinttext: 'Mobile Number',t: id),
            Container(
              height: 18,
            ),
            textfield(keyboardtype: TextInputType.text, hinttext: 'Password',t: password,),
            Container(
              height: 18,
            ),
            RichText(
              text: TextSpan(children: [
                TextSpan(
                  text: 'Dont have an account?  ',
                  style: TextStyle(
                    fontFamily: 'Raleway',
                    fontSize: 20,
                    color: Color(0xFFD8D8D8),
                  ),
                ),
                TextSpan(
                    text: 'Sign Up',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                      fontSize: 20,
                      color: Colors.blueAccent,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => signup()));
                      }),
              ]),
            ),
            Container(
              height: 18,
            ),

            authbuttons(
                backgroundcolor: Color(0xFF0CF2B4),
                textcolor: Color(0xFFD8D8D8),
                text: 'GET STARTED',
                width: 200,
                height: 50,
                onpressed: () async {

                  var result = await loginUser(id.text, password.text);
                  if (result == 1){

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('user_id', id.text);

                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => bottomnav()));

                  }
                  else if(result == 0){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                          backgroundColor: Colors.grey
                              .shade800, // Background color of the dialog
                          title: Text(
                          'USER DOES NOT EXIST, SIGN UP',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                            color: Color(0xFFD8D8D8),
                            fontWeight: FontWeight.w900,
                          ),)
                      );
                    }
                    );
                  }
                  else{
                          showDialog(context:context, builder: (BuildContext context){
                          return AlertDialog(
                          backgroundColor: Colors.black, // Background color of the dialog
                          title: Text(
                          'INCORRECT PASSWORD',
                          style: TextStyle(
                          fontFamily: 'Raleway',
                          fontSize: 18,
                          color: Color(0xFFD8D8D8),
                          fontWeight: FontWeight.w900,
                          ),)
                          );
                  });
                }}
            ),
          ],
        ),
      ),
    );
  }
}
