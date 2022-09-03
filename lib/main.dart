import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/auth/splash_screen.dart';
import 'package:ui_test/modules/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var accessToken = prefs.getString("accessToken") ?? '';
  var refreshToken = prefs.getString("refreshToken") ?? '';
  runApp(MyApp(accessToken, refreshToken));
}

class MyApp extends StatelessWidget {
  final String accessToken;
  final String refreshToken;

  const MyApp(this.accessToken, this.refreshToken, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Arpan",
      theme: ThemeData(
        fontFamily: 'HindSiliguri',
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor),
      ),
      home: _getHome(accessToken, refreshToken),
    );
  }

  Widget _getHome(String accessToken, String refreshToken) {
    if (accessToken.isEmpty || refreshToken.isEmpty) {
      return const SplashScreen();
    } else {
      return const HomeScreen();
    }
  }
}
