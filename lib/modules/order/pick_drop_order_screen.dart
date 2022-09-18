import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_test/modules/order/services/order_service.dart';

import '../../global/models/location_model.dart';
import '../../global/utils/constants.dart';
import '../../global/utils/show_toast.dart';
import '../../global/utils/theme_data.dart';
import '../../global/utils/utils.dart';
import '../home/services/home_service.dart';
import '../home/widgets/order_app_bar.dart';
import 'all_orders_screen.dart';

class PickDropOrderScreen extends StatefulWidget {
  const PickDropOrderScreen({Key? key}) : super(key: key);

  @override
  State<PickDropOrderScreen> createState() => _PickDropOrderScreenState();
}

class _PickDropOrderScreenState extends State<PickDropOrderScreen> {
  final orderService = OrderService();
  final homeService = HomeService();

  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  TextEditingController nameControllerReceiver = TextEditingController();
  TextEditingController phoneControllerReceiver = TextEditingController();
  TextEditingController addressControllerReceiver = TextEditingController();

  TextEditingController parcelDetails = TextEditingController();

  List<Location> _locationsArray = [];
  Location _selectedLocation = Location();
  Location _selectedLocationReceiver = Location();

  PaymentMethod? _paymentMethod = PaymentMethod.COD;
  XFile? image;

  bool loading = true;

  int deliveryCharge = 0;

  late Box box;

  void placeOrder() async {
    var authBox = Hive.box('authBox');
    if (authBox.get("accessToken", defaultValue: "") == "" ||
        authBox.get("refreshToken", defaultValue: "") == "") {
      showLoginToast(context);
      return;
    }
    var name = nameController.text;
    var phone = phoneController.text;
    var address = addressController.text;
    var nameReceiver = nameControllerReceiver.text;
    var phoneReceiver = phoneControllerReceiver.text;
    var addressReceiver = addressControllerReceiver.text;
    var details = parcelDetails.text;
    if (name.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        nameReceiver.isEmpty ||
        phoneReceiver.isEmpty ||
        addressReceiver.isEmpty) {
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
    if (!isNumeric(phoneReceiver.toString())) {
      if (!mounted) return;
      showToast(context, "Enter a valid phone number");
      return;
    }
    if (phoneReceiver.toString().length != 11) {
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
    hashMap["phone"] = phone.toString();
    hashMap["pickDropOrder"] = true;
    hashMap["address"] = address.toString();
    hashMap["nameReceiver"] = nameReceiver.toString();
    hashMap["phoneReceiver"] = phoneReceiver.toString();
    hashMap["addressReceiver"] = addressReceiver.toString();
    hashMap["locationReceiver"] = _selectedLocationReceiver.id;
    hashMap["pickDropParcelDetails"] = details.toString();
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
      debugPrint(orderId);
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
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
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
        _selectedLocation = response[0];
        _selectedLocationReceiver = response[0];
        if (response.isNotEmpty) {
          _selectedLocation = response[0];
        }
        setState(() {
          loading = false;
        });
        nameController.text = box.get("name", defaultValue: "");
        phoneController.text = box.get("phone", defaultValue: "");
        addressController.text = box.get("address", defaultValue: "");
        nameControllerReceiver.text = box.get("nameReceiver", defaultValue: "");
        phoneControllerReceiver.text =
            box.get("phoneReceiver", defaultValue: "");
        addressControllerReceiver.text =
            box.get("addressReceiver", defaultValue: "");
        parcelDetails.text = box.get("pickDropParcelDetails", defaultValue: "");
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
        title: "Pick-Up & Drop",
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
                        labelText: 'Sender Name',
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
                        labelText: 'Sender Phone',
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
                        labelText: 'Sender Address',
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
                              box.put("pickDropParcelDetails", text.toString());
                            },
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            textAlignVertical: TextAlignVertical.top,
                            controller: parcelDetails,
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
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 5),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      controller: nameControllerReceiver,
                      onChanged: (text) {
                        box.put("nameReceiver", text.toString());
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8), // Added this
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Receiver Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      controller: phoneControllerReceiver,
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        box.put("phoneReceiver", text.toString());
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8), // A
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Receiver Phone',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      controller: addressControllerReceiver,
                      onChanged: (text) {
                        box.put("addressReceiver", text.toString());
                      },
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8), // A
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Receiver Address',
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
                          value: _selectedLocationReceiver,
                          icon: const Icon(Icons.keyboard_arrow_down_outlined),
                          elevation: 16,
                          isExpanded: true,
                          borderRadius: BorderRadius.circular(10),
                          style: const TextStyle(color: textBlack),
                          onChanged: (Location? value) {
                            // This is called when the user selects an item.
                            setState(() {
                              _selectedLocationReceiver = value!;
                            });
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
                              const Text("Cash On Delivery"),
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
                                child: _locationsArray.indexOf(_selectedLocation) == 0
                                    ? _paymentMethod == PaymentMethod.bKash
                                        ? Text(
                                            "Delivery charge : ${_selectedLocationReceiver.deliveryCharge! + (_selectedLocationReceiver.deliveryCharge! * bkashMultiplier).toInt()} ৳",
                                            style: const TextStyle(
                                                color: textBlack),
                                          )
                                        : Text(
                                            "Delivery charge : ${_selectedLocationReceiver.deliveryCharge} ৳",
                                            style: const TextStyle(
                                                color: textBlack),
                                          )
                                    : const Text(
                                        "Delivery charge will be informed by call",
                                        style: TextStyle(color: textBlack),
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
