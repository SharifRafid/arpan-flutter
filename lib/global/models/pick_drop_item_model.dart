
class PickDropOrderItem {
  String? key;
  String? parcelDetails;
  String? parcelImage;
  String? paymentType;
  String? recieverAddress;
  String? recieverLocation;
  String? recieverName;
  String? recieverPhone;
  String? senderAddress;
  String? senderLocation;
  String? senderName;
  String? senderPhone;

  PickDropOrderItem(
      {this.key,
        this.parcelDetails,
        this.parcelImage,
        this.paymentType,
        this.recieverAddress,
        this.recieverLocation,
        this.recieverName,
        this.recieverPhone,
        this.senderAddress,
        this.senderLocation,
        this.senderName,
        this.senderPhone});

  PickDropOrderItem.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    parcelDetails = json['parcelDetails'];
    parcelImage = json['parcelImage'];
    paymentType = json['paymentType'];
    recieverAddress = json['recieverAddress'];
    recieverLocation = json['recieverLocation'];
    recieverName = json['recieverName'];
    recieverPhone = json['recieverPhone'];
    senderAddress = json['senderAddress'];
    senderLocation = json['senderLocation'];
    senderName = json['senderName'];
    senderPhone = json['senderPhone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['parcelDetails'] = this.parcelDetails;
    data['parcelImage'] = this.parcelImage;
    data['paymentType'] = this.paymentType;
    data['recieverAddress'] = this.recieverAddress;
    data['recieverLocation'] = this.recieverLocation;
    data['recieverName'] = this.recieverName;
    data['recieverPhone'] = this.recieverPhone;
    data['senderAddress'] = this.senderAddress;
    data['senderLocation'] = this.senderLocation;
    data['senderName'] = this.senderName;
    data['senderPhone'] = this.senderPhone;
    return data;
  }
}