import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:Arpan/global/models/promo_code_model.dart';
import 'package:Arpan/global/utils/show_toast.dart';
import 'package:Arpan/global/utils/theme_data.dart';
import 'package:Arpan/modules/order/services/order_service.dart';

import '../../../global/models/cart_item_model.dart';

class PromoCodeBlock extends StatefulWidget {
  final void Function(Promo? promo) setPromoCode;
  final List<CartItemMain> cartItemsList;

  const PromoCodeBlock(this.cartItemsList, this.setPromoCode, {Key? key})
      : super(key: key);

  @override
  State<PromoCodeBlock> createState() => _PromoCodeBlockState();
}

enum _CurrentState { init, loading, applied, apply }

class _PromoCodeBlockState extends State<PromoCodeBlock> {
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
      showToast(context, "Promo code not found or expired.");
      setState(() {
        currentState = _CurrentState.apply;
      });
      return;
    }
    if (response.promo != null) {
      Promo promo = response.promo!;
      if (promo.shopBased == true) {
        if (widget.cartItemsList
            .any((element) => element.productItemShopKey != promo.shopKey)) {
          if (!mounted) return;
          widget.setPromoCode(null);
          showToast(context,
              "For applying this promo, all products need to be from ${promo.shopName}");
          setState(() {
            currentState = _CurrentState.apply;
          });
          return;
        }
      }
      var tp = 0;
      for (var element in widget.cartItemsList) { tp = tp + element.productItemOfferPrice!; }
      if(tp >= promo.minimumPrice!){
        appliedMessage = "You have successfully applied promo code ${promo.promoCodeName}.";
        widget.setPromoCode(promo);
        setState(() {
          currentState = _CurrentState.applied;
        });
        return;
      }else{
        if (!mounted) return;
        widget.setPromoCode(null);
        showToast(context,
            "For applying this promo, minimum price needs to be ${promo.minimumPrice}");
        setState(() {
          currentState = _CurrentState.apply;
        });
        return;
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
        return SizedBox(
          height: 38,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 5,),
              Expanded(
                child: TextFormField(
                  style: const TextStyle(fontSize: 14),
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(12), // Added this
                    isDense: true,
                    border: OutlineInputBorder(),
                    labelText: 'Promo',
                  ),
                ),
              ),
              Container(width: 4,),
              Container(
                height: 38,
                width: 140,
                margin: const EdgeInsets.only(left: 5, right: 5),
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
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Text(
                        "Apply",
                        style: TextStyle(color: textWhite),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
    }
  }
}
