import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_test/modules/order/services/order_service.dart';

import '../../global/models/location_model.dart';
import '../../global/models/promo_code_model.dart';
import '../../global/utils/constants.dart';
import '../../global/utils/show_toast.dart';
import '../../global/utils/theme_data.dart';
import '../../global/utils/utils.dart';
import '../home/services/home_service.dart';
import '../home/widgets/order_app_bar.dart';
import 'all_orders_screen.dart';
import 'widgets/promo_code_block_custom.dart';

class CustomOrderScreen extends StatefulWidget {
  const CustomOrderScreen({Key? key}) : super(key: key);

  @override
  State<CustomOrderScreen> createState() => _CustomOrderScreenState();
}

class _CustomOrderScreenState extends State<CustomOrderScreen> {
  final orderService = OrderService();
  final homeService = HomeService();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();
  TextEditingController orderMainController = TextEditingController();

  List<Location> _locationsArray = [];
  Location _selectedLocation = Location();

  PaymentMethod? _paymentMethod = PaymentMethod.COD;
  Promo? promoCode;
  XFile? image;

  bool loading = true;

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
    var details = orderMainController.text;
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
    if (details.isEmpty && image == null) {
      showToast(context,
          "Please add at least one image and/or details about your order");
      return;
    }
    setState(() {
      loading = true;
    });
    HashMap<String, dynamic> hashMap = HashMap();
    hashMap["name"] = name.toString();
    hashMap["customOrder"] = true;
    hashMap["phone"] = phone.toString();
    hashMap["address"] = address.toString();
    hashMap["note"] = note.toString();
    hashMap["customOrderDetails"] = details.toString();
    if (promoCode != null) {
      hashMap["promo"] = promoCode!.id;
    }
    hashMap["location"] = _selectedLocation.id;
    hashMap["payment"] =
        _paymentMethod == PaymentMethod.bKash ? "bKash" : "COD";
    String? orderId = await orderService.placeCustomOrder(hashMap, image);
    if (orderId == null) {
      if (!mounted) return;
      showToast(context, "Failed to place order");
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      print(orderId);
      box.clear();
      if (!mounted) return;
      showToast(context, "Successfully placed order");
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => const AllOrdersScreen()));
    }
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    print(pickedImage);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  void calculateTotalPrices() {
    int dc = _selectedLocation.deliveryCharge!;

    if (promoCode != null) {
      if (promoCode!.deliveryDiscount == true) {
        if (promoCode!.discountPrice! > dc) {
          dc = 0;
        } else {
          dc = dc - promoCode!.discountPrice!;
        }
      }
    }

    setState(() {
      deliveryCharge = dc;
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
        orderMainController.text = box.get("orderDetails", defaultValue: "");
      }
    }
  }

  void openBox() async {
    box = await Hive.openBox("orderInputs");
    getLocationsResponse();
  }

  @override
  void initState() {
    super.initState();
    openBox();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderAppBar(
        title: "Custom Order",
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
                      height: 120,
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          TextFormField(
                            expands: true,
                            onChanged: (text) {
                              box.put("orderDetails", text.toString());
                            },
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            controller: orderMainController,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.all(8), // A
                              isDense: true,
                              border: OutlineInputBorder(),
                              labelText: 'Details',
                            ),
                          ),
                          SizedBox(
                            width: 75,
                            height: 65,
                            child: Card(
                              elevation: 0,
                              margin: const EdgeInsets.all(0),
                              color: bgBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              child: InkWell(
                                onTap: () {
                                  pickImage();
                                },
                                child: image == null
                                    ? const Icon(
                                        Icons.camera_alt,
                                        color: textWhite,
                                      )
                                    : Image.file(File(image!.path)),
                              ),
                            ),
                          ),
                        ],
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
                      ? const Text(
                          "Extra charges maybe added for bKash payments",
                          style: TextStyle(color: Colors.pink),
                        )
                      : Container(),
                  PromoCodeBlockCustom(deliveryCharge, (id) {
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
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                    color: Colors.green, width: 2)),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: _paymentMethod == PaymentMethod.bKash
                                    ? Text(
                                        "Delivery charge : ${deliveryCharge + (deliveryCharge * bkashMultiplier).toInt()} ৳",
                                        style:
                                            const TextStyle(color: textBlack),
                                      )
                                    : Text(
                                        "Delivery charge : $deliveryCharge ৳",
                                        style:
                                            const TextStyle(color: textBlack),
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 38,
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
