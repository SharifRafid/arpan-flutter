import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/theme_data.dart';

Widget iconButton(
    {required Function onClickAction, required IconData iconData}) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10, bottom: 13, top: 10),
    child: SizedBox(
      height: 32,
      width: 32,
      child: IconButton(
          color: textWhite,
          onPressed: () => onClickAction(),
          icon: Icon(iconData)),
    ),
  );
}