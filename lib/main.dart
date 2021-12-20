import 'package:arpan_app_new/ui/auth/auth_main.dart';
import 'package:arpan_app_new/ui/main/home_page_main.dart';
import 'package:arpan_app_new/ui/onboard/on_board_page.dart';
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
      initialRoute: '/',
      routes: {
        '/auth' : (context) => const AuthMain(),
        '/homePage' : (context) => const HomePageMain(),
      },
    );
  }
}

Widget mainContent() {
  return const OnBoardPage();
}
