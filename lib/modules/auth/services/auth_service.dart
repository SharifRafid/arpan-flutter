import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../global/models/tokens_model.dart';
import '../../../global/networking/responses/default_response.dart';
import '../../../global/networking/responses/login_response.dart';
import '../../../global/utils/constants.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<Tokens?> refreshTokens(String refreshToken) async {
    Box box = Hive.box("authBox");
    try {
      Response response = await _dio.post(
        "${baseUrl}auth/refresh",
        data: {'refreshToken': refreshToken},
      );
      //returns the successful user data json object
      if (response.statusCode == 401) {
        await box.put("accessToken", "");
        await box.put("refreshToken", "");
      }
      try {
        Tokens tokens = Tokens.fromJson(response.data);
        debugPrint("AccessToken : ${tokens.access!.token}");
        debugPrint("RefreshToken : ${tokens.refresh!.token}");
        await box.put("accessToken", tokens.access!.token.toString());
        await box.put("refreshToken", tokens.refresh!.token.toString());
        return tokens;
      } catch (e) {
        if (response.statusCode == 401) {
          await box.put("accessToken", "");
          await box.put("refreshToken", "");
        }
        debugPrint(e.toString());
        return null;
      }
    } on DioError catch (e) {
      if (e.response?.statusCode == 401) {
        await box.put("accessToken", "");
        await box.put("refreshToken", "");
      }
      //returns the error object if any
      debugPrint(e.message);
      return null;
    }
  }

  Future<LoginResponse> getLoginResponse(String phone, String otp) async {
    try {
      Response response = await _dio.post(
        "${baseUrl}auth/login-with-phone",
        data: {'phone': phone, 'otp': otp},
      );
      //returns the successful user data json object
      return LoginResponse.fromJson(response.data);
    } on DioError catch (e) {
      //returns the error object if any
      return LoginResponse(user: null, tokens: null);
    }
  }

  Future<DefaultResponse> getSendOTPResponse(
      String phone, String signature) async {
    try {
      Response response = await _dio.post(
        "${baseUrl}auth/send-otp",
        data: {'phone': phone, 'signature': signature},
      );
      //returns the successful user data json object
      return DefaultResponse.fromJson(response.data);
    } on DioError catch (e) {
      //returns the error object if any
      return DefaultResponse(error: true, message: e.message.toString());
    }
  }
}
