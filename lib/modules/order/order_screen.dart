import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ui_test/global/models/location_model.dart';
import 'package:ui_test/global/utils/constants.dart';
import 'package:ui_test/global/utils/show_toast.dart';
import 'package:ui_test/modules/home/services/home_service.dart';
import 'package:ui_test/modules/home/widgets/order_app_bar.dart';
import 'package:ui_test/modules/order/all_orders_screen.dart';
import 'package:ui_test/modules/order/services/order_service.dart';
import 'package:ui_test/modules/order/widgets/order_cart_item.dart';

import '../../global/models/cart_item_model.dart';
import '../../global/models/promo_code_model.dart';
import '../../global/models/settings_model.dart';
import '../../global/utils/theme_data.dart';
import '../../global/utils/utils.dart';
import 'widgets/promo_code_block.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final homeService = HomeService();
  final orderService = OrderService();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  List<Location> _locationsArray = [];
  Location _selectedLocation = Location();
  HashMap<String, List<CartItemMain>> cartItems = HashMap();
  List<CartItemMain> cartItemsList = [];
  PaymentMethod? _paymentMethod = PaymentMethod.COD;
  Promo? promoCode;

  bool loading = true;

  int totalPrice = 0;
  int totalPriceBkash = 0;
  int deliveryCharge = 0;

  late Box box;

  void placeOrder() async {
    if(!orderingTimeCheck()){
      showToast(context, "Please order at the correct ordering times");
      return;
    }
    var authBox = Hive.box('authBox');
    if (authBox.get("accessToken", defaultValue: "") == "" ||
        authBox.get("refreshToken", defaultValue: "") == "") {
      showLoginToast(context);
      return;
    }
    var name = nameController.text;
    var phone = phoneController.text;
    var address = addressController.text;
    var note = noteController.text;
    if (name.isEmpty || phone.isEmpty || address.isEmpty) {
      if (!mounted) return;
      showToast(context, "Fill all the required details");
      return;
    }
    if (!isNumeric(phone.toString())) {
      if (!mounted) return;
      showToast(context, "Enter a valid phone number");
      return;
    }
    if (phone.toString().length != 11) {
      if (!mounted) return;
      showToast(context, "Phone number must be 11 digits");
      return;
    }
    if (cartItemsList.isEmpty) {
      if (!mounted) return;
      showToast(context, "There must be at least one product in your cart");
      return;
    }
    setState(() {
      loading = true;
    });
    HashMap<String, dynamic> hashMap = HashMap();
    hashMap["name"] = name.toString();
    hashMap["phone"] = phone.toString();
    hashMap["address"] = address.toString();
    hashMap["note"] = note.toString();
    hashMap["device"] = kIsWeb ? "WEB" : "APP";
    hashMap["shopNames"] =
        cartItemsList.map((e) => e.productItemShopName).toList();
    hashMap["productsAmount"] =
        cartItemsList.map((e) => e.productItemAmount).toList();
    hashMap["products"] = cartItemsList.map((e) => e.productItemKey).toList();
    if (promoCode != null) {
      hashMap["promo"] = promoCode!.id;
    }
    hashMap["location"] = _selectedLocation.id;
    hashMap["payment"] =
        _paymentMethod == PaymentMethod.bKash ? "bKash" : "COD";
    String? orderId = await orderService.placeOrder(hashMap);
    if (orderId == null) {
      if (!mounted) return;
      showToast(context, "Failed to place order");
      setState(() {
        loading = false;
      });
    } else {
      print(orderId);
      box.clear();
      Hive.box<CartItemMain>("cart").clear();
      if (!mounted) return;
      showToast(context, "Successfully placed order");
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const AllOrdersScreen()));
    }
  }

  void openBox() async {
    box = await Hive.openBox("orderInputs");
  }

  void calculateTotalPrices() {
    int tp = 0;
    int dc = _selectedLocation.deliveryCharge!;

    for (var item in cartItemsList) {
      tp = tp + (item.productItemOfferPrice! * item.productItemAmount!);
    }

    if (promoCode != null) {
      if (promoCode!.shopDiscount == true) {
        if (promoCode!.discountPrice! > tp) {
          tp = 0;
        } else {
          tp = tp - promoCode!.discountPrice!;
        }
      } else if (promoCode!.deliveryDiscount == true) {
        if (promoCode!.discountPrice! > dc) {
          dc = 0;
        } else {
          dc = dc - promoCode!.discountPrice!;
        }
      }
    }

    setState(() {
      totalPrice = tp;
      deliveryCharge = dc;
      totalPriceBkash = (tp + ((tp + dc) * bkashMultiplier).toInt());
    });
  }

  void getLocationsResponse() async {
    if (mounted) {
      var response = await homeService.getLocationDataMain();
      if (response == null) {
        if (kDebugMode) {
          print("Response is null");
        }
      } else {
        _locationsArray = response;
        if (response.isNotEmpty) {
          _selectedLocation = response[0];
        }
        setState(() {
          loading = false;
        });
        calculateTotalPrices();
        nameController.text = box.get("name", defaultValue: null) ?? Hive.box('authBox').get("name",defaultValue: "");
        phoneController.text = box.get("phone", defaultValue: null) ?? Hive.box('authBox').get("phone",defaultValue: "") ;
        addressController.text = box.get("address", defaultValue: null) ?? Hive.box('authBox').get("address",defaultValue: "") ;
        noteController.text = box.get("note", defaultValue: "");
      }
    }
  }

  void loadCartItems() async {
    var data = Hive.box<CartItemMain>("cart").values;
    cartItems.clear();
    cartItemsList.clear();
    for (var item in data) {
      cartItemsList.add(item);
      // Just for the sake of speed, using shop name here but
      // using key will be more ideal
      if (cartItems.containsKey(item.productItemShopName)) {
        cartItems[item.productItemShopName!]?.add(item);
      } else {
        cartItems[item.productItemShopName!] = [item];
      }
    }
    getLocationsResponse();
  }

  @override
  void initState() {
    super.initState();
    openBox();
    loadCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderAppBar(
        title: "Checkout",
        height: appBarHeight,
      ),
      backgroundColor: bgOffWhite,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 5),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      controller: nameController,
                      onChanged: (text) {
                        box.put("name", text.toString());
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8), // Added this
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      controller: phoneController,
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        box.put("phone", text.toString());
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8), // A
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Phone',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      controller: addressController,
                      onChanged: (text) {
                        box.put("address", text.toString());
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8), // A
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Address',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                      height: 45,
                      child: TextFormField(
                        onChanged: (text) {
                          box.put("note", text.toString());
                        },
                        style: const TextStyle(fontSize: 14),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        controller: noteController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8), // A
                          isDense: true,
                          border: OutlineInputBorder(),
                          labelText: 'Note',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: SizedBox(
                      height: 42,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            isDense: false,
                            contentPadding:
                                EdgeInsets.only(left: 10, right: 10)),
                        child: DropdownButton<Location>(
                          value: _selectedLocation,
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          elevation: 16,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          style: const TextStyle(color: textBlack),
                          onChanged: (Location? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _selectedLocation = value!;
                            });
                            calculateTotalPrices();
                          },
                          items: _locationsArray
                              .map<DropdownMenuItem<Location>>(
                                  (Location value) {
                            return DropdownMenuItem<Location>(
                              value: value,
                              child: Text(value.locationName.toString()),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      for (var item in cartItems.keys)
                        OrderCartCard(item, cartItems[item]!)
                    ],
                  ),
                  SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Row(
                            children: [
                              Radio<PaymentMethod>(
                                value: PaymentMethod.COD,
                                groupValue: _paymentMethod,
                                onChanged: (PaymentMethod? value) {
                                  setState(() {
                                    _paymentMethod = value;
                                  });
                                },
                              ),
                              Text("Cash On Delivery"),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Row(
                            children: [
                              Radio<PaymentMethod>(
                                value: PaymentMethod.bKash,
                                groupValue: _paymentMethod,
                                onChanged: (PaymentMethod? value) {
                                  setState(() {
                                    _paymentMethod = value;
                                  });
                                },
                              ),
                              Image.asset(
                                "assets/images/bkash_logo.png",
                                height: 30,
                                width: 60,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _paymentMethod == PaymentMethod.bKash
                      ? const Padding(
                        padding: EdgeInsets.only(bottom: 8.0),
                        child: Text(
                            "Extra charge added for bKash",
                            style: TextStyle(color: Colors.pink),
                          ),
                      )
                      : Container(),
                  PromoCodeBlock(cartItemsList, (id) {
                    promoCode = id;
                    calculateTotalPrices();
                  }),
                  SizedBox(
                    height: 50,
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                            elevation: 1,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                                side: const BorderSide(
                                    color: Colors.green, width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: _paymentMethod == PaymentMethod.bKash
                                    ? Text(
                                        "Total : $totalPriceBkash + $deliveryCharge =  ${totalPriceBkash + deliveryCharge} ৳",
                                        style:
                                            const TextStyle(color: textBlack),
                                      )
                                    : Text(
                                        "Total : $totalPrice + $deliveryCharge =  ${totalPrice + deliveryCharge} ৳",
                                        style:
                                            const TextStyle(color: textBlack),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 38,
                          width: 140,
                          margin: const EdgeInsets.only(left: 5, right: 5),
                          child: MaterialButton(
                            onPressed: () {
                              placeOrder();
                            },
                            color: Colors.green,
                            child: const Center(
                              child: Padding(
                                padding: EdgeInsets.only(left: 15, right: 15),
                                child: Text(
                                  "Place Order",
                                  style: TextStyle(color: textWhite),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
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
