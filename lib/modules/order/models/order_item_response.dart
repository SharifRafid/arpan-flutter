import 'package:ui_test/global/models/cart_item_model.dart';

import '../../../global/models/pick_drop_item_model.dart';

class OrderItemResponse {
  String? userName;
  String? paymentMethod;
  String? userAddress;
  String? userNumber;
  String? userNote;
  String? userPhoneAccount;
  String? userId;
  int? orderPlacingTimeStamp;
  String? orderStatus;
  bool? paid;
  bool? paymentCompleted;
  bool? paymentRequested;
  bool? pickDropOrder;
  List<CartItemMain>? products;
  LocationItem? locationItem;
  PromoCode? promoCode;
  bool? promoCodeApplied;
  int? daCharge;
  int? deliveryCharge;
  int? totalPrice;
  int? orderId;
  String? id;
  PickDropOrderItem? pickDropOrderItem;
  String? paymentRequestedNumber;

  OrderItemResponse(
      {this.userName,
        this.paymentMethod,
        this.userAddress,
        this.userNumber,
        this.userNote,
        this.userPhoneAccount,
        this.userId,
        this.orderPlacingTimeStamp,
        this.orderStatus,
        this.paid,
        this.paymentCompleted,
        this.paymentRequested,
        this.pickDropOrder,
        this.products,
        this.locationItem,
        this.promoCode,
        this.promoCodeApplied,
        this.daCharge,
        this.deliveryCharge,
        this.totalPrice,
        this.orderId,
        this.id,
        this.pickDropOrderItem,
        this.paymentRequestedNumber});

  OrderItemResponse.fromJson(Map<String, dynamic> json) {
    userName = json['userName'];
    paymentMethod = json['paymentMethod'];
    userAddress = json['userAddress'];
    userNumber = json['userNumber'];
    userNote = json['userNote'];
    userPhoneAccount = json['userPhoneAccount'];
    userId = json['userId'];
    orderPlacingTimeStamp = json['orderPlacingTimeStamp'];
    orderStatus = json['orderStatus'];
    paid = json['paid'];
    paymentCompleted = json['paymentCompleted'];
    paymentRequested = json['paymentRequested'];
    pickDropOrder = json['pickDropOrder'];
    if (json['products'] != null) {
      products = <CartItemMain>[];
      json['products'].forEach((v) {
        products!.add(new CartItemMain.fromJson(v));
      });
    }
    locationItem = json['locationItem'] != null
        ? new LocationItem.fromJson(json['locationItem'])
        : null;
    promoCode = json['promoCode'] != null
        ? new PromoCode.fromJson(json['promoCode'])
        : null;
    promoCodeApplied = json['promoCodeApplied'];
    daCharge = json['daCharge'];
    deliveryCharge = json['deliveryCharge'];
    totalPrice = json['totalPrice'];
    orderId = json['orderId'];
    id = json['id'];
    pickDropOrderItem = json['pickDropOrderItem'] != null
        ? PickDropOrderItem.fromJson(json['pickDropOrderItem'])
        : null;
    paymentRequestedNumber = json['paymentRequestedNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userName'] = this.userName;
    data['paymentMethod'] = this.paymentMethod;
    data['userAddress'] = this.userAddress;
    data['userNumber'] = this.userNumber;
    data['userNote'] = this.userNote;
    data['userPhoneAccount'] = this.userPhoneAccount;
    data['userId'] = this.userId;
    data['orderPlacingTimeStamp'] = this.orderPlacingTimeStamp;
    data['orderStatus'] = this.orderStatus;
    data['paid'] = this.paid;
    data['paymentCompleted'] = this.paymentCompleted;
    data['paymentRequested'] = this.paymentRequested;
    data['pickDropOrder'] = this.pickDropOrder;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    if (this.locationItem != null) {
      data['locationItem'] = this.locationItem!.toJson();
    }
    if (this.promoCode != null) {
      data['promoCode'] = this.promoCode!.toJson();
    }
    data['promoCodeApplied'] = this.promoCodeApplied;
    data['daCharge'] = this.daCharge;
    data['deliveryCharge'] = this.deliveryCharge;
    data['totalPrice'] = this.totalPrice;
    data['orderId'] = this.orderId;
    data['id'] = this.id;
    if (this.pickDropOrderItem != null) {
      data['pickDropOrderItem'] = this.pickDropOrderItem!.toJson();
    }
    data['paymentRequestedNumber'] = this.paymentRequestedNumber;
    return data;
  }
}

class LocationItem {
  int? deliveryCharge;
  String? locationName;
  int? daCharge;
  int? deliveryChargeClient;
  int? deliveryChargePickDrop;
  int? daChargePickDrop;
  int? order;
  String? id;

  LocationItem(
      {this.deliveryCharge,
        this.locationName,
        this.daCharge,
        this.deliveryChargeClient,
        this.deliveryChargePickDrop,
        this.daChargePickDrop,
        this.order,
        this.id});

  LocationItem.fromJson(Map<String, dynamic> json) {
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

class PromoCode {
  List<String>? userIds;
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

  PromoCode(
      {this.userIds,
        this.active,
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

  PromoCode.fromJson(Map<String, dynamic> json) {
    userIds = json['userIds'].cast<String>();
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
    data['userIds'] = this.userIds;
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
