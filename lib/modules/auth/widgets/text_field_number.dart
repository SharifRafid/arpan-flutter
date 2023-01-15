import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:Arpan/global/utils/theme_data.dart';

TextField textFieldNumber({required TextEditingController controller,
  required String hint}){
  return TextField(
    controller: controller,
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: textWhite,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(0),
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 15,
        color: textWhite,
      ),
    ),
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  );
}