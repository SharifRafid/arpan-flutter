import 'package:flutter/material.dart';
import '../../../global/utils/theme_data.dart';

class ButtonMain extends StatelessWidget {
  final String s;

  final VoidCallback onClick;

  const ButtonMain(
      this.s, this.onClick, {
        Key? key,
      }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          minWidth: 215,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(35)),
          color: bgWhite,
          textColor: textBlue,
          onPressed: onClick,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              s,
              style: const TextStyle(
                  fontSize: 16
              ),
            ),
          )),
    );
  }
}
