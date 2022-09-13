import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/home/widgets/order_app_bar.dart';
import 'package:ui_test/modules/order/models/order_item_response.dart';

import '../../global/models/cart_item_model.dart';
import 'widgets/order_cart_item.dart';

class OrderDetailsScreen extends StatefulWidget {
  final OrderItemResponse order;

  const OrderDetailsScreen(this.order, {Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  HashMap<String, List<CartItemMain>> cartItems = HashMap();

  void loadCartItems() async {
    cartItems.clear();
    for (var item in widget.order.products!) {
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
    return Scaffold(
      appBar: OrderAppBar(
        height: appBarHeight,
        title: "Order #${widget.order.orderId}",
      ),
      backgroundColor: bgOffWhite,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SizedBox(
                height: 42,
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
                height: 42,
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
                height: 42,
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
            widget.order.userNote.toString().isEmpty
                ? Container()
                : Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                      height: 42,
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
                height: 42,
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: SizedBox(
                height: 42,
                child: InputDecorator(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: false,
                      labelText: 'Order Status',
                      contentPadding: EdgeInsets.only(left: 10, right: 10)),
                  child:
                      Text(widget.order.orderStatus.toString()),
                ),
              ),
            ),
            Column(
              children: [
                for (var item in cartItems.keys)
                  OrderCartCard(item, cartItems[item]!)
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
                                  "You have applied promo code ${widget.order.promoCode!.promoCodeName}",
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
                            "Total : ${widget.order.totalPrice} + ${widget.order.deliveryCharge} =  ${widget.order.totalPrice! + widget.order.deliveryCharge!} ৳",
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
}
