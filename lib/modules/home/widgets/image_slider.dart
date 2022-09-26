import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../global/utils/theme_data.dart';

class ImageSlider extends StatefulWidget {
  final List<Widget> imageSliders;
  const ImageSlider(this.imageSliders, {Key? key}) : super(key: key);

  @override
  State<ImageSlider> createState() => _CSliderState();
}

class _CSliderState extends State<ImageSlider> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        SizedBox(
          height: 150,
          child: CarouselSlider(
            items: widget.imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                enlargeCenterPage: true,
                viewportFraction: 1,
                aspectRatio: 20/7,
                height: 150,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.imageSliders
              .asMap()
              .entries
              .map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 5.0,
                height: 5.0,
                margin: const EdgeInsets.symmetric(
                    vertical: 5.0, horizontal: 4.0),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (Theme
                        .of(context)
                        .brightness ==
                        Brightness.dark
                        ? bgWhite
                        : bgBlue)
                        .withOpacity(
                        _current == entry.key ? 0.9 : 0.4)),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}