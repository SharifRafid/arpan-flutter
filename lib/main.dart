import 'package:arpan_app_new/services/auth/auth_service.dart';
import 'package:arpan_app_new/ui/auth/auth_main.dart';
import 'package:arpan_app_new/ui/main/home_page_main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'ui/auth/auth_wrapper.dart';
import 'ui/resources/colored_status_bar.dart';
import 'ui/resources/theme_data.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: mainThemeData,
        home: ColoredStatusBar(
          key: const Key("main_colored_status_bar"),
          color: MainColors.blue,
          child: mainContent(),
        ),
        initialRoute: '/',
        routes: {
          '/auth' : (context) => AuthMain(),
          '/homePage' : (context) => const HomePageMain(),
        },
      ),
    );
  }
}

Widget mainContent() {
  return const AuthenticationWrapper();
}
