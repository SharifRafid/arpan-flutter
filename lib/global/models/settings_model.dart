class Settings {
  String? orderStartTime;
  String? orderEndTime;
  bool? orderOverTimeAllowed;
  int? parcelMaxOrders;
  int? customMaxOrders;
  int? medicineMaxOrders;
  int? totalCustomMaxOrders;
  int? maxShopPerOrder;
  int? maxChargeAfterPershopMaxOrder;
  int? maxDaChargeAfterPershopMaxOrder;
  bool? allowOrderingMoreThanMaxShops;
  String? alertDialogEmergencyTitleText;
  String? alertDialogEmergencyMessageText;
  String? alertDialogeEmergencyStatus;
  String? id;

  Settings(
      {this.orderStartTime,
        this.orderEndTime,
        this.orderOverTimeAllowed,
        this.parcelMaxOrders,
        this.customMaxOrders,
        this.medicineMaxOrders,
        this.totalCustomMaxOrders,
        this.maxShopPerOrder,
        this.maxChargeAfterPershopMaxOrder,
        this.maxDaChargeAfterPershopMaxOrder,
        this.allowOrderingMoreThanMaxShops,
        this.alertDialogEmergencyTitleText,
        this.alertDialogEmergencyMessageText,
        this.alertDialogeEmergencyStatus,
        this.id});

  Settings.fromJson(Map<String, dynamic> json) {
    orderStartTime = json['orderStartTime'];
    orderEndTime = json['orderEndTime'];
    orderOverTimeAllowed = json['orderOverTimeAllowed'];
    parcelMaxOrders = json['parcelMaxOrders'];
    customMaxOrders = json['customMaxOrders'];
    medicineMaxOrders = json['medicineMaxOrders'];
    totalCustomMaxOrders = json['totalCustomMaxOrders'];
    maxShopPerOrder = json['maxShopPerOrder'];
    maxChargeAfterPershopMaxOrder = json['maxChargeAfterPershopMaxOrder'];
    maxDaChargeAfterPershopMaxOrder = json['maxDaChargeAfterPershopMaxOrder'];
    allowOrderingMoreThanMaxShops = json['allowOrderingMoreThanMaxShops'];
    alertDialogEmergencyTitleText = json['alertDialogEmergencyTitleText'];
    alertDialogEmergencyMessageText = json['alertDialogEmergencyMessageText'];
    alertDialogeEmergencyStatus = json['alertDialogeEmergencyStatus'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderStartTime'] = orderStartTime;
    data['orderEndTime'] = orderEndTime;
    data['orderOverTimeAllowed'] = orderOverTimeAllowed;
    data['parcelMaxOrders'] = parcelMaxOrders;
    data['customMaxOrders'] = customMaxOrders;
    data['medicineMaxOrders'] = medicineMaxOrders;
    data['totalCustomMaxOrders'] = totalCustomMaxOrders;
    data['maxShopPerOrder'] = maxShopPerOrder;
    data['maxChargeAfterPershopMaxOrder'] = maxChargeAfterPershopMaxOrder;
    data['maxDaChargeAfterPershopMaxOrder'] =
        maxDaChargeAfterPershopMaxOrder;
    data['allowOrderingMoreThanMaxShops'] = allowOrderingMoreThanMaxShops;
    data['alertDialogEmergencyTitleText'] = alertDialogEmergencyTitleText;
    data['alertDialogEmergencyMessageText'] =
        alertDialogEmergencyMessageText;
    data['alertDialogeEmergencyStatus'] = alertDialogeEmergencyStatus;
    data['id'] = id;
    return data;
  }
}