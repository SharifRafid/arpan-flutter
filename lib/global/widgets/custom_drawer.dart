import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../modules/order/all_orders_screen.dart';
import '../utils/theme_data.dart';

Widget customDrawer(BuildContext context){
  return Drawer(
    backgroundColor: bgBlue,
    // Add a ListView to the drawer. This ensures the user can scroll
    // through the options in the drawer if there isn't enough vertical
    // space to fit everything.
    child: ListView(
      // Important: Remove any padding from the ListView.
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: bgGreyDeep,
          ),
          child: Center(
            child: Image.asset(
              "assets/images/cover_icon.png",
              height: 80,
            ),
          ),
        ),
        ListTile(
          title: const Text('My Profile',
            style: TextStyle(color: textWhite,
                fontSize: 15, fontWeight: FontWeight.bold),),
          leading: const Icon(Icons.person,
              color: textWhite),
          onTap: () {

          },
        ),
        ListTile(
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
        ),
        const Divider(),
        ListTile(
          title: const Text('Custom Order',
            style: TextStyle(color: textWhite,
                fontSize: 15, fontWeight: FontWeight.bold),),
          leading: const Icon(Icons.dashboard_customize,
              color: textWhite),
          onTap: () {

          },
        ),
        ListTile(
          title: const Text('Medicine',
            style: TextStyle(color: textWhite,
                fontSize: 15, fontWeight: FontWeight.bold),),
          leading: const Icon(Icons.medical_services,
              color: textWhite),
          onTap: () {

          },
        ),
        ListTile(
          title: const Text('Parcel',
            style: TextStyle(color: textWhite,
                fontSize: 15, fontWeight: FontWeight.bold),),
          leading: const Icon(Icons.delivery_dining_rounded,
              color: textWhite),
          onTap: () {

          },
        ),
        ListTile(
          title: const Text('Pick Up & Drop',
            style: TextStyle(color: textWhite,
                fontSize: 15, fontWeight: FontWeight.bold),),
          leading: const Icon(Icons.cached_rounded,
              color: textWhite),
          onTap: () {

          },
        ),
        const Divider(),
        ListTile(
          title: const Text('Share App',
            style: TextStyle(color: textWhite,
                fontSize: 15, fontWeight: FontWeight.bold),),
          leading: const Icon(Icons.share,
              color: textWhite),
          onTap: () {

          },
        ),
        ListTile(
          title: const Text('Rate App',
            style: TextStyle(color: textWhite,
                fontSize: 15, fontWeight: FontWeight.bold),),
          leading: const Icon(Icons.star_rate,
              color: textWhite),
          onTap: () {

          },
        ),
        const Divider(),
        ListTile(
          title: const Text('Logout',
            style: TextStyle(color: textWhite,
                fontSize: 15, fontWeight: FontWeight.bold),),
          leading: const Icon(Icons.logout,
              color: textWhite),
          onTap: () {
            Hive.box("authBox").clear();
            Navigator.popAndPushNamed(context, "/");
          },
        ),
      ],
    ),
  );
}