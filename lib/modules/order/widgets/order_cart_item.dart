import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:Arpan/global/models/cart_item_model.dart';
import 'package:Arpan/global/utils/constants.dart';

import '../../../global/utils/theme_data.dart';

class OrderCartCard extends StatefulWidget {
  final String item;
  final List<CartItemMain> list;

  const OrderCartCard(this.item, this.list, {Key? key}) : super(key: key);

  @override
  State<OrderCartCard> createState() => _OrderCartCardState();
}

class _OrderCartCardState extends State<OrderCartCard> {
  late var productItems = widget.list;

  @override
  Widget build(BuildContext context) {
    var totalPrice = 0;
    for (var element in widget.list) {
      totalPrice = totalPrice +
          (element.productItemOfferPrice! * element.productItemAmount!);
    }
    return Card(
      color: bgBlue,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                widget.item,
                style: TextStyle(color: textWhite),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Container(
                color: bgOffWhite,
                child: Column(
                  children: [
                    for (var product in productItems)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                                width: 140,
                                child:
                                    Text(product.productItemName.toString())),
                            Container(
                              height: 14,
                              width: 1,
                              color: textBlack,
                            ),
                            SizedBox(
                                width: 10,
                                child:
                                    Text(product.productItemAmount.toString())),
                            Container(
                              height: 14,
                              width: 1,
                              color: textBlack,
                            ),
                            Text((product.productItemAmount! *
                                    product.productItemOfferPrice!)
                                .toString()),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                "Total : ৳$totalPrice",
                style: const TextStyle(color: textWhite),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
