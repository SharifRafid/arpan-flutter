import 'package:flutter/material.dart';
import 'package:Arpan/global/models/shop_model.dart';
import 'package:Arpan/global/utils/colors_converter.dart';

class NoticeSliderText extends StatelessWidget {
  final Notices shopNotice;
  const NoticeSliderText(this.shopNotice, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Card(
        color: HexColor.fromHex(shopNotice.bgColor!),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Text(
              shopNotice.title.toString(),
              style: TextStyle(color: HexColor.fromHex(shopNotice.color!)),
            ),
          ),
        ),
      ),
    );
  }
}
