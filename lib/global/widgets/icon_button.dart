import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/theme_data.dart';

Widget iconButton(
    {required Function onClickAction,
    required IconData iconData,
    required int cartCount}) {
  return Padding(
    padding: const EdgeInsets.only(right: 5, left: 5),
    child: SizedBox(
      height: 50,
      width: 50,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: IconButton(
              color: textWhite,
              onPressed: () => onClickAction(),
              icon: Icon(iconData),
            ),
          ),
          cartCount > 0
              ? Positioned(
                  top: 22,
                  left: 20,
                  height: 28,
                  width: 28,
                  child: Card(
                    shape: const CircleBorder(),
                    color: bgWhite,
                    child: Center(
                      child: Text(
                        cartCount.toString(),
                        style: const TextStyle(
                          color: textBlack,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    ),
  );
}
