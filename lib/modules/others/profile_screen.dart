import 'dart:collection';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_test/global/utils/constants.dart';
import 'package:ui_test/modules/others/services/others_service.dart';

import '../../global/utils/show_toast.dart';
import '../../global/utils/theme_data.dart';
import '../home/widgets/order_app_bar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool loading = true;
  XFile? image;
  String imageUrl = "";

  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  String oldName = "";
  String oldAddress = "";
  String name = "";
  String address = "";
  String phone = "";

  void updateProfile() async {
    var authBox = Hive.box('authBox');
    if (authBox.get("accessToken", defaultValue: "") == "" ||
        authBox.get("refreshToken", defaultValue: "") == "") {
      showLoginToast(context);
      return;
    }
    var name = nameController.text;
    var details = addressController.text;
    if (name.isEmpty || details.isEmpty) {
      if (!mounted) return;
      showToast(context, "Fill all the required details");
      return;
    }
    setState(() {
      loading = true;
    });
    HashMap<String, dynamic> hashMap = HashMap();
    hashMap["name"] = name.toString();
    hashMap["address"] = details.toString();
    String? status = await OthersService().updateProfile(hashMap, image);
    if (status == null) {
      if (!mounted) return;
      showToast(context, "Failed to submit, Try again please");
      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
        oldName = name;
        oldAddress = address;
        image = null;
        imageUrl = status;
      });
      if (!mounted) return;
      showToast(context, "Successfully updated profile.");
    }
  }

  void loadData() async {
    var authBox = Hive.box('authBox');
    if (authBox.get("accessToken", defaultValue: "") == "" ||
        authBox.get("refreshToken", defaultValue: "") == "") {
      showLoginToast(context);
      return;
    }
    HashMap<String, dynamic>? response = await OthersService().getProfile();
    if (response == null) {
      if (!mounted) return;
      showToast(context, "Failed to fetch data");
      return;
    }
    Hive.box('authBox').put("name", response["name"]);
    Hive.box('authBox').put("address", response["address"]);
    Hive.box('authBox').put("phone", response["phone"]);
    oldName = response["name"] ?? "";
    name = response["name"] ?? "";
    nameController.text = response["name"] ?? "";
    address = response["address"] ?? "";
    oldAddress = response["address"] ?? "";
    addressController.text = response["address"] ?? "";
    phone = response["phone"] ?? "";
    imageUrl = response["image"] ?? "";
    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedImage =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderAppBar(
        title: "My Profile",
        height: appBarHeight,
      ),
      backgroundColor: bgBlue,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 20,
                ),
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Card(
                    elevation: 0,
                    margin: const EdgeInsets.all(0),
                    color: bgBlue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                    child: InkWell(
                      onTap: () {
                        pickImage();
                      },
                      child: image == null
                          ? imageUrl == ""
                              ? const Icon(
                                  Icons.camera_alt,
                                  color: textWhite,
                                )
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      serverFilesBaseURL + imageUrl),
                                  child: Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 60,left: 60),
                                      child: Container(
                                        decoration: const BoxDecoration(
                                            color: Colors.red,
                                            borderRadius: BorderRadius.all(Radius.circular(20)
                                            )),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                                Icons.edit,
                                            size: 20,),
                                          )),
                                    ),
                                  ),)
                          : !kIsWeb
                              ? CircleAvatar(
                                  backgroundImage: FileImage(File(image!.path)))
                              : CircleAvatar(
                                  backgroundImage: NetworkImage(image!.path),
                                  child: Expanded(
                                    child: Container(
                                      padding: const EdgeInsets.only(top: 60,left: 60),
                                      child: Container(
                                          decoration: const BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.all(Radius.circular(20)
                                              )),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Icon(
                                              Icons.edit,
                                              size: 20,),
                                          )),
                                    ),
                                  )),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: bgOffWhite,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          )),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 20, bottom: 5),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 14),
                              controller: nameController,
                              onChanged: (text) {
                                setState(() {
                                  name = text;
                                });
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
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 5),
                            child: SizedBox(
                              height: 35,
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    isDense: false,
                                    labelText: 'Phone',
                                    contentPadding:
                                        EdgeInsets.only(left: 10, right: 10)),
                                child: Text(phone),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 15, bottom: 5),
                            child: TextFormField(
                              style: const TextStyle(fontSize: 14),
                              controller: addressController,
                              onChanged: (text) {
                                setState(() {
                                  address = text;
                                });
                              },
                              decoration: const InputDecoration(
                                contentPadding: EdgeInsets.all(8), // Added this
                                isDense: true,
                                border: OutlineInputBorder(),
                                labelText: 'Address',
                              ),
                            ),
                          ),
                          nameController.text.toString() != oldName ||
                                  addressController.text.toString() !=
                                      oldAddress ||
                                  image != null
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  height: 50,
                                  margin:
                                      const EdgeInsets.only(left: 5, right: 5),
                                  child: MaterialButton(
                                    onPressed: () {
                                      updateProfile();
                                    },
                                    color: Colors.green,
                                    child: const Center(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            left: 15, right: 15),
                                        child: Text(
                                          "Update",
                                          style: TextStyle(color: textWhite),
                                        ),
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
                  ),
                )
              ],
            ),
    );
  }
}
