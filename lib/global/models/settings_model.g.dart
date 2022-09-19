// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 1;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      orderStartTime: fields[0] as String?,
      orderEndTime: fields[1] as String?,
      orderOverTimeAllowed: fields[2] as bool?,
      parcelMaxOrders: fields[3] as int?,
      customMaxOrders: fields[4] as int?,
      medicineMaxOrders: fields[5] as int?,
      totalCustomMaxOrders: fields[6] as int?,
      maxShopPerOrder: fields[7] as int?,
      maxChargeAfterPershopMaxOrder: fields[8] as int?,
      maxDaChargeAfterPershopMaxOrder: fields[9] as int?,
      allowOrderingMoreThanMaxShops: fields[10] as bool?,
      alertDialogEmergencyTitleText: fields[12] as String?,
      alertDialogEmergencyMessageText: fields[13] as String?,
      alertDialogeEmergencyStatus: fields[14] as String?,
      id: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.orderStartTime)
      ..writeByte(1)
      ..write(obj.orderEndTime)
      ..writeByte(2)
      ..write(obj.orderOverTimeAllowed)
      ..writeByte(3)
      ..write(obj.parcelMaxOrders)
      ..writeByte(4)
      ..write(obj.customMaxOrders)
      ..writeByte(5)
      ..write(obj.medicineMaxOrders)
      ..writeByte(6)
      ..write(obj.totalCustomMaxOrders)
      ..writeByte(7)
      ..write(obj.maxShopPerOrder)
      ..writeByte(8)
      ..write(obj.maxChargeAfterPershopMaxOrder)
      ..writeByte(9)
      ..write(obj.maxDaChargeAfterPershopMaxOrder)
      ..writeByte(10)
      ..write(obj.allowOrderingMoreThanMaxShops)
      ..writeByte(12)
      ..write(obj.alertDialogEmergencyTitleText)
      ..writeByte(13)
      ..write(obj.alertDialogEmergencyMessageText)
      ..writeByte(14)
      ..write(obj.alertDialogeEmergencyStatus)
      ..writeByte(15)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
