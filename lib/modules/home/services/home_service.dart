import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ui_test/global/models/location_model.dart';
import 'package:ui_test/global/utils/router.dart';
import 'package:ui_test/main.dart';
import '../../../global/networking/responses/home_response.dart';
import '../../../global/networking/responses/products_response.dart';
import '../../../global/utils/constants.dart';

class HomeService {
  final Dio _dio = Dio();

  Future<HomeResponse?> getHomeDataMain() async {
    try {
      Response response = await _dio.get(
        "${baseUrl}exposed-routes/home-data",
      );
      if (response.statusCode == 200) {
        return HomeResponse.fromJson(response.data);
      }else if (response.statusCode == 401) {
        Box box = Hive.box("authBox");
        await box.put("accessToken", "");
        await box.put("refreshToken", "");
        navigatorKey.currentState?.pushNamedAndRemoveUntil(Routes.splash,
                (Route<dynamic> route) => false);
        return null;
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      //returns the error object if any
      return null;
    }
  }

  Future<List<Location>?> getLocationDataMain() async {
    try {
      Response response = await _dio.get(
        "${baseUrl}exposed-routes/locations-main",
      );
      if (response.statusCode == 200) {
        if (response.data != null) {
          List<Location> locations = (response.data as List)
              .map((item) => Location.fromJson(item))
              .toList();
          return locations;
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
      //returns the error object if any
      return null;
    }
  }

  Future<ProductsResponse?> getProductsOfShop(String shopId) async {
    try {
      Response response = await _dio.get(
        "${baseUrl}exposed-routes/products/$shopId",
      );
      if (response.statusCode == 200) {
        return ProductsResponse.fromJson(response.data);
      } else {
        return null;
      }
    } on DioError catch (e) {
      if (kDebugMode) {
        print(e.message.toString());
      }
      //returns the error object if any
      return null;
    }
  }
}
