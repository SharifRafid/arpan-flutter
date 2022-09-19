import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../models/settings_model.dart';

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

String fetchTime(int timeStamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  return "${date.day}-${date.month}-${date.year}";
}

bool orderingTimeCheck() {
  Settings settings = Hive.box<Settings>("settingsBox").get("current")!;
  if (settings.orderOverTimeAllowed == true) {
    return true;
  }
  DateTime date = DateTime.now();
  DateTime startDate = DateTime(
      2022,
      date.month,
      date.day,
      int.parse(settings.orderStartTime.toString().split(":")[0]),
      int.parse(settings.orderStartTime.toString().split(":")[1]));
  DateTime endDate = DateTime(
      2022,
      date.month,
      date.day,
      int.parse(settings.orderEndTime.toString().split(":")[0]),
      int.parse(settings.orderEndTime.toString().split(":")[1]));
  return startDate.isBefore(date) && endDate.isAfter(date);
}

void checkSettings(BuildContext context, Settings settings) {
  if (settings.alertDialogeEmergencyStatus == "active") {
    showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(settings.alertDialogEmergencyTitleText.toString()),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(settings.alertDialogEmergencyMessageText.toString()),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

String generateSignature(){
  return "axsdaffsfsfiowefniosdbouerhyiwpqxocmqehthocpyxtownurmdfgldklajsxmznnvdsnroitSALT";
}
