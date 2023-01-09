import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ui_test/modules/auth/login_screen.dart';
import 'package:ui_test/modules/auth/splash_screen.dart';
import 'package:ui_test/modules/home/cart_screen.dart';
import 'package:ui_test/modules/home/home_screen.dart';
import 'package:ui_test/modules/home/products_screen.dart';
import 'package:ui_test/modules/order/all_orders_screen.dart';
import 'package:ui_test/modules/order/custom_order_screen.dart';
import 'package:ui_test/modules/order/medicine_order_screen.dart';
import 'package:ui_test/modules/order/order_details_screen.dart';
import 'package:ui_test/modules/order/order_screen.dart';
import 'package:ui_test/modules/order/parcel_order_screen.dart';
import 'package:ui_test/modules/order/pick_drop_order_screen.dart';
import 'package:ui_test/modules/others/be_client_screen.dart';
import 'package:ui_test/modules/others/feedback_screen.dart';
import 'package:ui_test/modules/others/profile_screen.dart';

import '../../modules/others/about_screen.dart';

/// Static class that contains all the route information of the application.
///
/// To register a new route, first a constant string with the route's name
/// and value must be assigned
///```dart
/// Class Routes {
///   static const ....;
///   static const newRoute = '/new_route';
/// ...
/// }
///```
class Routes {
  static const splash = '/splash';
  static const test = '/test';
  static const home = '/';
  static const login = '/login';
  static const products = '/products';
  static const cart = '/cart';
  static const order = '/order';
  static const pastOrders = '/past-orders';
  static const orderDetails = '/order-details';
  static const customOrder = '/custom-order';
  static const medicineOrder = '/medicine-order';
  static const parcelOrder = '/parcel-order';
  static const pickUpAndDrop = '/pick-drop-order';
  static const beClient = '/be-client';
  static const feedback = '/feedback';
  static const profile = '/profile';
  static const about = '/about';
}

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    var box = Hive.box('authBox');
    var accessToken = box.get("accessToken") ?? '';
    var refreshToken = box.get("refreshToken") ?? '';
    debugPrint('Generate Route: ${settings.name}');
    if (accessToken == null || refreshToken == null) {
      if (settings.name != Routes.login) {
        settings = settings.copyWith(name: Routes.login);
      }
    }

    final routeName = settings.name;

    switch (routeName) {
      case Routes.splash:
        return _generateRoute(settings, const SplashScreen());
      case Routes.home:
        return _generateRoute(settings, const HomeScreen());
      case Routes.login:
        return _generateRoute(settings, const AuthMain());
      case Routes.products:
        var args = settings.arguments as Map<String, dynamic>;
        if(args['shopId'] == null) {
          return _generateRoute(settings, const HomeScreen());
        }
        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (context, animation, _) => ProductsPage(
              shopId: args['shopId'],
              shopName: args['shopName'],
              shopIcon: args['shopIcon'],
              shopLocation: args['shopLocation'],
              shopCoverPhoto: args['shopCoverPhoto'],
              notices: args['notices']),
        );
      case Routes.cart:
        return _generateRoute(settings, const CartScreen());
      case Routes.order:
        return _generateRoute<bool>(settings, const OrderScreen());
      case Routes.pastOrders:
        return _generateRoute(settings, const AllOrdersScreen());
      case Routes.orderDetails:
        var args = settings.arguments as Map<String, dynamic>;
        if(args['orderId'] != null) {
          return _generateRoute(settings, OrderDetailsScreen(args['orderId']));
        }
        return _generateRoute(settings, const HomeScreen());
      case Routes.customOrder:
        return _generateRoute(settings, const CustomOrderScreen());
      case Routes.medicineOrder:
        return _generateRoute(settings, const MedicineOrderScreen());
      case Routes.parcelOrder:
        return _generateRoute(settings, const ParcelOrderScreen());
      case Routes.pickUpAndDrop:
        return _generateRoute(settings, const PickDropOrderScreen());
      case Routes.beClient:
        return _generateRoute(settings, const BeClientScreen());
      case Routes.feedback:
        return _generateRoute(settings, const FeedbackScreen());
      case Routes.profile:
        return _generateRoute(settings, const ProfileScreen());
      case Routes.about:
        return _generateRoute(settings, const AboutScreen());
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(
              child: Text('An error occurred. Please reload the app.'),
            ),
          ),
        );
    }
  }

  static MaterialPageRoute<T> _generateRoute<T>(
          RouteSettings settings, Widget page) =>
      MaterialPageRoute<T>(
        settings: settings,
        builder: (context) => page,
      );
}
