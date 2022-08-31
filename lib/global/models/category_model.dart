class Category {
  String? name;
  int? order;
  String? id;

  Category({this.name, this.order, this.id});

  Category.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    order = json['order'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['order'] = order;
    data['id'] = id;
    return data;
  }
}