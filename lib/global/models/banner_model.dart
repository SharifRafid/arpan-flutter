class Banner {
  int? order;
  String? icon;

  Banner({this.order, this.icon});

  Banner.fromJson(Map<String, dynamic> json) {
    order = json['order'];
    icon = json['icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order'] = order;
    data['icon'] = icon;
    return data;
  }
}