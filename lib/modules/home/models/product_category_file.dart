import 'package:Arpan/global/models/product_model.dart';

class ProductCategorized {
  String id;
  String name;
  int order = 0;
  List<Product> products;

  ProductCategorized({
    required this.id,
    required this.name,
    required this.order,
    required this.products,
  });
}