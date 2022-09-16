import 'package:flutter/material.dart';
import 'package:ui_test/modules/auth/login_screen.dart';
import 'package:ui_test/modules/home/home_screen.dart';

import '../../global/utils/theme_data.dart';
import 'widgets/button_main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Offset offset = Offset.zero + const Offset(0, 1);
  double offsetButtons = 0.0;

  void startAnim() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        offset -= const Offset(0, 1);
      });
    });
  }

  void startButtonAnim() {
    setState(() {
      offsetButtons = 1.0;
    });
  }

  @override
  void initState() {
    super.initState();
    startAnim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgBlue,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(10),
                child: AnimatedSlide(
                  onEnd: startButtonAnim,
                  offset: offset,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInQuad,
                  child: const Image(
                    height: 120,
                    image: AssetImage("assets/images/arpan_logo.png"),
                  ),
                ),
              ),
              AnimatedOpacity(
                opacity: offsetButtons,
                duration: const Duration(milliseconds: 500),
                child: Column(
                    children: [
                    ButtonMain(
                    "Login",
                        () =>
                    {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                            const AuthMain()),
                        ModalRoute.withName('/auth'),
                      ),
                    }),
                ButtonMain("Go to home", () =>
                {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                        const HomeScreen()),
                    ModalRoute.withName('/'),
                  ),
                }),
            ],
          ),
        )
        ],
      ),
    ),)
    ,
    );
  }
}
