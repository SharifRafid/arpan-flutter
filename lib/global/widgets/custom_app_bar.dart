import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/global/widgets/icon_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final String title;

  const CustomAppBar({Key? key, required this.height, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            iconButton(
              onClickAction: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => ProductsPage(
                //           shopId: "",
                //         )));
                // showToast("message");
              },
              iconData: Icons.menu,
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                  child: Text(
                    title,
                    style: const TextStyle(color: textWhite, fontSize: 16),
                  ),
                ),
              ),
            ),
            iconButton(
                onClickAction: () {
                  // LOGOUT LOGIC
                  // Navigator.pushNamedAndRemoveUntil(
                  //     context, "/", (r) => false);
                },
                iconData: Icons.shopping_cart),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
