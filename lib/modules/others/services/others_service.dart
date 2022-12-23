import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import '../../../global/models/settings_model.dart';
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

  Future<Settings?> getSettings() async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response = await _dio.get("${baseUrl}consumers/get-settings",
          options: options);
      if (response.statusCode == 200) {
        return Settings.fromJson(response.data);
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
        MultipartFile multipartFile;
        if(kIsWeb){
          Uint8List bytes = await image.readAsBytes();
          multipartFile = MultipartFile.fromBytes(bytes, filename: fileName,
            contentType: MediaType("image", "jpeg"));
        }else{
          multipartFile = await MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType("image", "jpeg"), //important
          );
        }
        FormData formData = FormData.fromMap({
          "fileName": multipartFile
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
        return result;
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

  Future<String?> addRegistrationToken(HashMap<String, dynamic> hashMap) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response = await _dio.post("${baseUrl}users/registration-tokens",
          options: options, data: hashMap);
      if (response.statusCode == 200) {
        return "SUCCESS";
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
  Future<String?> logout(HashMap<String, dynamic> hashMap, String accessToken) async {
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response = await _dio.post("${baseUrl}auth/logout",
          options: options, data: hashMap);
      if (response.statusCode == 200) {
        debugPrint("LOGGED OUT");
        return "SUCCESS";
      } else {
        debugPrint("LOG OUT FAILED");
        return null;
      }
    } on DioError catch (e) {
      debugPrint("LOG OUT FAILED");
      if (kDebugMode) {
        print(e.message.toString());
      }
      return null;
    }
  }


}
