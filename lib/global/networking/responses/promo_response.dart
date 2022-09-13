import 'package:ui_test/global/models/promo_code_model.dart';

class PromoResponse {
  String? message;
  bool? error;
  Promo? promo;

  PromoResponse({this.message, this.error, this.promo});

  PromoResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    error = json['error'];
    promo = Promo.fromJson(json['promo']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (message != null) {
      data['message'] = message;
    }
    if (error != null) {
      data['error'] = error;
    }
    if (promo != null) {
      data['promo'] = promo!.toJson();
    }
    return data;
  }
}