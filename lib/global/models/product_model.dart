class Product {
  bool? inStock;
  bool? offerActive;
  List<String>? categories;
  String? name;
  int? order;
  String? shortDescription;
  String? description;
  String? offerDetails;
  String? coverPhoto;
  String? icon;
  int? price;
  int? offerPrice;
  int? arpanCharge;
  String? shop;
  String? id;

  Product(
      {this.inStock,
        this.offerActive,
        this.categories,
        this.name,
        this.order,
        this.shortDescription,
        this.description,
        this.offerDetails,
        this.coverPhoto,
        this.icon,
        this.price,
        this.offerPrice,
        this.arpanCharge,
        this.shop,
        this.id});

  Product.fromJson(Map<String, dynamic> json) {
    inStock = json['inStock'];
    offerActive = json['offerActive'];
    // categories = json['categories'].cast<String>();
    name = json['name'];
    order = json['order'];
    shortDescription = json['shortDescription'];
    description = json['description'];
    offerDetails = json['offerDetails'];
    coverPhoto = json['coverPhoto'];
    icon = json['icon'];
    price = json['price'];
    offerPrice = json['offerPrice'];
    arpanCharge = json['arpanCharge'];
    shop = json['shop'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['inStock'] = inStock;
    data['offerActive'] = offerActive;
    data['categories'] = categories;
    data['name'] = name;
    data['order'] = order;
    data['shortDescription'] = shortDescription;
    data['description'] = description;
    data['offerDetails'] = offerDetails;
    data['coverPhoto'] = coverPhoto;
    data['icon'] = icon;
    data['price'] = price;
    data['offerPrice'] = offerPrice;
    data['arpanCharge'] = arpanCharge;
    data['shop'] = shop;
    data['id'] = id;
    return data;
  }
}