import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/home/widgets/order_app_bar.dart';
import 'package:ui_test/modules/order/models/order_item_response.dart';

import '../../global/models/cart_item_model.dart';
import '../../global/utils/constants.dart';
import '../../global/utils/utils.dart';
import 'widgets/order_cart_item.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderItemResponse order;

  const OrderDetailsScreen(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  HashMap<String, List<CartItemMain>> cartItems = HashMap();
  List<CartItemMain> cartItemsAll = [];

  void loadCartItems() async {
    cartItems.clear();
    cartItemsAll.clear();
    for (var item in widget.order.products!) {
      cartItemsAll.add(item);
      // Just for the sake of speed, using shop name here but
      // using key will be more ideal
      if (cartItems.containsKey(item.productItemShopName)) {
        cartItems[item.productItemShopName!]?.add(item);
      } else {
        cartItems[item.productItemShopName!] = [item];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    var time = fetchTime(widget.order.orderPlacingTimeStamp!);
    return Scaffold(
      appBar: OrderAppBar(
        height: appBarHeight,
        title: "Order #${orderNumberToString(widget.order.orderId.toString())}",
      ),
      backgroundColor: bgWhite,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 10,
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.black, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 6.0, 6.0, 6.0),
                    child: Center(
                      child: Text(
                        "Order# ${orderNumberToString(widget.order.orderId.toString())}",
                        style: const TextStyle(
                            color: textBlack, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 6.0, 25.0, 6.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                      color: widget.order.orderStatus == "PENDING"
                          ? const Color(0xFF262626)
                          : widget.order.orderStatus == "VERIFIED"
                          ? const Color(0xFFFA831B)
                          : widget.order.orderStatus == "PICKED UP"
                          ? const Color(0xFFED9D34)
                          : widget.order.orderStatus == "COMPLETED"
                          ? const Color(0xFF43A047)
                          : widget.order.orderStatus == "CANCELLED"
                          ? const Color(0xFFEA594D)
                          : widget.order.orderStatus == "PROCESSING"
                          ? const Color(0xFFED9D34)
                          : const Color(0xFF43A047),
                    ),
                    height: 35,
                    child: Center(
                      child: Text(widget.order.orderStatus.toString(),
                          style: const TextStyle(
                            color: textWhite,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Colors.black, width: 1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 6.0, 6.0, 6.0),
                    child: Center(
                      child: Text(
                        time,
                        style: const TextStyle(
                            color: textBlack, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(25.0, 6.0, 25.0, 6.0),
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: Color(0xFF262626)),
                    height: 35,
                    child: const Center(
                      child: Text("Now",
                          style: TextStyle(
                            color: textWhite,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SizedBox(
                height: 30,
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: false,
                      labelText: 'Name',
                      contentPadding: EdgeInsets.only(left: 10, right: 10)),
                  child: Text(widget.order.userName.toString()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SizedBox(
                height: 30,
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: false,
                      labelText: 'Address',
                      contentPadding: EdgeInsets.only(left: 10, right: 10)),
                  child: Text(widget.order.userAddress.toString()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SizedBox(
                height: 35,
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: false,
                      labelText: 'Phone',
                      contentPadding: EdgeInsets.only(left: 10, right: 10)),
                  child: Text(widget.order.userNumber.toString()),
                ),
              ),
            ),
            widget.order.userNote
                .toString()
                .isEmpty
                ? Container()
                : Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SizedBox(
                height: 35,
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: false,
                      labelText: 'Note',
                      contentPadding:
                      EdgeInsets.only(left: 10, right: 10)),
                  child: Text(widget.order.userNote.toString()),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SizedBox(
                height: 35,
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: false,
                      labelText: 'Location',
                      contentPadding: EdgeInsets.only(left: 10, right: 10)),
                  child:
                  Text(widget.order.locationItem!.locationName.toString()),
                ),
              ),
            ),
            cartItemsAll.isNotEmpty
                ? cartItemsAll[0].productItem == true
                ? Column(
              children: [
                for (var item in cartItems.keys)
                  OrderCartCard(item, cartItems[item]!)
              ],
            )
                :
            // Custom Order (Custom/Medicine/Parcel)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 1,
                  width: 100,
                  margin: const EdgeInsets.only(top: 10, bottom: 5),
                  color: textBlack,
                ),
                cartItemsAll[0].customOrderItem == true?
                const Text('Custom Order') :
                cartItemsAll[0].medicineItem == true ?
                const Text('Medicine Order') :
                const Text('Parcel Order'),
                Container(
                  height: 1,
                  width: 100,
                  margin: const EdgeInsets.only(top: 5, bottom: 10),
                  color: textBlack,
                ),
                getImageLink(cartItemsAll[0]) != ""
                    ? CachedNetworkImage(
                  height: 150,
                  imageUrl: serverFilesBaseURL +
                      getImageLink(cartItemsAll[0]),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset(
                          "assets/images/transparent.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset(
                        "assets/images/Default_Image_Thumbnail.png",
                        fit: BoxFit.cover,
                      ),
                )
                    : Container(),
                getTitleWidget(cartItemsAll[0]),
                getDetailsWidget(cartItemsAll[0]),
              ],
            )
            // Custom Order (Pick Drop)
                : Column(
              children: [
                const Text('Pick & Drop Order'),
                widget.order.pickDropOrderItem?.parcelImage != null
                    ? CachedNetworkImage(
                  height: 150,
                  imageUrl: serverFilesBaseURL +
                      widget.order.pickDropOrderItem!.parcelImage.toString(),
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      Image.asset(
                          "assets/images/transparent.png"),
                  errorWidget: (context, url, error) =>
                      Image.asset(
                        "assets/images/Default_Image_Thumbnail.png",
                        fit: BoxFit.cover,
                      ),
                )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SizedBox(
                    height: 30,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: false,
                          labelText: 'Receiver Name',
                          contentPadding: EdgeInsets.only(left: 10, right: 10)),
                      child: Text(widget.order.pickDropOrderItem!.recieverName.toString()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SizedBox(
                    height: 30,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: false,
                          labelText: 'Receiver Address',
                          contentPadding: EdgeInsets.only(left: 10, right: 10)),
                      child: Text(widget.order.pickDropOrderItem!.recieverAddress.toString()),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SizedBox(
                    height: 35,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: false,
                          labelText: 'Receiver Phone',
                          contentPadding: EdgeInsets.only(left: 10, right: 10)),
                      child: Text(widget.order.pickDropOrderItem!.recieverPhone.toString()),
                    ),
                  ),
                ),
                widget.order.userNote
                    .toString()
                    .isEmpty
                    ? Container()
                    : Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: SizedBox(
                    height: 35,
                    child: InputDecorator(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          isDense: false,
                          labelText: 'Location',
                          contentPadding:
                          EdgeInsets.only(left: 10, right: 10)),
                      child: Text(widget.order.pickDropOrderItem!.recieverLocation.toString()),
                    ),
                  ),
                ),
              ],
            ),
            widget.order.paymentMethod != "COD"
                ? const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Extra charges added for bKash",
                style: TextStyle(color: Colors.pink),
              ),
            )
                : const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Payment method: Cash On Delivery",
                style: TextStyle(color: Colors.green),
              ),
            ),
            widget.order.promoCode != null
                ? Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(
                            color: Colors.green, width: 2)),
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "You have applied promo code ${widget.order
                                .promoCode!.promoCodeName}",
                            style: const TextStyle(color: textBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )
                : Container(),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: const BorderSide(color: Colors.green, width: 2)),
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Center(
                          child: Text(
                            "Total : ${widget.order.totalPrice} + ${widget.order
                                .deliveryCharge} =  ${widget.order.totalPrice! +
                                widget.order.deliveryCharge!} ৳",
                            style: const TextStyle(color: textBlack),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 15,
            )
          ],
        ),
      ),
    );
  }

  String getImageLink(CartItemMain cartItemMain) {
    if (cartItemMain.customOrderItem == true) {
      if(cartItemMain.customOrderImage == null){
        return "";
      }
      return cartItemMain.customOrderImage.toString();
    } else if (cartItemMain.parcelItem == true) {
      if(cartItemMain.parcelOrderImage == null){
        return "";
      }
      return cartItemMain.parcelOrderImage.toString();
    } else {
      if(cartItemMain.medicineOrderImage == null){
        return "";
      }
      return cartItemMain.medicineOrderImage.toString();
    }
  }

  Widget getTitleWidget(CartItemMain cartItemMain) {
    if (cartItemMain.customOrderItem == true) {
      return Container();
    } else if (cartItemMain.parcelItem == true) {
      if(cartItemMain.parcelOrderText == null){
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 5),
        child: SizedBox(
          height: 35,
          child: InputDecorator(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: false,
                labelText: 'Courier Name',
                contentPadding:
                EdgeInsets.only(left: 10, right: 10)),
            child: Text(cartItemMain.parcelOrderText.toString()),
          ),
        ),
      );
    } else {
      if(cartItemMain.medicineOrderText == null){
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 5),
        child: SizedBox(
          height: 35,
          child: InputDecorator(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: false,
                labelText: 'Pharmacy Name',
                contentPadding:
                EdgeInsets.only(left: 10, right: 10)),
            child: Text(cartItemMain.medicineOrderText.toString()),
          ),
        )
        ,
      );
    }
  }

  Widget getDetailsWidget(CartItemMain cartItemMain) {
    if (cartItemMain.customOrderItem == true) {
      if(cartItemMain.customOrderText == null){
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 5),
        child: SizedBox(
          height: 35,
          child: InputDecorator(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: false,
                labelText: 'Order Details',
                contentPadding:
                EdgeInsets.only(left: 10, right: 10)),
            child: Text(cartItemMain.customOrderText.toString()),
          ),
        ),
      );
    } else if (cartItemMain.parcelItem == true) {
      if(cartItemMain.parcelOrderText2 == null){
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 5),
        child: SizedBox(
          height: 35,
          child: InputDecorator(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: false,
                labelText: 'Order Details',
                contentPadding:
                EdgeInsets.only(left: 10, right: 10)),
            child: Text(cartItemMain.parcelOrderText2.toString()),
          ),
        ),
      );
    } else {
      if(cartItemMain.medicineOrderText2 == null){
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 10, vertical: 5),
        child: SizedBox(
          height: 35,
          child: InputDecorator(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: false,
                labelText: 'Order Details',
                contentPadding:
                EdgeInsets.only(left: 10, right: 10)),
            child: Text(cartItemMain.medicineOrderText2.toString()),
          ),
        )
        ,
      );
    }
  }

}
