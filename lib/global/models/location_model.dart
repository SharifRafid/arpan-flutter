class Location {
  int? deliveryCharge;
  String? locationName;
  int? daCharge;
  int? deliveryChargeClient;
  int? deliveryChargePickDrop;
  int? daChargePickDrop;
  int? order;
  String? id;

  Location(
      {this.deliveryCharge,
      this.locationName,
      this.daCharge,
      this.deliveryChargeClient,
      this.deliveryChargePickDrop,
      this.daChargePickDrop,
      this.order,
      this.id});

  Location.fromJson(Map<String, dynamic> json) {
    deliveryCharge = json['deliveryCharge'];
    locationName = json['locationName'];
    daCharge = json['daCharge'];
    deliveryChargeClient = json['deliveryChargeClient'];
    deliveryChargePickDrop = json['deliveryChargePickDrop'];
    daChargePickDrop = json['daChargePickDrop'];
    order = json['order'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['deliveryCharge'] = this.deliveryCharge;
    data['locationName'] = this.locationName;
    data['daCharge'] = this.daCharge;
    data['deliveryChargeClient'] = this.deliveryChargeClient;
    data['deliveryChargePickDrop'] = this.deliveryChargePickDrop;
    data['daChargePickDrop'] = this.daChargePickDrop;
    data['order'] = this.order;
    data['id'] = this.id;
    return data;
  }
}