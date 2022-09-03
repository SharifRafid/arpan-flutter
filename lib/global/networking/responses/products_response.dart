import '../../models/category_model.dart';
import '../../models/product_model.dart';
import '../../models/shop_model.dart';

class ProductsResponse {
  Shop? shop;
  List<Category>? shopCategories;
  List<Product>? products;

  ProductsResponse({this.shop, this.shopCategories, this.products});

  ProductsResponse.fromJson(Map<String, dynamic> json) {
    shop = json['shop'] != null ? new Shop.fromJson(json['shop']) : null;
    if (json['shopCategories'] != null) {
      shopCategories = <Category>[];
      json['shopCategories'].forEach((v) {
        shopCategories!.add(new Category.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = <Product>[];
      json['products'].forEach((v) {
        products!.add(new Product.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.shop != null) {
      data['shop'] = this.shop!.toJson();
    }
    if (this.shopCategories != null) {
      data['shopCategories'] =
          this.shopCategories!.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}