import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ui_test/global/utils/show_toast.dart';
import 'package:ui_test/modules/order/custom_order_screen.dart';
import 'package:ui_test/modules/order/medicine_order_screen.dart';
import 'package:ui_test/modules/order/parcel_order_screen.dart';
import 'package:ui_test/modules/order/pick_drop_order_screen.dart';
import 'package:ui_test/modules/others/feedback_screen.dart';
import 'package:ui_test/modules/others/profile_screen.dart';
import 'package:ui_test/modules/others/services/others_service.dart';
import '../../modules/auth/login_screen.dart';
import '../../modules/order/all_orders_screen.dart';
import '../utils/theme_data.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Widget customDrawer(BuildContext context) {
  return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('authBox').listenable(),
      builder: (context, box, widgetView) {
        return Drawer(
          backgroundColor: bgBlue,
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            children: [
              DrawerHeader(
                padding: const EdgeInsets.all(0),
                decoration: const BoxDecoration(
                  color: bgBlue,
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/arpan_logo.png",
                    fit: BoxFit.cover,
                    height: 90,
                  ),
                ),
              ),
              const Divider(color: bgGreyDeep,),
              box.get("accessToken", defaultValue: "") != "" &&
                      box.get("refreshToken", defaultValue: "") != ""
                  ? ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      // to compact
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16.0),
                      title: const Text(
                        'My Profile',
                        style: TextStyle(
                            color: textWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(Icons.person, color: textWhite),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const ProfileScreen()));
                      },
                    )
                  : Container(),
              box.get("accessToken", defaultValue: "") != "" &&
                      box.get("refreshToken", defaultValue: "") != ""
                  ? ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      // to compact
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16.0),
                      title: const Text(
                        'My Orders',
                        style: TextStyle(
                            color: textWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(Icons.history, color: textWhite),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                                builder: (BuildContext context) =>
                                    const AllOrdersScreen()));
                      },
                    )
                  : Container(),
              box.get("accessToken", defaultValue: "") != "" &&
                      box.get("refreshToken", defaultValue: "") != ""
                  ?const Divider(color: bgGreyDeep,)
                  : Container(),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                // to compact
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text(
                  'Custom Order',
                  style: TextStyle(
                      color: textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                leading:
                    const Icon(Icons.dashboard_customize, color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const CustomOrderScreen()));
                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                // to compact
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text(
                  'Medicine',
                  style: TextStyle(
                      color: textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.medical_services, color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const MedicineOrderScreen()));
                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                // to compact
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text(
                  'Parcel',
                  style: TextStyle(
                      color: textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                leading:
                    const Icon(Icons.delivery_dining_rounded, color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const ParcelOrderScreen()));
                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                // to compact
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text(
                  'Pick Up & Drop',
                  style: TextStyle(
                      color: textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.cached_rounded, color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const PickDropOrderScreen()));
                },
              ),
              const Divider(color: bgGreyDeep,),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                // to compact
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text(
                  'Share App',
                  style: TextStyle(
                      color: textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.share, color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Share.share('Check out Arpan https://arpan.delivery');
                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                // to compact
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text(
                  'Rate App',
                  style: TextStyle(
                      color: textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.star_rate, color: textWhite),
                onTap: () async {
                  Navigator.pop(context);
                  final Uri _url = Uri.parse(
                      'https://play.google.com/store/apps/details?id=arpan.delivery&hl=en&gl=US');
                  !await launchUrl(_url);
                },
              ),
              // ListTile(
              //   visualDensity: const VisualDensity(vertical: -3),
              //   // to compact
              //   dense: true,
              //   contentPadding:
              //       const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              //   title: const Text(
              //     'Message us',
              //     style: TextStyle(
              //         color: textWhite,
              //         fontSize: 15,
              //         fontWeight: FontWeight.bold),
              //   ),
              //   leading: const Icon(Icons.messenger, color: textWhite),
              //   onTap: () async {
              //     Navigator.pop(context);
              //     final Uri _url = Uri.parse('https://m.me/101457328287762');
              //     !await launchUrl(_url);
              //   },
              // ),
              // kIsWeb
              //     ? Container()
              //     : ListTile(
              //         visualDensity: const VisualDensity(vertical: -3),
              //         // to compact
              //         dense: true,
              //         contentPadding: const EdgeInsets.symmetric(
              //             vertical: 0.0, horizontal: 16.0),
              //         title: const Text(
              //           'Call us',
              //           style: TextStyle(
              //               color: textWhite,
              //               fontSize: 15,
              //               fontWeight: FontWeight.bold),
              //         ),
              //         leading: const Icon(Icons.call, color: textWhite),
              //         onTap: () async {
              //           Navigator.pop(context);
              //           await FlutterPhoneDirectCaller.callNumber(
              //               "+8801845568015");
              //         },
              //       ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3),
                // to compact
                dense: true,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text(
                  'Message Us',
                  style: TextStyle(
                      color: textWhite,
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                leading: const Icon(Icons.feedback, color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const FeedbackScreen()));
                },
              ),
              // const Divider(),
              // ListTile(
              //   visualDensity: const VisualDensity(vertical: -3),
              //   // to compact
              //   dense: true,
              //   contentPadding:
              //       const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              //   title: const Text(
              //     'About Arpan',
              //     style: TextStyle(
              //         color: textWhite,
              //         fontSize: 15,
              //         fontWeight: FontWeight.bold),
              //   ),
              //   leading: const Icon(Icons.info, color: textWhite),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute<void>(
              //             builder: (BuildContext context) =>
              //                 const AboutScreen()));
              //   },
              // ),
              // ListTile(
              //   visualDensity: const VisualDensity(vertical: -3),
              //   // to compact
              //   dense: true,
              //   contentPadding:
              //       const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
              //   title: const Text(
              //     'Become a client',
              //     style: TextStyle(
              //         color: textWhite,
              //         fontSize: 15,
              //         fontWeight: FontWeight.bold),
              //   ),
              //   leading: const Icon(Icons.person_add_alt_1_rounded,
              //       color: textWhite),
              //   onTap: () {
              //     Navigator.pop(context);
              //     Navigator.push(
              //         context,
              //         MaterialPageRoute<void>(
              //             builder: (BuildContext context) =>
              //                 const BeClientScreen()));
              //   },
              // ),
              const Divider(color: bgGreyDeep,),
              box.get("accessToken", defaultValue: "") != "" &&
                      box.get("refreshToken", defaultValue: "") != ""
                  ? ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      // to compact
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16.0),
                      title: const Text(
                        'Logout',
                        style: TextStyle(
                            color: textWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(Icons.logout, color: textWhite),
                      onTap: () {
                        Navigator.pop(context);
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text("Logout !?"),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: const <Widget>[
                                    Text("Are you sure you want to logout?"),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('Yes'),
                                  onPressed: () async {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute<void>(
                                            builder: (BuildContext context) =>
                                                const AuthMain()),
                                        (route)=>false);
                                    String accessToken = box.get("accessToken",
                                        defaultValue: "");
                                    HashMap<String, dynamic> hashMap =
                                        HashMap();
                                    hashMap["refreshToken"] = box
                                        .get("refreshToken", defaultValue: "");
                                    hashMap["registrationToken"] =
                                        box.get("FCMTOKEN", defaultValue: "");
                                    box.clear();
                                    showToast(
                                        context, "Logged out successfully.");
                                    await OthersService()
                                        .logout(hashMap, accessToken);
                                  },
                                ),
                                TextButton(
                                  child: const Text('No'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  : ListTile(
                      visualDensity: const VisualDensity(vertical: -3),
                      // to compact
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0.0, horizontal: 16.0),
                      title: const Text(
                        'Login',
                        style: TextStyle(
                            color: textWhite,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      ),
                      leading: const Icon(Icons.login, color: textWhite),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                              builder: (BuildContext context) =>
                                  const AuthMain()),
                        );
                      },
                    ),
            ],
          ),
        );
      });
}
