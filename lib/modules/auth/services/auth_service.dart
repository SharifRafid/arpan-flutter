import 'package:dio/dio.dart';
import '../../../global/models/tokens_model.dart';
import '../../../global/networking/responses/default_response.dart';
import '../../../global/networking/responses/login_response.dart';
import '../../../global/utils/constants.dart';

class AuthService {
  final Dio _dio = Dio();

  Future<Tokens> refreshTokens(String refreshToken) async {
    try {
      Response response = await _dio.post(
        "${baseUrl}auth/refresh",
        data: {'refreshToken': refreshToken},
      );
      //returns the successful user data json object
      return Tokens.fromJson(response.data);
    } on DioError catch (e) {
      //returns the error object if any
      return e.response!.data;
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
      return e.response!.data;
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
      return e.response!.data;
    }
  }
}
