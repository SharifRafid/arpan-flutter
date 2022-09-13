import 'dart:collection';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:ui_test/global/networking/responses/promo_response.dart';
import '../../../global/utils/constants.dart';
import '../models/order_item_response.dart';

class OrderService {
  final Dio _dio = Dio();

  Future<PromoResponse> validatePromoCode(String code) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String,String> data = HashMap();
      data["code"] = code;
      HashMap<String,String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(
          headers: headers
      );
      Response response = await _dio.post(
          "${baseUrl}consumers/validate-promo",
          options: options,
          data: data
      );
      if (response.statusCode == 200) {
        return PromoResponse.fromJson(response.data);
      } else {
        return PromoResponse(error: true, message: response.data.toString());
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      return PromoResponse(error: true, message: e.response!.statusMessage.toString());
    }
  }

  Future<List<OrderItemResponse>?> getOrders() async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String,String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(
          headers: headers
      );
      Response response = await _dio.get(
          "${baseUrl}consumers/get-orders",
          options: options
      );
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

  Future<String?> placeOrder(HashMap<String, dynamic> hashMap) async {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    try {
      HashMap<String,String> headers = HashMap();
      headers["authorization"] = "Bearer $accessToken";
      headers["Content-Type"] = "application/json";
      Options options = Options(
        headers: headers
      );
      Response response = await _dio.post(
        "${baseUrl}consumers/place-order",
        options: options,
        data: hashMap
      );
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
}
