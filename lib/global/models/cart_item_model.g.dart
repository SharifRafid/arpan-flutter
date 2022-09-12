// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemMainAdapter extends TypeAdapter<CartItemMain> {
  @override
  final int typeId = 0;

  @override
  CartItemMain read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItemMain(
      sId: fields[0] as String?,
      customOrderImage: fields[1] as String?,
      customOrderItem: fields[2] as bool?,
      customOrderText: fields[3] as String?,
      id: fields[4] as int?,
      medicineItem: fields[5] as bool?,
      medicineOrderImage: fields[6] as String?,
      medicineOrderText: fields[7] as String?,
      medicineOrderText2: fields[8] as String?,
      parcelItem: fields[9] as bool?,
      parcelOrderImage: fields[10] as String?,
      parcelOrderText: fields[12] as String?,
      parcelOrderText2: fields[13] as String?,
      productArpanProfit: fields[14] as int?,
      productItem: fields[15] as bool?,
      productItemAmount: fields[16] as int?,
      productItemCategoryTag: fields[17] as String?,
      productItemDesc: fields[18] as String?,
      productItemImage: fields[19] as String?,
      productItemKey: fields[20] as String?,
      productItemName: fields[21] as String?,
      productItemOfferPrice: fields[22] as int?,
      productItemPrice: fields[23] as int?,
      productItemShopKey: fields[24] as String?,
      productItemShopName: fields[25] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CartItemMain obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.sId)
      ..writeByte(1)
      ..write(obj.customOrderImage)
      ..writeByte(2)
      ..write(obj.customOrderItem)
      ..writeByte(3)
      ..write(obj.customOrderText)
      ..writeByte(4)
      ..write(obj.id)
      ..writeByte(5)
      ..write(obj.medicineItem)
      ..writeByte(6)
      ..write(obj.medicineOrderImage)
      ..writeByte(7)
      ..write(obj.medicineOrderText)
      ..writeByte(8)
      ..write(obj.medicineOrderText2)
      ..writeByte(9)
      ..write(obj.parcelItem)
      ..writeByte(10)
      ..write(obj.parcelOrderImage)
      ..writeByte(12)
      ..write(obj.parcelOrderText)
      ..writeByte(13)
      ..write(obj.parcelOrderText2)
      ..writeByte(14)
      ..write(obj.productArpanProfit)
      ..writeByte(15)
      ..write(obj.productItem)
      ..writeByte(16)
      ..write(obj.productItemAmount)
      ..writeByte(17)
      ..write(obj.productItemCategoryTag)
      ..writeByte(18)
      ..write(obj.productItemDesc)
      ..writeByte(19)
      ..write(obj.productItemImage)
      ..writeByte(20)
      ..write(obj.productItemKey)
      ..writeByte(21)
      ..write(obj.productItemName)
      ..writeByte(22)
      ..write(obj.productItemOfferPrice)
      ..writeByte(23)
      ..write(obj.productItemPrice)
      ..writeByte(24)
      ..write(obj.productItemShopKey)
      ..writeByte(25)
      ..write(obj.productItemShopName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemMainAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
