import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/global/models/settings_model.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/auth/services/auth_service.dart';
import 'package:ui_test/modules/auth/splash_screen.dart';
import 'package:ui_test/modules/home/home_screen.dart';

import 'modules/auth/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(CartItemMainAdapter());
  Hive.registerAdapter((SettingsAdapter()));
  var box = await Hive.openBox('authBox');
  await Hive.openBox<Settings>('settingsBox');
  await Hive.openBox<CartItemMain>('cart');
  await Hive.openBox("bottomBarM");
  var accessToken = box.get("accessToken") ?? '';
  var refreshToken = box.get("refreshToken") ?? '';
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
