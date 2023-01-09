import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/global/models/settings_model.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/auth/services/auth_service.dart';
import 'package:ui_test/modules/auth/splash_screen.dart';
import 'package:ui_test/modules/home/home_screen.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'global/utils/router.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

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
  if (!kIsWeb) {
    await FirebaseMessaging.instance.subscribeToTopic("common_user");
  }
  runApp(MyApp(accessToken, refreshToken));
  if (refreshToken != "") {
    await AuthService().refreshTokens(refreshToken);
  }
}

class MyApp extends StatelessWidget {
  final String accessToken;
  final String refreshToken;
  static final RouteObserver<PageRoute> routeObserver =
  RouteObserver<PageRoute>();

  const MyApp(this.accessToken, this.refreshToken, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _initialRoute = Routes.splash;
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      _initialRoute = Routes.home;
    }
    return MaterialApp(
      title: "Arpan",
      theme: ThemeData(
        fontFamily: 'HindSiliguri',
        colorScheme: ColorScheme.fromSwatch().copyWith(primary: primaryColor),
      ),
      navigatorObservers: [routeObserver],
      navigatorKey: navigatorKey,
      onGenerateRoute: AppRouter.generateRoute,
      initialRoute: _initialRoute,
    );
  }

}
