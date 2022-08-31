import 'image_model.dart';

class User {
  List<String>? roles;
  List<String>? registrationTokens;
  List<String>? registrationTokensAdmin;
  List<String>? registrationTokensModerator;
  List<String>? registrationTokensDA;
  String? role;
  String? phone;
  String? name;
  String? address;
  Image? image;
  bool? blocked;
  String? email;
  String? password;
  String? id;

  User(
      {this.roles,
      this.registrationTokens,
      this.registrationTokensAdmin,
      this.registrationTokensModerator,
      this.registrationTokensDA,
      this.role,
      this.phone,
      this.name,
      this.address,
      this.image,
      this.blocked,
      this.email,
      this.password,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    roles = json['roles'].cast<String>();
    registrationTokens = json['registrationTokens'].cast<String>();
    registrationTokensAdmin = json['registrationTokensAdmin'].cast<String>();
    registrationTokensModerator =
        json['registrationTokensModerator'].cast<String>();
    registrationTokensDA = json['registrationTokensDA'].cast<String>();
    role = json['role'];
    phone = json['phone'];
    name = json['name'];
    address = json['address'];
    image = json['image'] != null ? Image.fromJson(json['image']) : null;
    blocked = json['blocked'];
    email = json['email'];
    password = json['password'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['roles'] = roles;
    data['registrationTokens'] = registrationTokens;
    data['registrationTokensAdmin'] = registrationTokensAdmin;
    data['registrationTokensModerator'] = registrationTokensModerator;
    data['registrationTokensDA'] = registrationTokensDA;
    data['role'] = role;
    data['phone'] = phone;
    data['name'] = name;
    data['address'] = address;
    if (image != null) {
      data['image'] = image!.toJson();
    }
    data['blocked'] = blocked;
    data['email'] = email;
    data['password'] = password;
    data['id'] = id;
    return data;
  }
}