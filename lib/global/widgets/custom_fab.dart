import 'package:flutter/material.dart';
import 'package:Arpan/global/utils/theme_data.dart';

Widget customFAB(){
  return FloatingActionButton(
    onPressed: () {},
    tooltip: 'Info',
    backgroundColor: bgBlue,
    child: const Icon(Icons.info_outline_rounded),
  );
}