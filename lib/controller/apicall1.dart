import 'dart:convert';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tradesimulate/screens/homepage.dart';



class signupcontrol extends GetxController {
  static signupcontrol get instance => Get.find();
  var verificationid = ''.obs;
  var phone = '';

drinks(id) async {
  var request = http.MultipartRequest('GET', Uri.parse('http://192.168.73.229:8000/drinks/'+id));


  http.StreamedResponse response = await request.send();

  var dat = await response.stream.bytesToString();
  var resp=jsonDecode(dat);

  if(response.statusCode==200){
      print(resp["details"]['name']);
      print(resp);

      var perf=await SharedPreferences.getInstance();
      perf.setString("drinkname", resp["details"]["name"]);

      Get.to(homepage());
  }

}
}