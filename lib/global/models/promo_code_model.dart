class Promo {
  bool? active;
  bool? bothDiscount;
  bool? deliveryDiscount;
  int? discountPrice;
  String? key;
  int? maxUses;
  int? minimumPrice;
  bool? onceForOneUser;
  String? promoCodeName;
  int? remainingUses;
  bool? shopBased;
  bool? shopDiscount;
  String? shopKey;
  String? shopName;
  int? startDate;
  int? validityOfCode;
  String? id;

  Promo(
      {this.active,
        this.bothDiscount,
        this.deliveryDiscount,
        this.discountPrice,
        this.key,
        this.maxUses,
        this.minimumPrice,
        this.onceForOneUser,
        this.promoCodeName,
        this.remainingUses,
        this.shopBased,
        this.shopDiscount,
        this.shopKey,
        this.shopName,
        this.startDate,
        this.validityOfCode,
        this.id});

  Promo.fromJson(Map<String, dynamic> json) {
    active = json['active'];
    bothDiscount = json['bothDiscount'];
    deliveryDiscount = json['deliveryDiscount'];
    discountPrice = json['discountPrice'];
    key = json['key'];
    maxUses = json['maxUses'];
    minimumPrice = json['minimumPrice'];
    onceForOneUser = json['onceForOneUser'];
    promoCodeName = json['promoCodeName'];
    remainingUses = json['remainingUses'];
    shopBased = json['shopBased'];
    shopDiscount = json['shopDiscount'];
    shopKey = json['shopKey'];
    shopName = json['shopName'];
    startDate = json['startDate'];
    validityOfCode = json['validityOfCode'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['active'] = this.active;
    data['bothDiscount'] = this.bothDiscount;
    data['deliveryDiscount'] = this.deliveryDiscount;
    data['discountPrice'] = this.discountPrice;
    data['key'] = this.key;
    data['maxUses'] = this.maxUses;
    data['minimumPrice'] = this.minimumPrice;
    data['onceForOneUser'] = this.onceForOneUser;
    data['promoCodeName'] = this.promoCodeName;
    data['remainingUses'] = this.remainingUses;
    data['shopBased'] = this.shopBased;
    data['shopDiscount'] = this.shopDiscount;
    data['shopKey'] = this.shopKey;
    data['shopName'] = this.shopName;
    data['startDate'] = this.startDate;
    data['validityOfCode'] = this.validityOfCode;
    data['id'] = this.id;
    return data;
  }
}