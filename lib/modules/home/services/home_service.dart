import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
      if(response.statusCode == 200){
        return HomeResponse.fromJson(response.data);
      }else{
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
      if(response.statusCode == 200){
        return ProductsResponse.fromJson(response.data);
      }else{
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
