import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'ui/resources/colored_status_bar.dart';
import 'ui/resources/theme_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: mainThemeData,
      home: ColoredStatusBar(
        key: const Key("main_colored_status_bar"),
        color: MainColors.blue,
        child: mainContent(),
      ),
    );
  }
}

Widget mainContent() {
  return Scaffold(
    backgroundColor: MainColors.blue,
    body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Image(
          width: 600,
          height: 120,
          image: AssetImage('assets/images/arpan_logo.png'),
        ),
        Container(
          margin: const EdgeInsets.only(top: 40),
          child: SizedBox(
              height: 43,
              width: 220,
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(20, 0, 20, 0)),
                  backgroundColor: MaterialStateProperty.all<Color>(MainColors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'রেজিস্টার/লগইন করুন',
                    style: TextStyle(
                        color: MainColors.blue,
                        fontSize: 16
                    ),
                  ),
                ),
                onPressed: () {},
              )
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: SizedBox(
              height: 43,
              width: 220,
              child: ElevatedButton(
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(0, 0)),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      const EdgeInsets.fromLTRB(10, 0, 10, 0)),
                  backgroundColor: MaterialStateProperty.all<Color>(MainColors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'রেজিস্ট্রেশন ছাড়াই ব্যবহার করুন',
                    style: TextStyle(
                        color: MainColors.blue,
                        fontSize: 16
                    ),
                  ),
                ),
                onPressed: () {},
              )
          ),
        ),
      ],
    ),
  );
}
