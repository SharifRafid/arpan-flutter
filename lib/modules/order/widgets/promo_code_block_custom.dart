import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ui_test/global/models/promo_code_model.dart';
import 'package:ui_test/global/utils/show_toast.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/order/services/order_service.dart';

import '../../../global/models/cart_item_model.dart';

class PromoCodeBlockCustom extends StatefulWidget {
  final void Function(Promo? promo) setPromoCode;
  final int dc;

  const PromoCodeBlockCustom(this.dc, this.setPromoCode, {Key? key})
      : super(key: key);

  @override
  State<PromoCodeBlockCustom> createState() => _PromoCodeBlockState();
}

enum _CurrentState { init, loading, applied, apply }

class _PromoCodeBlockState extends State<PromoCodeBlockCustom> {
  _CurrentState currentState = _CurrentState.init;
  TextEditingController textEditingController = TextEditingController();
  final OrderService _orderService = OrderService();
  String appliedMessage = "";

  void checkPromoValidity() async {
    if (textEditingController.text.isEmpty) {
      showToast(context, "Please enter promo code");
      return;
    }
    setState(() {
      currentState = _CurrentState.loading;
    });
    var response = await _orderService
        .validatePromoCode(textEditingController.text.toString());
    if (response.error == true) {
      if (!mounted) return;
      showToast(context, response.message.toString());
      setState(() {
        currentState = _CurrentState.apply;
      });
      return;
    }
    if (response.promo != null) {
      Promo promo = response.promo!;
      if (promo.shopDiscount == true) {
        if (!mounted) return;
        widget.setPromoCode(null);
        showToast(context,
            "You can only apply a delivery charge promo here");
        setState(() {
          currentState = _CurrentState.apply;
        });
        return;
      } else {
        if(widget.dc >= promo.minimumPrice!){
          appliedMessage = "You have successfully applied promo code ${promo.promoCodeName}";
          widget.setPromoCode(promo);
          setState(() {
            currentState = _CurrentState.applied;
          });
          return;
        }else{
          if (!mounted) return;
          widget.setPromoCode(null);
          showToast(context,
              "For applying this promo, minimum delivery charge needs to be ${promo.minimumPrice}");
          setState(() {
            currentState = _CurrentState.apply;
          });
          return;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    switch (currentState) {
      case _CurrentState.init:
        return Center(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: InkWell(
            onTap: () {
              setState(() {
                currentState = _CurrentState.apply;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text(
                    "Apply promo code",
                    style: TextStyle(
                      color: textBlue,
                      fontSize: 15,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: textBlue,
                ),
              ],
            ),
          ),
        ));
      case _CurrentState.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );
      case _CurrentState.applied:
        return Container(
          margin: const EdgeInsets.all(4),
          constraints: const BoxConstraints.expand(height: 80),
          child: Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(color: Colors.green, width: 2)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appliedMessage,
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: (){
                      widget.setPromoCode(null);
                      setState(() {
                        currentState = _CurrentState.apply;
                      });
                    },
                    child: const Text(
                      "Remove",
                      style: TextStyle(
                          color: textBlue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )),
            ),
          ),
        );
      case _CurrentState.apply:
        return Container(
          height: 55,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextFormField(
                    style: const TextStyle(fontSize: 14),
                    controller: textEditingController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8), // Added this
                      isDense: true,
                      border: OutlineInputBorder(),
                      labelText: 'Promo',
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: MaterialButton(
                    onPressed: () {
                      var authBox = Hive.box('authBox');
                      if (authBox.get("accessToken", defaultValue: "") == "" ||
                          authBox.get("refreshToken", defaultValue: "") == "") {
                        showLoginToast(context);
                        return;
                      }
                      checkPromoValidity();
                    },
                    color: Colors.green,
                    child: const Center(
                      child: Text(
                        "Apply",
                        style: TextStyle(color: textWhite),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
    }
  }
}