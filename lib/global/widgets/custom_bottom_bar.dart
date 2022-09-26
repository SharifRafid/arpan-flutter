import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/global/utils/utils.dart';
import 'package:ui_test/modules/order/all_orders_screen.dart';
import 'package:ui_test/modules/order/models/order_item_response.dart';

import '../../modules/order/order_details_screen.dart';

Widget customBottomBar(BuildContext context, OrderItemResponse order) {
  return Card(
    color: order.orderStatus == "PENDING"
        ? const Color(0xFF262626)
        : order.orderStatus == "VERIFIED"
        ? const Color(0xFFFA831B)
        : order.orderStatus == "PICKED UP"
        ? const Color(0xFFED9D34)
        : order.orderStatus == "COMPLETED"
        ? const Color(0xFF43A047)
        : order.orderStatus == "CANCELLED"
        ? const Color(0xFFEA594D)
        : order.orderStatus == "PROCESSING"
        ? const Color(0xFFED9D34)
        : const Color(0xFF43A047),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    child: InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute<void>(
              builder: (BuildContext context) => OrderDetailsScreen(order))
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Order #${orderNumberToString(order.orderId.toString())}",
              style: const TextStyle(
                color: textWhite,
              ),
            ),
            Text(
              order.orderStatus.toString(),
              style: const TextStyle(
                color: textWhite,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
