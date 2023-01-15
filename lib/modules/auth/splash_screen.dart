import 'package:flutter/material.dart';
import 'package:Arpan/global/utils/router.dart';

import '../../global/utils/theme_data.dart';
import '../../main.dart';
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
                        () => {
                              navigatorKey.currentState
                                  ?.pushReplacementNamed(Routes.login),
                            }),
                    // ButtonMain("Go to home", () =>
                    // {
                    //   Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //         const HomeScreen()),
                    //     ModalRoute.withName('/'),
                    //   ),
                    // }),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
