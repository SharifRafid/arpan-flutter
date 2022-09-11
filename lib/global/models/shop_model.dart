class Shop {
  bool? isClient;
  bool? open;
  List<String>? categories;
  List<String>? productCategories;
  String? name;
  int? order;
  String? dynamicLink;
  String? coverPhoto;
  String? icon;
  String? activeHours;
  String? location;
  int? deliveryCharge;
  int? daCharge;
  List<Notices>? notices;
  String? id;

  Shop(
      {this.isClient,
      this.open,
      this.categories,
      this.productCategories,
      this.name,
      this.order,
      this.dynamicLink,
      this.coverPhoto,
      this.icon,
      this.activeHours,
      this.location,
      this.deliveryCharge,
      this.daCharge,
      this.notices,
      this.id});

  Shop.fromJson(Map<String, dynamic> json) {
    isClient = json['isClient'];
    open = json['open'];
    if (json['productCategories'] != null) {
      productCategories = json['productCategories'].cast<String>();
    }
    if (json['categories'] != null) {
      categories = json['categories'].cast<String>();
    }
    name = json['name'];
    order = json['order'];
    dynamicLink = json['dynamicLink'];
    coverPhoto = json['coverPhoto'];
    icon = json['icon'];
    activeHours = json['activeHours'];
    location = json['location'];
    deliveryCharge = json['deliveryCharge'];
    daCharge = json['daCharge'];
    if (json['notices'] != null) {
      notices = <Notices>[];
      json['notices'].forEach((v) {
        notices!.add(Notices.fromJson(v));
      });
    }
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['isClient'] = isClient;
    data['open'] = open;
    data['categories'] = categories;
    data['productCategories'] = productCategories;
    data['name'] = name;
    data['order'] = order;
    data['dynamicLink'] = dynamicLink;
    data['coverPhoto'] = coverPhoto;
    data['icon'] = icon;
    data['activeHours'] = activeHours;
    data['location'] = location;
    data['deliveryCharge'] = deliveryCharge;
    data['daCharge'] = daCharge;
    if (notices != null) {
      data['notices'] = notices!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    return data;
  }
}

class Notices {
  String? sId;
  String? bgColor;
  String? color;
  String? title;

  Notices({this.sId, this.bgColor, this.color, this.title});

  Notices.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    bgColor = json['bgColor'];
    color = json['color'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['bgColor'] = bgColor;
    data['color'] = color;
    data['title'] = title;
    return data;
  }
}