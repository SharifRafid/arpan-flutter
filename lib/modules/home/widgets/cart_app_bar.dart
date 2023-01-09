import 'package:flutter/material.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../main.dart';

class CartAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;

  const CartAppBar({Key? key, required this.height, required this.title})
      : super(key: key);

  Future<void> _showDeleteDialog(
      BuildContext context, Box<CartItemMain> box) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Clear cart?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Are you sure you want to delete all items from cart?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                box.clear();
                navigatorKey.currentState?.pop();
                navigatorKey.currentState?.pop();
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                navigatorKey.currentState?.pop('Cancel');
              },
            ),
          ],
        );
      },
    );
  }

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
                        navigatorKey.currentState?.pop();
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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: textWhite,
                      ),
                      onPressed: () {
                        if(box.isNotEmpty){
                          _showDeleteDialog(context, box as Box<CartItemMain>);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
