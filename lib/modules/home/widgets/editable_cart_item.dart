import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/global/utils/constants.dart';

import '../../../global/utils/theme_data.dart';

class CartCard extends StatefulWidget {
  final String item;
  final List<CartItemMain> list;
  final void Function(String item) onRemoveShop;
  const CartCard(this.item, this.list, this.onRemoveShop, {Key? key}) : super(key: key);

  @override
  State<CartCard> createState() => _CartCardState();
}

class _CartCardState extends State<CartCard> {

  late var productItems = widget.list;

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
                widget.item,
                style: TextStyle(color: textWhite),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(1.0),
              child: Card(
                color: bgOffWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                child: Column(
                  children: [
                    for (var product in productItems)
                      _ProductItemCart(product, (product) {
                        if(productItems.length == 1){
                          widget.onRemoveShop(widget.item);
                        }else{
                          setState((){
                            productItems.remove(product);
                          });
                        }
                      })
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

class _ProductItemCart extends StatefulWidget {
  final CartItemMain product;
  final void Function(CartItemMain product) onDelete;

  const _ProductItemCart(this.product, this.onDelete, {Key? key})
      : super(key: key);

  @override
  State<_ProductItemCart> createState() => _ProductItemCartState();
}

class _ProductItemCartState extends State<_ProductItemCart> {
  late var cartCount = widget.product.productItemAmount;
  late var productPrice = widget.product.productItemOfferPrice;

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
                      Text(widget.product.productItemName.toString()),
                      SizedBox(
                        width: 200,
                        child: Text(widget.product.productItemDesc.toString()),
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
                        imageUrl: serverFilesBaseURL + widget.product.productItemImage.toString(),
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
                      "$productPrice x $cartCount = ${productPrice! * cartCount!}"),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (cartCount! > 1) {
                            setState(() {
                              cartCount = cartCount! - 1;
                            });
                            widget.product.productItemAmount = cartCount!;
                            widget.product.save();
                          }
                        },
                        icon: const Icon(Icons.remove),
                        color: Colors.red,
                      ),
                      Text("$cartCount"),
                      IconButton(
                        onPressed: () {
                          if (cartCount! < 1000) {
                            setState(() {
                              cartCount = cartCount! + 1;
                            });
                            widget.product.productItemAmount = cartCount!;
                            widget.product.save();
                          }
                        },
                        icon: const Icon(Icons.add),
                        color: Colors.green,
                      ),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    widget.product.delete();
                    widget.onDelete(widget.product);
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
