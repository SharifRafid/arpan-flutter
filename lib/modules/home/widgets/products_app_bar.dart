import 'package:flutter/material.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/global/widgets/icon_button.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ui_test/modules/home/cart_screen.dart';

class ProductsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;

  const ProductsAppBar({Key? key, required this.height, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box<CartItemMain>('cart').listenable(),
        builder: (context, box, widgetNew) {
          return Container(
            decoration: BoxDecoration(
              color: bgBlue,
              boxShadow: [
                BoxShadow(
                    color: Colors.black12.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 4,
                    offset: const Offset(1, 1)),
              ],
            ),
            child: SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: textWhite,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          title,
                          style:
                              const TextStyle(color: textWhite, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                  iconButton(
                    onClickAction: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CartScreen()));
                    },
                    iconData: Icons.shopping_cart,
                    cartCount: box.length,
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
