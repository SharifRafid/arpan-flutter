import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:Arpan/modules/others/services/others_service.dart';

import '../../global/utils/show_toast.dart';
import '../../global/utils/theme_data.dart';
import '../home/widgets/order_app_bar.dart';

class BeClientScreen extends StatelessWidget {
  const BeClientScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderAppBar(
        title: "Become a client",
        height: appBarHeight,
      ),
      backgroundColor: bgOffWhite,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/cover_icon.png",
              fit: BoxFit.cover,
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: Text(
                "আস্সালামু আলাইকুম",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 10),
              child: Text(
                "আপনার কি রয়েছে কোন হোমমেড খাবার, কেক, জুয়েলারি কিংবা অন্য কোন পণ্যসামগ্রির অনলাইন ব্যবসা? তাহলে আপনার পণ্যগুলো আপনার ক্রেতার কাছে ডেলিভারি করবার জন্য রয়েছে অর্পণের ক্লায়েন্ট প্যাকেজ। অর্পণের ক্লায়েন্ট প্যাকেজ গ্রহণ করুন আর নিশ্চিন্তে নিজের পণ্যটি নিজের ক্রেতার কাছে আস্থার সাথে পৌঁছে দেবার দায়িত্ব অর্পণকে প্রদান করুন। অর্পণের ক্লায়েন্ট প্যাকেজ গ্রহণ করার জন্য ইনবক্স করুন অথবা কল করুন।",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: Text(
                "আপনাদের আস্থাই অর্পণের অর্জন",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
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
