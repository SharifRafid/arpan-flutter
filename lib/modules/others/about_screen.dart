import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ui_test/modules/others/services/others_service.dart';

import '../../global/utils/show_toast.dart';
import '../../global/utils/theme_data.dart';
import '../home/widgets/order_app_bar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderAppBar(
        title: "About Arpan",
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
                "অর্পণ নিয়ে নানা জিজ্ঞাসা আমাদের মনে চলেই আসে। তাই আপনাদের সেসব অজানাকে জানাতে, অর্পণকে আপনাদের সাথে পরিচয় করিয়ে দেবার জন্য অর্পণেরর কিছু কথাঃ",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: Text(
                "(১) অর্পণ কি এবং কেন?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 10),
              child: Text(
                "অর্পণ মাগুরা শহরের একটি আস্থানির্ভর হোমডেলিভারি সার্ভিস ও কিছু বিশেষ পণ্যের অনলাইন শপ। রোজকার ব্যস্ততম জীবনে প্রয়োজনীয় পণ্যগুলো সংগ্রহ করতে আমাদের প্রত্যেককেই ছুটতে হয় ঘরের বাইরে।  কিন্তু যদি আপনাদের সেই প্রয়োজনগুলোকে অর্পণ পৌঁছে দেয় ঠিক আপনার দরজায়, তাহলে কেমন হয়? একদম ঠিক তাই। আনায়াসে আয়েশ করবার অর্পণের এই প্রয়াস জারি থাকবে আপনাদের জন্য, শুধুমাত্র প্রিয় মাগুরাবাসীর জন্য। আপনাদের প্রয়োজনীয় পণ্যগুলো  নির্ধারণ করে আমাদের অ্যাপে/পেজের ইনবক্সে বা পেজে দেওয়া নম্বরে জানান। আমরা পৌঁছে দেবো সেই পণ্য আপনার ঠিকানায়। শুধু তাই নয়, অর্পণে আপনারা পাবেন বাজার থেকে সুলভ মূল্যে ঘরেই বসেই আপনার চাহিদা মতন কিছু বিশেষ পণ্যের হোম ডেলিভারি। পণ্যগুলো সম্পর্কে জানতে দেখে নিন অ্যাপের অর্পণ শপ সেকশনটি।",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: Text(
                "(২) আপনাদের সেবা কোথায় কোথায় চালু থাকবে? ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 10),
              child: Text(
                "অর্পণের এই ডেলিভারি সেবা চালু থাকবে কেবলমাত্র মাগুরা জেলায় বসবাসকারি নাগরিকদের জন্য। আর অর্পণের নিজস্ব পণ্যগুলোও আপনারা পেয়ে যাবেন মাগুরা শহরে ও মাগুরা জেলার অর্পণের নির্ধারিত ডেলিভারি পয়েন্টগুলোতে।",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: Text(
                "(৩) পণ্য কিভাবে খুঁজব এবং কিভাবে অর্ডার করবো?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 10),
              child: Text(
                " অর্পণের নিজস্ব পণ্যগুলো অর্ডার করার জন্য চোখ রাখুন অর্পণ অ্যাপের ”অর্পণ শপ” সেকশনে অথবা অফিশিয়াল ফেসবুক পেজে। ”অর্পণ শপ” সেকশন থেকে আপনার পছন্দের পণ্যটি অর্ডার করুন সহজেই। অর্পণের পণ্য ব্যতীত আপনার অন্য প্রয়োজনীয় পণ্যের ডেলিভারি পেতে সেই প্রয়োজনীয় পণ্যের একটি তালিকা তৈরি করে সেই তালিকা আমাদেরকে ইনবক্সে পাঠিয়ে দিন অথবা অ্যাপের ”কাস্টম অর্ডার”  থেকে অর্ডার করুন। যদি আপনার কোন নির্দিষ্ট দোকানের পণ্যের চাহিদা থাকে সেক্ষেত্রে সেটিও উল্লেখ করলে, অর্পণ চেষ্টা করবে আপনার দরকারি পণ্যগুলো আপনার পছন্দের দোকান থেকে সংগ্রহ করে পৌঁছে দেবার জন্য। আর যদি দোকানে নির্বাচনের ক্ষেত্রে আপনার কোন চাহিদা না থাকে সেক্ষেত্রে অর্পণ নিজ দায়িত্বে আপনার পণ্য পৌঁছে দেবে আপনার নিকট।",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: Text(
                "(৪) কিভাবে পেমেন্ট করব?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 10),
              child: Text(
                " ক্যাশ অন ডেলিভারি পদ্ধতিতে অর্পণ পেমেন্ট গ্রহণ করে থাকে। আপনার দেওয়া অর্ডারটি অর্পণের নির্ধারিত ডেলিভারি এজেন্ট (ডিএ) থেকে গ্রহণ করবার পর তার হাতেই পেমেন্টটি করতে হবে। এছাড়াও বিকাশ/রকেট/নগদের মাধ্যমেও আপনারা আপনাদের পণ্যের পেমেন্ট করতে পারবেন একদম নিশ্চিন্তে।",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: Text(
                "(৫) কিভাবে ডেলিভারি করা হয় এবং খরচ কত?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 10),
              child: Text(
                "অর্পণ পরিবারের নির্বাচিত ডেলিভারি এজেন্ট (ডিএ) দের মাধ্যমে ডেলিভারি দেওয়া হয়ে থাকে। প্রতিবার অর্ডারে ডেলিভারি বাবদ চার্জ শহরের মধ্যে মাত্র ৪০ টাকা। অর্থাৎ নির্ধারিত পণ্যের মূল্যের সাথে ডেলিভারি চার্জবাবদ আরো ৪০ টাকা প্রদান করতে হবে। এ ছাড়াও শহরের বাইরে মাগুরা জেলার অন্যান্য জায়গায় রয়েছে অর্পণের কিছু ডেলিভারি পয়েন্ট (বিস্তারিত জানতে অনুগ্রহ করে ইনবক্স করুন)।",
                style: TextStyle(fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 15, bottom: 5),
              child: Text(
                "(৬) অর্পণের নিজস্ব পণ্য অর্ডারের ক্ষেত্রে কি কোন শর্তাবলি রয়েছে?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  left: 10, right: 10, top: 5, bottom: 10),
              child: Text(
                "অর্পণের নিজস্ব পণ্যগুলো অর্ডার করবার ক্ষেত্রে অনুগ্রহ করে প্রি-অর্ডারের মাধ্যমে অর্ডারটি কনফার্ম করুন। আপনি অর্ডারটি কনফার্ম করার এক সপ্তাহের মধ্যেই পণ্যটি পৌঁছে যাবে আপনার ঠিকানায়। আর পণ্যটি আমাদের স্টকে থাকলে সঙ্গে সঙ্গেই পেয়ে যাবেন হোমডেলিভারি।",
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
