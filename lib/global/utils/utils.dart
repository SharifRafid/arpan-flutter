import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ui_test/global/utils/assymetric_encryption.dart';

import '../models/settings_model.dart';

import 'dart:math';
import 'dart:convert';

import '../models/shop_model.dart';
import 'constants.dart';

bool isNumeric(String s) {
  return double.tryParse(s) != null;
}

String fetchTime(int timeStamp) {
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timeStamp);
  return "${date.day}-${date.month}-${date.year}";
}

bool orderingTimeCheck() {
  Settings settings = Hive.box<Settings>("settingsBox").get("current")!;
  if(settings.appOn != true){
    debugPrint("App Is Not Turned On From Server");
    return false;
  }
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
  const publicKey = '-----BEGIN PUBLIC KEY-----\nMIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEAz6mdnQcEo77evfR3BcTD\nN3cKDsbfuwqrdu9lLrr/CAxZn39yFNgK9RGuGNqh9/Mgr1RHexlARkprWEgV5Fm1\nV0pffsIH3+G85rfoCjhMXXR/U9MaFCm90FWQsXC/oITOtu4YyaCLpsQQrqjw6o6L\nciTO09lg7baW97QGIuRj6Di6Iomw9xLcSkKKYnH+AS12ZSZvL+sGbqdkP4O+EKE8\nbi8hRcweHQsm9zpoM078sgaHytIdC7MVYiYusx8aBAToH2OuRd3ebOttZ6zgx92W\nPzNkV7E1vVvYKHZ7vxkFVlta+mEhRaD2ad70XyhQqLn47M09z9wEbxysU62qD7LY\ncEYkSzvXQthVX+GZiX4EGEjV+5ioACTp7v0MCO8yznh3coBX+DVnEgiElRHZfOZ9\nnpcRRZ0D1o3r3a5pVscgUeeCLXiwwNTNxNaixCl8Zln2bCex8/XkO5/tgpbmopXo\nG1llook1jFiQF9nyRs6MA252YOIo/qIeTNVwmZrP+oNAgzPib9TrfFvRXrEQZy3m\n/EGGvrkDhFILJrzDccK8f/Hn4zhc6RKuA+GFMd+43IAoiOgOpie/k12F/ZuNbtlb\nNMi03cYQpuBRmseikUg85Y+LrChwevcpUVnD/uuxkcmpk5IPSEvVAzx4rM9Xf3H/\nN9UsX0QlZBicu7lZZAMer10CAwEAAQ==\n-----END PUBLIC KEY-----\n';
  String part1 = getRandString(10);
  String part2 = getRandString(10);
  String part3 = getRandString(10);
  String part4 = getRandString(10);
  DateTime date = DateTime.now();
  String key = AsymmetricCrypt(publicKey).encrypt("${part1}___${part2}___${part3}___${part4}___${date.day}___${date.hour}");
  return key;
}

String getRandString(int len) {
  var random = Random.secure();
  var values = List<int>.generate(len, (i) =>  random.nextInt(255));
  return base64UrlEncode(values);
}

String orderNumberToString(String num) {
  var newString = "";
  List<String> alphaArray = [];
  for(int i=0; i  < numStrConvConst.length; i++) {
    var char = numStrConvConst[i];
    alphaArray.add(char);
  }
  for(int i=0; i  < num.length; i++) {
    var char = num[i];
    newString = newString + alphaArray[int.parse(char)];
  }
  return num;
}

bool checkShopStatus(Shop element){
  if(element.activeHours == null){
    return true;
  }
  if(element.activeHours!.isEmpty){
    return true;
  }
  String timeRange = element.activeHours.toString();
  String startTime = timeRange.split("TO")[0].toString();
  String endTime = timeRange.split("TO")[1].toString();
  double startTimeDouble = double.parse(startTime.split(":")[0])
      +(double.parse(startTime.split(":")[1])/60.0);
  double endTimeDouble = double.parse(endTime.split(":")[0])
      +(double.parse(endTime.split(":")[1])/60.0);
  DateTime dateTime = DateTime.now();
  double currentTime = double.parse(dateTime.hour.toString())
      + (double.parse(dateTime.minute.toString())/60);
  if(startTimeDouble<currentTime && endTimeDouble>currentTime){
    return true;
  }
  return false;
}

String convertTo12HoursFormat(String time){
  int tInt = int.parse(time.split("TO")[0].split(":")[0]);
  if(tInt == 0){
    return "12:${time.split("TO")[0].split(":")[1]} AM";
  }
  if(tInt > 12){
    tInt = tInt - 12;
    return "$tInt:${time.split("TO")[0].split(":")[1]} PM";
  }
  if(tInt == 12){
    return "$tInt:${time.split("TO")[0].split(":")[1]} PM";
  }
  return "$tInt:${time.split("TO")[0].split(":")[1]} AM";
}