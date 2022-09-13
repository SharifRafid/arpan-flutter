import 'package:hive/hive.dart';
part 'cart_item_model.g.dart';

@HiveType(typeId: 0)
class CartItemMain extends HiveObject {
  @HiveField(0)
  String? sId;
  @HiveField(1)
  String? customOrderImage;
  @HiveField(2)
  bool? customOrderItem;
  @HiveField(3)
  String? customOrderText;
  @HiveField(4)
  String? id;
  @HiveField(5)
  bool? medicineItem;
  @HiveField(6)
  String? medicineOrderImage;
  @HiveField(7)
  String? medicineOrderText;
  @HiveField(8)
  String? medicineOrderText2;
  @HiveField(9)
  bool? parcelItem;
  @HiveField(10)
  String? parcelOrderImage;
  @HiveField(12)
  String? parcelOrderText;
  @HiveField(13)
  String? parcelOrderText2;
  @HiveField(14)
  int? productArpanProfit;
  @HiveField(15)
  bool? productItem;
  @HiveField(16)
  int? productItemAmount;
  @HiveField(17)
  String? productItemCategoryTag;
  @HiveField(18)
  String? productItemDesc;
  @HiveField(19)
  String? productItemImage;
  @HiveField(20)
  String? productItemKey;
  @HiveField(21)
  String? productItemName;
  @HiveField(22)
  int? productItemOfferPrice;
  @HiveField(23)
  int? productItemPrice;
  @HiveField(24)
  String? productItemShopKey;
  @HiveField(25)
  String? productItemShopName;

  CartItemMain(
      {this.sId,
        this.customOrderImage,
        this.customOrderItem,
        this.customOrderText,
        this.id,
        this.medicineItem,
        this.medicineOrderImage,
        this.medicineOrderText,
        this.medicineOrderText2,
        this.parcelItem,
        this.parcelOrderImage,
        this.parcelOrderText,
        this.parcelOrderText2,
        this.productArpanProfit,
        this.productItem,
        this.productItemAmount,
        this.productItemCategoryTag,
        this.productItemDesc,
        this.productItemImage,
        this.productItemKey,
        this.productItemName,
        this.productItemOfferPrice,
        this.productItemPrice,
        this.productItemShopKey,
        this.productItemShopName});

  CartItemMain.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    customOrderImage = json['custom_order_image'];
    customOrderItem = json['custom_order_item'];
    customOrderText = json['custom_order_text'];
    id = json['id'];
    medicineItem = json['medicine_item'];
    medicineOrderImage = json['medicine_order_image'];
    medicineOrderText = json['medicine_order_text'];
    medicineOrderText2 = json['medicine_order_text_2'];
    parcelItem = json['parcel_item'];
    parcelOrderImage = json['parcel_order_image'];
    parcelOrderText = json['parcel_order_text'];
    parcelOrderText2 = json['parcel_order_text_2'];
    productArpanProfit = json['product_arpan_profit'];
    productItem = json['product_item'];
    productItemAmount = json['product_item_amount'];
    productItemCategoryTag = json['product_item_category_tag'];
    productItemDesc = json['product_item_desc'];
    productItemImage = json['product_item_image'];
    productItemKey = json['product_item_key'];
    productItemName = json['product_item_name'];
    productItemOfferPrice = json['product_item_offer_price'];
    productItemPrice = json['product_item_price'];
    productItemShopKey = json['product_item_shop_key'];
    productItemShopName = json['product_item_shop_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['custom_order_image'] = this.customOrderImage;
    data['custom_order_item'] = this.customOrderItem;
    data['custom_order_text'] = this.customOrderText;
    data['id'] = this.id;
    data['medicine_item'] = this.medicineItem;
    data['medicine_order_image'] = this.medicineOrderImage;
    data['medicine_order_text'] = this.medicineOrderText;
    data['medicine_order_text_2'] = this.medicineOrderText2;
    data['parcel_item'] = this.parcelItem;
    data['parcel_order_image'] = this.parcelOrderImage;
    data['parcel_order_text'] = this.parcelOrderText;
    data['parcel_order_text_2'] = this.parcelOrderText2;
    data['product_arpan_profit'] = this.productArpanProfit;
    data['product_item'] = this.productItem;
    data['product_item_amount'] = this.productItemAmount;
    data['product_item_category_tag'] = this.productItemCategoryTag;
    data['product_item_desc'] = this.productItemDesc;
    data['product_item_image'] = this.productItemImage;
    data['product_item_key'] = this.productItemKey;
    data['product_item_name'] = this.productItemName;
    data['product_item_offer_price'] = this.productItemOfferPrice;
    data['product_item_price'] = this.productItemPrice;
    data['product_item_shop_key'] = this.productItemShopKey;
    data['product_item_shop_name'] = this.productItemShopName;
    return data;
  }
}