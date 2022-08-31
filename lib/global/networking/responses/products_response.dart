import '../../models/product_model.dart';
import '../../models/shop_model.dart';

class ProductsResponse {
  Shop? shop;
  List<Product>? products;

  ProductsResponse({this.shop, this.products});

  ProductsResponse.fromJson(Map<String, dynamic> json) {
    shop = json['shop'] != null ? Shop.fromJson(json['shop']) : null;
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (shop != null) {
      data['shop'] = shop!.toJson();
    }
    if (products != null) {
      data['products'] = products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
