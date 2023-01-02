import 'dart:async';
import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_test/global/utils/show_toast.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/home/widgets/order_app_bar.dart';
import 'package:ui_test/modules/order/models/order_item_response.dart';
import 'package:ui_test/modules/order/widgets/order_steps_view.dart';

import '../../global/models/cart_item_model.dart';
import '../../global/utils/constants.dart';
import '../../global/utils/utils.dart';
import 'services/order_service.dart';
import 'widgets/order_cart_item.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailsScreen(this.orderId, {Key? key}) : super(key: key);

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  HashMap<String, List<CartItemMain>> cartItems = HashMap();
  List<CartItemMain> cartItemsAll = [];
  OrderItemResponse? orderItemResponse;
  Timer? _autoRefreshTimer;
  bool loading = true;

  void loadCartItems(OrderItemResponse response) async {
    cartItems.clear();
    cartItemsAll.clear();
    for (var item in response.products!) {
      cartItemsAll.add(item);
      // Just for the sake of speed, using shop name here but
      // using key will be more ideal
      if (item.productItemShopName != null) {
        if (cartItems.containsKey(item.productItemShopName)) {
          if (cartItems[item.productItemShopName] != null) {
            cartItems[item.productItemShopName]?.add(item);
          } else {
            cartItems[item.productItemShopName!] = [item];
          }
        } else {
          cartItems[item.productItemShopName!] = [item];
        }
      }
    }
    setState(() {
      loading = false;
      orderItemResponse = response;
    });
  }

  void cancelOrder() async {
    var response = await OrderService().cancelOrder(orderItemResponse!.id!);
    if (response == null) {
      if (!mounted) return;
      showToast(
          context, "Failed to cancel the order, please refresh the page.");
    } else {
      OrderItemResponse oldOIR = orderItemResponse!;
      oldOIR.orderStatus = "CANCELLED";
      setState(() {
        orderItemResponse = oldOIR;
      });
      if (!mounted) return;
      showToast(context, "Cancelled order successfully.");
    }
  }

  void loadOrderData() async {
    debugPrint("Refresing Order Data");
    var response = await OrderService().getOrderById(widget.orderId);
    if (response != null) {
      loadCartItems(response);
    }
  }

  @override
  void initState() {
    super.initState();
    loadOrderData();
    _autoRefreshTimer = Timer.periodic(
        const Duration(seconds: autoRefreshDelaySeconds),
        (Timer t) => loadOrderData());
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var time = orderItemResponse != null
        ? fetchTime(orderItemResponse!.orderPlacingTimeStamp!)
        : "";
    return Scaffold(
      appBar: OrderAppBar(
        height: appBarHeight,
        title: orderItemResponse == null
            ? ""
            : "Order #${orderNumberToString(orderItemResponse!.orderId.toString())}",
      ),
      backgroundColor: bgWhite,
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 6.0, 6.0, 6.0),
                          child: Center(
                            child: Text(
                              "Order# ${orderNumberToString(orderItemResponse!.orderId.toString())}",
                              style: const TextStyle(
                                  color: textBlack,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 6.0, 25.0, 6.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20)),
                            color: orderItemResponse!.orderStatus == "PLACED"
                                ? const Color(0xFF262626)
                                : orderItemResponse!.orderStatus == "VERIFIED"
                                    ? const Color(0xFFFA831B)
                                    : orderItemResponse!.orderStatus ==
                                            "PICKED UP"
                                        ? const Color(0xFFED9D34)
                                        : orderItemResponse!.orderStatus ==
                                                "COMPLETED"
                                            ? const Color(0xFF43A047)
                                            : orderItemResponse!.orderStatus ==
                                                    "CANCELLED"
                                                ? const Color(0xFFEA594D)
                                                : orderItemResponse!
                                                            .orderStatus ==
                                                        "PROCESSING"
                                                    ? const Color(0xFFED9D34)
                                                    : const Color(0xFF43A047),
                          ),
                          height: 35,
                          child: Center(
                            child:
                                Text(orderItemResponse!.orderStatus.toString(),
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
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 6.0, 6.0, 6.0),
                          child: Center(
                            child: Text(
                              time,
                              style: const TextStyle(
                                  color: textBlack,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(25.0, 6.0, 25.0, 6.0),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                      height: 30,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: false,
                            labelText: 'Name',
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10)),
                        child: Text(orderItemResponse!.userName.toString()),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                      height: 30,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: false,
                            labelText: 'Address',
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10)),
                        child: Text(orderItemResponse!.userAddress.toString()),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                      height: 35,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: false,
                            labelText: 'Phone',
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10)),
                        child: Text(orderItemResponse!.userNumber.toString()),
                      ),
                    ),
                  ),
                  orderItemResponse!.userNote.toString().isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: SizedBox(
                            height: 35,
                            child: InputDecorator(
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: false,
                                  labelText: 'Note',
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10)),
                              child:
                                  Text(orderItemResponse!.userNote.toString()),
                            ),
                          ),
                        ),
                  Padding(
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
                        child: Text(orderItemResponse!
                            .locationItem!.locationName
                            .toString()),
                      ),
                    ),
                  ),
                  orderItemResponse!.orderStatus != "CANCELLED"
                      ? orderStepsView(orderItemResponse!.orderStatus!)
                      : Container(),
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
                                  margin:
                                      const EdgeInsets.only(top: 10, bottom: 5),
                                  color: textBlack,
                                ),
                                cartItemsAll[0].customOrderItem == true
                                    ? const Text('Custom Order')
                                    : cartItemsAll[0].medicineItem == true
                                        ? const Text('Medicine Order')
                                        : const Text('Parcel Order'),
                                Container(
                                  height: 1,
                                  width: 100,
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 10),
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
                            orderItemResponse!.pickDropOrderItem?.parcelImage !=
                                    null
                                ? CachedNetworkImage(
                                    height: 150,
                                    imageUrl: serverFilesBaseURL +
                                        orderItemResponse!
                                            .pickDropOrderItem!.parcelImage
                                            .toString(),
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => Image.asset(
                                        "assets/images/transparent.png"),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      "assets/images/Default_Image_Thumbnail.png",
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: SizedBox(
                                height: 30,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: false,
                                      labelText: 'Receiver Name',
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10)),
                                  child: Text(orderItemResponse!
                                      .pickDropOrderItem!.recieverName
                                      .toString()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: SizedBox(
                                height: 30,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: false,
                                      labelText: 'Receiver Address',
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10)),
                                  child: Text(orderItemResponse!
                                      .pickDropOrderItem!.recieverAddress
                                      .toString()),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: SizedBox(
                                height: 35,
                                child: InputDecorator(
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: false,
                                      labelText: 'Receiver Phone',
                                      contentPadding:
                                          EdgeInsets.only(left: 10, right: 10)),
                                  child: Text(orderItemResponse!
                                      .pickDropOrderItem!.recieverPhone
                                      .toString()),
                                ),
                              ),
                            ),
                            orderItemResponse!
                                        .pickDropOrderItem!.parcelDetails ==
                                    null
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: InputDecorator(
                                      decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          isDense: false,
                                          labelText: 'Parcel Details',
                                          contentPadding: EdgeInsets.only(
                                              left: 10, right: 10)),
                                      child: Text(orderItemResponse!
                                          .pickDropOrderItem!.parcelDetails
                                          .toString()),
                                    ),
                                  ),
                            orderItemResponse!.userNote.toString().isEmpty
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: SizedBox(
                                      height: 35,
                                      child: InputDecorator(
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            isDense: false,
                                            labelText: 'Location',
                                            contentPadding: EdgeInsets.only(
                                                left: 10, right: 10)),
                                        child: Text(orderItemResponse!
                                            .pickDropOrderItem!.recieverLocation
                                            .toString()),
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                  orderItemResponse!.paymentMethod != "COD"
                      ? Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Colors.green, width: 2)),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              width: double.infinity,
                              child: orderItemResponse!.paymentRequested != true
                                  ? Text(
                                      "Extra charges added for bKash",
                                      style: TextStyle(color: Colors.pink),
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "The delivery agent is requesting payment. Please pay ${orderItemResponse!.totalPrice! + orderItemResponse!.deliveryCharge!} taka to the number below.",
                                          style: TextStyle(color: textBlack),
                                          textAlign: TextAlign.center,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              orderItemResponse!
                                                      .paymentRequestedNumber ??
                                                  "Number Empty",
                                              style: const TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.center,
                                            ),
                                            IconButton(
                                                onPressed: () async {
                                                  await Clipboard.setData(
                                                      ClipboardData(
                                                          text: orderItemResponse!
                                                                  .paymentRequestedNumber ??
                                                              ""));
                                                  if (!mounted) return;
                                                  showToast(context,
                                                      "Bkash number copied to clipboard");
                                                },
                                                icon: const Icon(
                                                  Icons.copy,
                                                  color: Colors.green,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        )
                      : const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Payment method: Cash On Delivery",
                            style: TextStyle(color: Colors.green),
                          ),
                        ),
                  orderItemResponse!.promoCode != null
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
                                        "You have applied promo code ${orderItemResponse!.promoCode!.promoCodeName}",
                                        style:
                                            const TextStyle(color: textBlack),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Colors.green, width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  "Total : ${orderItemResponse!.totalPrice} + ${orderItemResponse!.deliveryCharge} =  ${orderItemResponse!.totalPrice! + orderItemResponse!.deliveryCharge!} ৳",
                                  style: const TextStyle(color: textBlack),
                                ),
                              ),
                            ),
                          ),
                        ),
                        orderItemResponse!.orderStatus == "PLACED"
                            ? Container(
                                height: 38,
                                width: 140,
                                margin:
                                    const EdgeInsets.only(left: 5, right: 5),
                                child: MaterialButton(
                                  onPressed: () {
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Cancel order?'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: const <Widget>[
                                                Text(
                                                    'Are you sure you want to cancel this order?'),
                                              ],
                                            ),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Yes'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                cancelOrder();
                                              },
                                            ),
                                            TextButton(
                                              child: const Text('No'),
                                              onPressed: () {
                                                Navigator.pop(
                                                    context, 'Cancel');
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  color: Colors.red,
                                  child: const Center(
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 15, right: 15),
                                      child: Text(
                                        "Cancel Order",
                                        style: TextStyle(color: textWhite),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container()
                      ],
                    ),
                  ),
                  orderItemResponse!.orderStatus == "CANCELLED"
                      ? Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Colors.red, width: 2)),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Center(
                              child: Text(
                                "Cancellation Reason : ${orderItemResponse!.cancelledOrderReasonFromAdmin}",
                                style: const TextStyle(color: Colors.red),
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    height: 15,
                  ),
                ],
              ),
            ),
    );
  }

  String getImageLink(CartItemMain cartItemMain) {
    if (cartItemMain.customOrderItem == true) {
      if (cartItemMain.customOrderImage == null) {
        return "";
      }
      return cartItemMain.customOrderImage.toString();
    } else if (cartItemMain.parcelItem == true) {
      if (cartItemMain.parcelOrderImage == null) {
        return "";
      }
      return cartItemMain.parcelOrderImage.toString();
    } else {
      if (cartItemMain.medicineOrderImage == null) {
        return "";
      }
      return cartItemMain.medicineOrderImage.toString();
    }
  }

  Widget getTitleWidget(CartItemMain cartItemMain) {
    if (cartItemMain.customOrderItem == true) {
      return Container();
    } else if (cartItemMain.parcelItem == true) {
      if (cartItemMain.parcelOrderText == null) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: SizedBox(
          height: 35,
          child: InputDecorator(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: false,
                labelText: 'Courier Name',
                contentPadding: EdgeInsets.only(left: 10, right: 10)),
            child: Text(cartItemMain.parcelOrderText.toString()),
          ),
        ),
      );
    } else {
      if (cartItemMain.medicineOrderText == null) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: SizedBox(
          height: 35,
          child: InputDecorator(
            decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: false,
                labelText: 'Pharmacy Name',
                contentPadding: EdgeInsets.only(left: 10, right: 10)),
            child: Text(cartItemMain.medicineOrderText.toString()),
          ),
        ),
      );
    }
  }

  Widget getDetailsWidget(CartItemMain cartItemMain) {
    if (cartItemMain.customOrderItem == true) {
      if (cartItemMain.customOrderText == null) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: InputDecorator(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: false,
              labelText: 'Order Details',
              contentPadding: EdgeInsets.only(left: 10, right: 10)),
          child: Text(cartItemMain.customOrderText.toString()),
        ),
      );
    } else if (cartItemMain.parcelItem == true) {
      if (cartItemMain.parcelOrderText2 == null) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: InputDecorator(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: false,
              labelText: 'Order Details',
              contentPadding: EdgeInsets.only(left: 10, right: 10)),
          child: Text(cartItemMain.parcelOrderText2.toString()),
        ),
      );
    } else {
      if (cartItemMain.medicineOrderText2 == null) {
        return Container();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        child: InputDecorator(
          decoration: const InputDecoration(
              border: OutlineInputBorder(),
              isDense: false,
              labelText: 'Order Details',
              contentPadding: EdgeInsets.only(left: 10, right: 10)),
          child: Text(cartItemMain.medicineOrderText2.toString()),
        ),
      );
    }
  }
}
