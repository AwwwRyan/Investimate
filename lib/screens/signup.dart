import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradesimulate/reusable/authbuttons.dart';
import 'package:tradesimulate/reusable/textfield.dart';
import 'package:tradesimulate/screens/bottomnav.dart';
import 'package:tradesimulate/screens/login.dart';
import 'package:tradesimulate/screens/welcome1.dart';
import 'package:tradesimulate/screens/welcome2.dart';
import 'homepage.dart';
import 'package:http/http.dart' as http;
import 'package:tradesimulate/global.dart';

class signup extends StatefulWidget {
   signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController id = TextEditingController();

  TextEditingController username = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController dob = TextEditingController();

   DateTime selectedDate = DateTime.now();


  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            primaryColor: Colors.black, // Change primary color to black
            hintColor: Colors.black, // Change accent color to black
            dialogBackgroundColor: Colors.grey.shade600, // Set the background color to grey.shade600
            iconTheme: IconThemeData(color: Colors.white),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
        dob.text = '${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}';
      });
    }
  }

   Future<void> signupAndValidate(BuildContext context) async {
     if (id.text.length != 10) {
       showErrorDialog(context, 'Mobile number must be 10 digits.');
     } else if (username.text.isEmpty) {
       showErrorDialog(context, 'Username cannot be left blank.');
     } else if (dob.text.isEmpty) {
       showErrorDialog(context, 'Date of Birth cannot be left blank.');
     } else if (!_isPasswordValid(password.text)) {
       showErrorDialog(context,
           'Password must contain at least 8 characters with one uppercase letter, one special character, and one number.');
     } else {
       // If all validations pass, proceed with signup
       var result = await signupuser(id.text, username.text, password.text, dob.text);
       print(result);
       if (result == 1) {

         SharedPreferences prefs = await SharedPreferences.getInstance();
         prefs.setString('user_id', id.text);

         Navigator.push(context, MaterialPageRoute(builder: (context) => welcomeone()));
       }
     }
   }

   bool _isPasswordValid(String password) {
     bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
     bool hasDigit = password.contains(RegExp(r'[0-9]'));
     bool hasSpecialChar = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
     bool hasMinLength = password.length >= 8;

     return hasUppercase && hasDigit && hasSpecialChar && hasMinLength;
   }

   void showErrorDialog(BuildContext context, String message) {
     showDialog(
       context: context,
       builder: (BuildContext context) {
         return AlertDialog(
           backgroundColor: Colors.grey
               .shade800,
           title: Text('Invalid Information',style: TextStyle(
             fontFamily: 'Raleway',
             fontSize: 18,
             color: Colors.white,
             fontWeight: FontWeight.w900,
           ),),
           content: Text(message,style: TextStyle(
             fontFamily: 'Raleway',
             fontSize: 18,
             color: Color(0xFFD8D8D8),
             fontWeight: FontWeight.w900,
           ),),
           actions: [
             TextButton(
               onPressed: () {
                 Navigator.of(context).pop();
               },
               child: Text('OK'),
             ),
           ],
         );
       },
     );
   }

signupuser(id,username,password,dob) async {
  var request = http.MultipartRequest('POST', Uri.parse(global.url+'/regipage/'));
  request.fields.addAll({
    'id': id,
    'username': username,
    'password': password,
    'dob': dob
  });

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    var resp=await response.stream.bytesToString();
    var res=jsonDecode(resp);
    return res["status"];
  }
  else {
    print(response.reasonPhrase);
  }
return '';
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF141414),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 50,
            ),
            SvgPicture.asset('assets/illustration.svg'),
            Container(
              height: 15,
            ),
            SvgPicture.asset('assets/inverstimate.svg'),
            Container(
              height: 35,
            ),
            textfield(keyboardtype: TextInputType.phone,hinttext: 'Mobile Number',t: id),
            Container(
              height: 18,
            ),
            textfield(keyboardtype: TextInputType.text,hinttext: 'Username',t: username),
            Container(
              height: 18,
            ),
            textfield(keyboardtype: TextInputType.text,hinttext: 'Password',t: password),
            Container(
              height: 18,
            ),

          Container(
            width: 300,
            child: TextFormField(
              controller: dob,
              readOnly: true,
              keyboardType: TextInputType.datetime,
              style: TextStyle(color: Color(0xFFD8D8D8), fontSize: 24),

              decoration: InputDecoration(
                hintText: 'YYYY-MM-DD',
                hintStyle: TextStyle(color: Colors.grey.shade600),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Color(0xFFD8D8D8),
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide(
                    color: Color(0xFFD8D8D8),
                  ),
                ),
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () {
                    _selectDate(context);
                  },
                ),
              ),
            ),
          ),
          Container(
            height: 18,
          )
,

          authbuttons(
                backgroundcolor: Color(0xFF0CF2B4),
                textcolor: Color(0xFFD8D8D8),
                text: 'GET STARTED',
                width: 200,
                height: 50,
                onpressed: () async {
                  signupAndValidate(context);


                }),
          ],
        ),
      ),
    );
  }
}
