import '../../models/banner_model.dart';
import '../../models/category_model.dart';
import '../../models/notice_model.dart';
import '../../models/settings_model.dart';
import '../../models/shop_model.dart';

class HomeResponse {
  List<Shop>? shops;
  List<Category>? shopCategories;
  List<Banner>? banners;
  List<Notices>? notices;
  Settings? settings;

  HomeResponse(
      {this.shops,
        this.shopCategories,
        this.banners,
        this.notices,
        this.settings});

  HomeResponse.fromJson(Map<String, dynamic> json) {
    if (json['shops'] != null) {
      shops = <Shop>[];
      json['shops'].forEach((v) {
        shops!.add(Shop.fromJson(v));
      });
    }
    if (json['shopCategories'] != null) {
      shopCategories = <Category>[];
      json['shopCategories'].forEach((v) {
        shopCategories!.add(Category.fromJson(v));
      });
    }
    if (json['banners'] != null) {
      banners = <Banner>[];
      json['banners'].forEach((v) {
        banners!.add(Banner.fromJson(v));
      });
    }
    if (json['notices'] != null) {
      notices = <Notices>[];
      json['notices'].forEach((v) {
        notices!.add(Notices.fromJson(v));
      });
    }
    settings = json['settings'] != null
        ? Settings.fromJson(json['settings'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shops != null) {
      data['shops'] = shops!.map((v) => v.toJson()).toList();
    }
    if (shopCategories != null) {
      data['shopCategories'] =
          shopCategories!.map((v) => v.toJson()).toList();
    }
    if (banners != null) {
      data['banners'] = banners!.map((v) => v.toJson()).toList();
    }
    if (notices != null) {
      data['notices'] = notices!.map((v) => v.toJson()).toList();
    }
    if (settings != null) {
      data['settings'] = settings!.toJson();
    }
    return data;
  }
}