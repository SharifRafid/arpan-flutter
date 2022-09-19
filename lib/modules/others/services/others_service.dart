import 'dart:collection';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../global/utils/constants.dart';

class OthersService {
  final Dio _dio = Dio();

  Future<String?> submitFeedback(HashMap<String, dynamic> hashMap) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response = await _dio.post("${baseUrl}consumers/provide-feedback",
          options: options, data: hashMap);
      if (response.statusCode == 200) {
        return response.data.toString();
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return null;
    }
  }
  Future<HashMap<String, dynamic>?> getProfile() async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response = await _dio.get("${baseUrl}consumers/get-profile",
          options: options);
      if (response.statusCode == 200) {
        return HashMap<String, dynamic>.from(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return null;
    }
  }
  Future<String?> updateProfile(HashMap<String, dynamic> data, XFile? image) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    HashMap<String, String> headers = HashMap();
    headers["authorization"] = "Bearer $accessToken";
    headers["Content-Type"] = "application/json";
    headers["path"] = "userProfiles";
    Options options = Options(headers: headers);
    String result = "";
    if (image != null) {
      try {
        File file = File(image.path);
        String fileName = file.path.split('/').last;
        FormData formData = FormData.fromMap({
          "fileName": await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType("image", "jpeg"), //important
          )
        });
        Response response = await _dio.post("${baseUrl}file/upload-user",
            data: formData, options: options);
        if(response.data != null){
          result = response.data;
          data["image"] = response.data;
        }else{
          return null;
        }
      } on DioError catch (e) {
        if (kDebugMode) {
          print(e.message.toString());
        }
        return null;
      }
    }
    try {
      Response response = await _dio.patch("${baseUrl}consumers/update-profile",
          options: options, data: data);
      if (response.statusCode == 200) {
        return response.data;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return null;
    }
  }
}
