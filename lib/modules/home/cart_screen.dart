import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/modules/order/order_screen.dart';
import 'package:ui_test/modules/home/widgets/cart_app_bar.dart';
import 'package:ui_test/modules/home/widgets/editable_cart_item.dart';

import '../../global/utils/show_toast.dart';
import '../../global/utils/theme_data.dart';
import '../../global/utils/utils.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  HashMap<String, List<CartItemMain>> cartItems = HashMap();

  void loadData() async {
    var data = Hive.box<CartItemMain>("cart").values;
    cartItems.clear();
    for (var item in data) {
      // Just for the sake of speed, using shop name here but
      // using key will be more ideal
      if (cartItems.containsKey(item.productItemShopName)) {
        cartItems[item.productItemShopName!]?.add(item);
      } else {
        cartItems[item.productItemShopName!] = [item];
      }
    }
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgOffWhite,
      appBar: const CartAppBar(
        height: appBarHeight,
        title: "Cart",
      ),
      body: Container(
        height: double.infinity,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  for (var item in cartItems.keys)
                    CartCard(item, cartItems[item]!, (item) {
                      setState(() {
                        cartItems.remove(cartItems[item]);
                      });
                    })
                ],
              ),
            ),
            Positioned(
              bottom: 15,
              right: 15,
              child: MaterialButton(
                color: bgBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                onPressed: () {
                  if(!orderingTimeCheck()){
                    showToast(context, "Please order at the correct ordering times");
                    return;
                  }
                  var authBox = Hive.box('authBox');
                  if (authBox.get("accessToken", defaultValue: "") == "" ||
                      authBox.get("refreshToken", defaultValue: "") == "") {
                    showLoginToast(context);
                    return;
                  }
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const OrderScreen()));
                },
                child: Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 8.0,top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Text("Order now", style: TextStyle(color: textWhite)),
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
            )
          ],
        ),
      ),
    );
  }
}
