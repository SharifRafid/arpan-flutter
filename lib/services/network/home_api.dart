import 'dart:convert';

import 'package:arpan_app_new/data/models/home_response.dart';
import 'package:http/http.dart' as http;

class HomeApi{

  Future<http.Response> fetchHomeData(){
    return http.get(Uri.parse("http://192.168.0.9:8001/api/home"));
  }

  void getHomeResponse({required Function callBack}) async{
    final response = await fetchHomeData();
    if(response.statusCode == 200){
      final homeResponse = HomeResponse.fromJson(jsonDecode(response.body));
      callBack(homeResponse);
    }else{
      callBack(null);
    }
  }

}