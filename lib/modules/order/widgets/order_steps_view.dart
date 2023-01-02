import 'package:flutter/material.dart';

Widget orderStepsView(String status) {
  return Container(
    padding: const EdgeInsets.all(15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: status == "PLACED"
          ? [
              checkedItem("PLACED"),
              const Expanded(child: MySeparator()),
              uncheckedItem("VERIFIED"),
              const Expanded(child: MySeparator()),
              uncheckedItem("PROCESSING"),
              const Expanded(child: MySeparator()),
              uncheckedItem("PICKED UP"),
              const Expanded(child: MySeparator()),
              uncheckedItem("COMPLETED"),
            ]
          : status == "VERIFIED"
              ? [
                  checkedItem("PLACED"),
                  const Expanded(child: MySeparator()),
                  checkedItem("VERIFIED"),
                  const Expanded(child: MySeparator()),
                  uncheckedItem("PROCESSING"),
                  const Expanded(child: MySeparator()),
                  uncheckedItem("PICKED UP"),
                  const Expanded(child: MySeparator()),
                  uncheckedItem("COMPLETED"),
                ]
              : status == "PROCESSING"
                  ? [
                      checkedItem("PLACED"),
                      const Expanded(child: MySeparator()),
                      checkedItem("VERIFIED"),
                      const Expanded(child: MySeparator()),
                      checkedItem("PROCESSING"),
                      const Expanded(child: MySeparator()),
                      uncheckedItem("PICKED UP"),
                      const Expanded(child: MySeparator()),
                      uncheckedItem("COMPLETED"),
                    ]
                  : status == "PICKED UP"
                      ? [
                          checkedItem("PLACED"),
                          const Expanded(child: MySeparator()),
                          checkedItem("VERIFIED"),
                          const Expanded(child: MySeparator()),
                          checkedItem("PROCESSING"),
                          const Expanded(child: MySeparator()),
                          checkedItem("PICKED UP"),
                          const Expanded(child: MySeparator()),
                          uncheckedItem("COMPLETED"),
                        ]
                      : [
                          checkedItem("PLACED"),
                          const Expanded(child: MySeparator()),
                          checkedItem("VERIFIED"),
                          const Expanded(child: MySeparator()),
                          checkedItem("PROCESSING"),
                          const Expanded(child: MySeparator()),
                          checkedItem("PICKED UP"),
                          const Expanded(child: MySeparator()),
                          checkedItem("COMPLETED"),
                        ],
    ),
  );
}

Widget checkedItem(String title) {
  return Column(
    children: [
      const Icon(
        Icons.check_circle,
        size: 20,
      ),
      Text(
        title,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget uncheckedItem(String title) {
  return Column(
    children: [
      const Icon(
        Icons.check_circle_outline,
        size: 20,
      ),
      Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}

class MySeparator extends StatelessWidget {
  const MySeparator({Key? key, this.height = 1, this.color = Colors.black})
      : super(key: key);
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 2.5;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: dashWidth,
              height: dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
