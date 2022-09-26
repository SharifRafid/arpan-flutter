import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/modules/order/order_screen.dart';
import 'package:ui_test/modules/home/widgets/cart_app_bar.dart';
import 'package:ui_test/modules/home/widgets/editable_cart_item.dart';

import '../../global/models/settings_model.dart';
import '../../global/utils/show_toast.dart';
import '../../global/utils/theme_data.dart';
import '../../global/utils/utils.dart';


class CartScreen extends StatelessWidget {

  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box<CartItemMain>('cart').listenable(),
        builder: (context, box, widgetNew) {
          print("TEST");
          var data = box.values;
          HashMap<String, List<CartItemMain>> cartItems = HashMap();
          for (var item in data) {
            // Just for the sake of speed, using shop name here but
            // using key will be more ideal
            if (cartItems.containsKey(item.productItemShopName)) {
              cartItems[item.productItemShopName!]?.add(item);
            } else {
              cartItems[item.productItemShopName!] = [item];
            }
          }
          return Scaffold(
            backgroundColor: bgOffWhite,
            appBar: const CartAppBar(
              height: appBarHeight,
              title: "Cart",
            ),
            body: SizedBox(
              height: double.infinity,
              child: Stack(
                children: [
                  ListView.builder(
                    itemCount: cartItems.length,
                      itemBuilder: (BuildContext context, int index) {
                    return CartCard(cartItems.keys.toList()[index],
                        cartItems[cartItems.keys.toList()[index]]!);
                  }),
                  cartItems.isNotEmpty? Positioned(
                    bottom: 15,
                    right: 15,
                    child: MaterialButton(
                      color: orderingTimeCheck() ? bgBlue : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        Settings settings = Hive.box<Settings>("settingsBox").get("current")!;
                        if (cartItems.length > settings.maxShopPerOrder!) {
                          showToast(context,
                              "You can only order from maximum ${settings.maxShopPerOrder} shops in each order. Please delete the additional items.");
                          return;
                        }
                        if (!orderingTimeCheck()) {
                          showToast(context,
                              "Please order at the correct ordering times");
                          return;
                        }
                        var authBox = Hive.box('authBox');
                        if (authBox.get("accessToken", defaultValue: "") ==
                                "" ||
                            authBox.get("refreshToken", defaultValue: "") ==
                                "") {
                          showLoginToast(context);
                          return;
                        }
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrderScreen()));
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 8.0, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: const [
                              Text("Order now",
                                  style: TextStyle(color: textWhite)),
                              Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  color: textWhite,
                                  size: 16,
                                ),
                              )
                            ],
                          )),
                    ),
                  ) : Container()
                ],
              ),
            ),
          );
        });
  }
}
