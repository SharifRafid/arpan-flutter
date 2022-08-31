import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/theme_data.dart';

Widget resendButton({required Function onClickAction, required String title}){
  return Container(
    margin: const EdgeInsets.only(top: 10),
    child: SizedBox(
        height: 38, //43
        width: 180, //220
        child: ElevatedButton(
          style: ButtonStyle(
            minimumSize: MaterialStateProperty.all(const Size(0, 0)),
            padding: MaterialStateProperty.all<EdgeInsets>(
                const EdgeInsets.fromLTRB(10, 0, 10, 0)),
            backgroundColor: MaterialStateProperty.all<Color>(bgBlue),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            elevation: MaterialStateProperty.all(0)
          ),
          child: Center(
            child: Text(
              title,
              style: const TextStyle(
                  color: textWhite,
                  fontSize: 14
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