import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:Arpan/global/models/cart_item_model.dart';
import 'package:Arpan/global/utils/constants.dart';
import 'package:Arpan/global/utils/show_toast.dart';

import '../../../global/utils/theme_data.dart';
import '../../../main.dart';

class CartCard extends StatelessWidget {
  final String item;
  final List<CartItemMain> list;
  const CartCard(this.item, this.list, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                item,
                style: const TextStyle(color: textWhite),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                color: bgOffWhite,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    for (var product in list)
                      _ProductItemCart(product)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ProductItemCart extends StatelessWidget {
  final CartItemMain product;
  const _ProductItemCart(this.product, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      color: bgWhite,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 5, 12, 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.productItemName.toString()),
                      SizedBox(
                        width: 200,
                        child: Text(product.productItemDesc.toString()),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox.fromSize(
                      size: const Size.fromRadius(30),
                      child: CachedNetworkImage(
                        height: 60,
                        width: 60,
                        imageUrl: serverFilesBaseURL + product.productItemImage.toString(),
                        placeholder: (context, url) =>
                            Image.asset("assets/images/transparent.png"),
                        errorWidget: (context, url, error) => Image.asset(
                          "assets/images/Default_Image_Thumbnail.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                      "${product.productItemOfferPrice} x ${product.productItemAmount} = ${product.productItemOfferPrice! * product.productItemAmount!}"),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (product.productItemAmount! > 1) {
                            product.productItemAmount = product.productItemAmount!-1;
                            await product.save();
                          }
                        },
                        icon: const Icon(Icons.remove),
                        color: Colors.red,
                      ),
                      Text("${product.productItemAmount}"),
                      IconButton(
                        onPressed: () async {
                          if (product.productItemAmount! < 1000) {
                            product.productItemAmount = product.productItemAmount!+1;
                            await product.save();
                          }
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    await product.delete();
                    if(Hive.box<CartItemMain>('cart').isEmpty){
                      navigatorKey.currentState?.pop();
                    }
                  },
                  color: Colors.redAccent,
                  textColor: textWhite,
                  child: Text("Delete"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
