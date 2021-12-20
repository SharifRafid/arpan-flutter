import 'dart:ffi';

import 'package:arpan_app_new/ui/resources/theme_data.dart';
import 'package:flutter/material.dart';

class OnBoardPage extends StatefulWidget {
  const OnBoardPage({Key? key}) : super(key: key);

  @override
  _OnBoardPageState createState() => _OnBoardPageState();
}

class _OnBoardPageState extends State<OnBoardPage> {
  bool showButtons = false;

  void showBtns(bool visibility){
    setState(() {
      showButtons = visibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 1000),(){
      showBtns(true);
    });
    return Scaffold(
      backgroundColor: MainColors.blue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 1000),
            child: GestureDetector(
                onTap: () {
                }, // Image tapped
                child: const Image(
                  width: 600,
                  height: 120,
                  image: AssetImage('assets/images/arpan_logo.png'),
                )
            ),
          ),
          showButtons ?
          buttonOnBoard('রেজিস্টার/লগইন করুন', 43, 220, false, context) :
          buttonOnBoard('রেজিস্টার/লগইন করুন', 0, 0, false, context),
          showButtons ?
          buttonOnBoard('রেজিস্ট্রেশন ছাড়াই ব্যবহার করুন', 43, 220, true, context) :
          buttonOnBoard('রেজিস্ট্রেশন ছাড়াই ব্যবহার করুন', 0, 0, true, context),
        ],
      ),
    );
  }
}

Widget buttonOnBoard(String title, double height, double width,
    bool home, BuildContext context){
  return AnimatedContainer(
    height: height,
    width: width,
    duration: const Duration(milliseconds: 1000),
    margin: const EdgeInsets.only(top: 20),
    child: SizedBox(
        height: 43, //43
        width: 220, //220
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
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: MainColors.blue,
                  fontSize: 16
              ),
            ),
          ),
          onPressed: () {
            if(home){
              Navigator.pushNamed(context, '/homePage');
            }else{
              Navigator.pushNamed(context, '/auth');
            }
          },
        )
    ),
  );
}