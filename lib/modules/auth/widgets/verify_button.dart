import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/theme_data.dart';

Widget buttonMain({required Function onClickAction, required String title}){
  return Container(
    margin: const EdgeInsets.only(top: 20),
    child: SizedBox(
        height: 43, //43
        width: 220, //220
        child: ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(0, 0)),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.fromLTRB(10, 0, 10, 0)),
            backgroundColor: MaterialStateProperty.all<Color>(bgWhite),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: textBlue,
                  fontSize: 16
              ),
            ),
          ),
          onPressed: () {
            onClickAction();
          },
        )
    ),
  );
}