import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/global/utils/constants.dart';
import 'package:ui_test/global/utils/router.dart';
import 'package:ui_test/modules/order/order_screen.dart';
import 'package:ui_test/modules/home/widgets/cart_app_bar.dart';
import 'package:ui_test/modules/home/widgets/editable_cart_item.dart';
import 'package:ui_test/modules/others/services/others_service.dart';

import '../../global/models/settings_model.dart';
import '../../global/utils/show_toast.dart';
import '../../global/utils/theme_data.dart';
import '../../global/utils/utils.dart';
import '../../main.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var loading = true;
  Settings? settings;
  Timer? _autoRefreshTimer;

  void fetchSettingsData({bool? silently}) async {
    debugPrint("Fetching Settings Data");
    if(silently!=true){
      setState((){
        loading = true;
      }); 
    }
    var response = await OthersService().getSettings();
    if(response!=null){
      Hive.box<Settings>("settingsBox")
          .put("current", response);
    }else{
      if(!mounted) return;
      if(silently==true) return;
      showToast(context, "Failed to load cart data from server");
    }
    setState((){
      settings = response;
      loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSettingsData();
    _autoRefreshTimer = Timer.periodic(const Duration(seconds: autoRefreshDelaySeconds),
            (Timer t) => fetchSettingsData(silently: true));
  }

  @override
  void dispose() {
    _autoRefreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box<CartItemMain>('cart').listenable(),
        builder: (context, box, widgetNew) {
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
                  cartItems.isNotEmpty
                      ? Positioned(
                          bottom: 15,
                          right: 15,
                          child: loading?
                    const CircularProgressIndicator() :
                    settings != null ?
                    MaterialButton(
                      color: orderingTimeCheck() ? bgBlue : Colors.grey,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        Settings settings =
                        Hive.box<Settings>("settingsBox")
                            .get("current")!;
                        if (cartItems.length > settings.maxShopPerOrder!) {
                          showToast(context,
                              "You can only order from maximum ${settings.maxShopPerOrder} shops in each order. Please delete the additional items.");
                          return;
                        }
                        if (!orderingTimeCheck()) {
                          showToast(context,
                              "We are not receiving orders at this moment.");
                          return;
                        }
                        var authBox = Hive.box('authBox');
                        if (authBox.get("accessToken",
                            defaultValue: "") ==
                            "" ||
                            authBox.get("refreshToken",
                                defaultValue: "") ==
                                "") {
                          showLoginToast(context);
                          return;
                        }
                        navigatorKey.currentState?.pushNamed(Routes.order);
                      },
                      child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0,
                              right: 8.0,
                              top: 10,
                              bottom: 10),
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
                    ):MaterialButton(
                      color: bgBlue ,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                      onPressed: () {
                        fetchSettingsData();
                      },
                      child: const Icon(Icons.refresh, color: textWhite,),
                    ),
                        )
                      : Container()
                ],
              ),
            ),
          );
        });
  }
}
