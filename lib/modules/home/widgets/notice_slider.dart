import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../global/utils/theme_data.dart';

class NoticeSlider extends StatefulWidget {
  final List<Widget> imageSliders;
  const NoticeSlider(this.imageSliders, {Key? key}) : super(key: key);

  @override
  State<NoticeSlider> createState() => _CSliderState();
}

class _CSliderState extends State<NoticeSlider> {
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        CarouselSlider(
          items: widget.imageSliders,
          carouselController: _controller,
          options: CarouselOptions(
              autoPlayInterval: const Duration(seconds: 5),
              autoPlay: true,
              enlargeCenterPage: true,
              viewportFraction: 1,
              height: 50,
              onPageChanged: (index, reason) {
                
              }),
        ),
      ],
    );
  }
}