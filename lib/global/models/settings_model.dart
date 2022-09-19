import 'package:hive/hive.dart';
part 'settings_model.g.dart';

@HiveType(typeId: 1)
class Settings {
  @HiveField(0)
  String? orderStartTime;
  @HiveField(1)
  String? orderEndTime;
  @HiveField(2)
  bool? orderOverTimeAllowed;
  @HiveField(3)
  int? parcelMaxOrders;
  @HiveField(4)
  int? customMaxOrders;
  @HiveField(5)
  int? medicineMaxOrders;
  @HiveField(6)
  int? totalCustomMaxOrders;
  @HiveField(7)
  int? maxShopPerOrder;
  @HiveField(8)
  int? maxChargeAfterPershopMaxOrder;
  @HiveField(9)
  int? maxDaChargeAfterPershopMaxOrder;
  @HiveField(10)
  bool? allowOrderingMoreThanMaxShops;
  @HiveField(12)
  String? alertDialogEmergencyTitleText;
  @HiveField(13)
  String? alertDialogEmergencyMessageText;
  @HiveField(14)
  String? alertDialogeEmergencyStatus;
  @HiveField(15)
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