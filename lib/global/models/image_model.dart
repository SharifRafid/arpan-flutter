class Image {
  String? name;
  String? type;
  String? path;
  String? id;

  Image({this.name, this.type, this.path, this.id});

  Image.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    type = json['type'];
    path = json['path'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['type'] = type;
    data['path'] = path;
    data['id'] = id;
    return data;
  }
}
