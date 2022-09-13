import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/order/all_orders_screen.dart';

Widget customBottomBar(BuildContext context){
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    color: bgBlue,
    child: IconTheme(
      data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
      child: Row(
        children: <Widget>[
          IconButton(
            tooltip: 'Open old orders',
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) => const AllOrdersScreen())
              );
            },
          ),
          IconButton(
            tooltip: 'Call us',
            icon: const Icon(Icons.call),
              onPressed: () {},
          ),
          const Spacer(),
          IconButton(
            tooltip: 'Feedback',
            icon: const Icon(Icons.feedback),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Rate',
            icon: const Icon(Icons.rate_review),
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}