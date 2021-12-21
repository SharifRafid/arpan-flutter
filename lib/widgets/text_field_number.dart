
import 'package:arpan_app_new/ui/resources/theme_data.dart';
import 'package:flutter/material.dart';

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
            backgroundColor: MaterialStateProperty.all<Color>(MainColors.white),
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
                  color: MainColors.blue,
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