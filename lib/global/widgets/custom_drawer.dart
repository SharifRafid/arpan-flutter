import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ui_test/modules/order/custom_order_screen.dart';
import 'package:ui_test/modules/order/medicine_order_screen.dart';
import 'package:ui_test/modules/order/parcel_order_screen.dart';
import 'package:ui_test/modules/order/pick_drop_order_screen.dart';
import '../../modules/order/all_orders_screen.dart';
import '../utils/theme_data.dart';

Widget customDrawer(BuildContext context){
  return ValueListenableBuilder<Box>(
      valueListenable: Hive.box('authBox').listenable(),
      builder: (context, box, widgetView){
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
                  color: bgGreyDeep,
                ),
                child: Center(
                  child: Image.asset(
                    "assets/images/cover_icon.png",
                    fit: BoxFit.cover,
                    height: 150,
                  ),
                ),
              ),
              box.get("accessToken",defaultValue: "") != "" && box.get("refreshToken",defaultValue: "") != "" ?
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('My Profile',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.person,
                    color: textWhite),
                onTap: () {

                },
              ):Container(),
              box.get("accessToken",defaultValue: "") != "" && box.get("refreshToken",defaultValue: "") != "" ?
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Previous orders',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.history,
                    color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const AllOrdersScreen())
                  );
                },
              ):Container(),
              box.get("accessToken",defaultValue: "") != "" && box.get("refreshToken",defaultValue: "") != "" ?
              const Divider() : Container(),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Custom Order',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.dashboard_customize,
                    color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const CustomOrderScreen())
                  );
                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Medicine',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.medical_services,
                    color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const MedicineOrderScreen())
                  );
                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Parcel',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.delivery_dining_rounded,
                    color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const ParcelOrderScreen())
                  );
                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Pick Up & Drop',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.cached_rounded,
                    color: textWhite),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute<void>(
                          builder: (BuildContext context) => const PickDropOrderScreen())
                  );
                },
              ),
              const Divider(),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Share App',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.share,
                    color: textWhite),
                onTap: () {

                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Rate App',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.star_rate,
                    color: textWhite),
                onTap: () {

                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Message us',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.messenger,
                    color: textWhite),
                onTap: () {

                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Call us',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.call,
                    color: textWhite),
                onTap: () {

                },
              ),
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Provide feedback',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.feedback,
                    color: textWhite),
                onTap: () {

                },
              ),
              const Divider(),
              box.get("accessToken",defaultValue: "") != "" && box.get("refreshToken",defaultValue: "") != "" ?
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Logout',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.logout,
                    color: textWhite),
                onTap: () {
                  Hive.box("authBox").clear();
                  Navigator.popAndPushNamed(context, "/");
                },
              ):
              ListTile(
                visualDensity: const VisualDensity(vertical: -3), // to compact
                dense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                title: const Text('Login',
                  style: TextStyle(color: textWhite,
                      fontSize: 15, fontWeight: FontWeight.bold),),
                leading: const Icon(Icons.login,
                    color: textWhite),
                onTap: () {
                  Navigator.popAndPushNamed(context, "/auth");
                },
              ),
            ],
          ),
        );
      });
}