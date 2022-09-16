import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/auth/services/auth_service.dart';
import 'package:ui_test/modules/auth/splash_screen.dart';
import 'package:ui_test/modules/home/home_screen.dart';

import 'modules/auth/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemMainAdapter());
  var box = await Hive.openBox('authBox');
  await Hive.openBox<CartItemMain>('cart');
  var accessToken = box.get("accessToken") ?? '';
  var refreshToken = box.get("refreshToken") ?? '';
  runApp(MyApp(accessToken, refreshToken));
  if(refreshToken != ""){
    await AuthService().refreshTokens(refreshToken);
  }
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
      routes: {
        '/auth': (context) => const AuthMain(),
      },
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
