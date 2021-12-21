import 'package:arpan_app_new/ui/resources/theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

TextField textFieldNumber({required TextEditingController controller,
  required String hint}){
  return TextField(
    controller: controller,
    textAlign: TextAlign.center,
    style: const TextStyle(
      color: MainColors.white,
    ),
    decoration: InputDecoration(
      contentPadding: const EdgeInsets.all(0),
      hintText: hint,
      hintStyle: const TextStyle(
        fontSize: 15,
        color: MainColors.white,
      ),
    ),
    keyboardType: TextInputType.number,
    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
  );
}
