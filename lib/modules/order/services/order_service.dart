import 'dart:collection';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_test/global/networking/responses/promo_response.dart';
import '../../../global/utils/constants.dart';
import '../models/order_item_response.dart';

class OrderService {
  final Dio _dio = Dio();

  Future<PromoResponse> validatePromoCode(String code) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> data = HashMap();
      data["code"] = code;
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response = await _dio.post("${baseUrl}consumers/validate-promo",
          options: options, data: data);
      if (response.statusCode == 200) {
        return PromoResponse.fromJson(response.data);
      } else {
        return PromoResponse(error: true, message: response.data.toString());
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return PromoResponse(
          error: true, message: e.response!.statusMessage.toString());
    }
  }

  Future<List<OrderItemResponse>?> getOrders() async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response =
          await _dio.get("${baseUrl}consumers/get-orders", options: options);
      if (response.statusCode == 200) {
        if (response.data != null) {
          List<OrderItemResponse> orders = (response.data as List)
              .map((item) => OrderItemResponse.fromJson(item))
              .toList();
          return orders;
        } else {
          return null;
        }
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

  Future<OrderItemResponse?> getOrderById(String id) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response =
          await _dio.get("${baseUrl}consumers/get-order-by-id/$id", options: options);
      if (response.statusCode == 200) {
        if (response.data != null) {
          return OrderItemResponse.fromJson(response. data);
        } else {
          return null;
        }
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

  Future<OrderItemResponse?> getLastOrder() async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response = await _dio.get("${baseUrl}consumers/get-last-order", options: options);
      if (response.statusCode == 200) {
        if (response.data != null) {
          OrderItemResponse orders = OrderItemResponse.fromJson(response.data);
          return orders;
        } else {
          return null;
        }
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

  Future<String?> placeOrder(HashMap<String, dynamic> hashMap) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response = await _dio.post("${baseUrl}consumers/place-order",
          options: options, data: hashMap);
      if (response.statusCode == 200) {
        return response.data['id'].toString();
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

  Future<String?> placeCustomOrder(
      HashMap<String, dynamic> hashMap, XFile? image) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    HashMap<String, String> headers = HashMap();
    headers["authorization"] = "Bearer $accessToken";
    headers["Content-Type"] = "application/json";
    Options options = Options(headers: headers);
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
          hashMap["image"] = response.data;
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
      Response response = await _dio.post(
          "${baseUrl}consumers/place-custom-order",
          options: options,
          data: hashMap);
      if (response.statusCode == 200) {
        return response.data['id'].toString();
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

  Future<String?> cancelOrder(String id) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String, String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(headers: headers);
      Response response = await _dio.post("${baseUrl}consumers/cancel-order/$id",
          options: options);
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
}
