import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:Arpan/global/utils/router.dart';
import 'package:Arpan/global/utils/theme_data.dart';
import 'package:Arpan/global/utils/utils.dart';
import 'package:Arpan/modules/order/all_orders_screen.dart';
import 'package:Arpan/modules/order/models/order_item_response.dart';

import '../../main.dart';
import '../../modules/order/order_details_screen.dart';

class CustomBottomBar extends StatelessWidget {
  final BuildContext context;
  final OrderItemResponse order;

  const CustomBottomBar(this.context, this.order, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box>(
        valueListenable: Hive.box('bottomBarM').listenable(),
        builder: (context, box, widgetNew) {
          if (box.keys.contains(order.id.toString())) {
            if (box.get(order.id.toString(), defaultValue: "") ==
                order.orderStatus.toString()) {
              return const SizedBox(
                height: 0,
                width: 0,
              );
            }
          }
          return Card(
            color: order.orderStatus == "PLACED"
                ? const Color(0xFF262626)
                : order.orderStatus == "VERIFIED"
                    ? const Color(0xFFFA831B)
                    : order.orderStatus == "PICKED UP"
                        ? order.paymentRequested == true
                            ? const Color(0xFFdc146c)
                            : const Color(0xFFED9D34)
                        : order.orderStatus == "COMPLETED"
                            ? const Color(0xFF43A047)
                            : order.orderStatus == "CANCELLED"
                                ? const Color(0xFFEA594D)
                                : order.orderStatus == "PROCESSING"
                                    ? const Color(0xFFED9D34)
                                    : const Color(0xFF43A047),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
            child: InkWell(
              onTap: () {
                navigatorKey.currentState?.pushNamed(Routes.orderDetails,
                    arguments: {"orderId": order.id});
              },
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order# ${orderNumberToString(order.orderId.toString())}",
                      style: const TextStyle(
                        color: textWhite,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          order.paymentRequested != true
                              ? order.orderStatus.toString()
                              : "PAYMENT REQUESTED",
                          style: const TextStyle(
                            color: textWhite,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                          width: 40,
                          child: IconButton(
                              padding: const EdgeInsets.only(left: 10),
                              onPressed: () {
                                box.put(order.id.toString(),
                                    order.orderStatus.toString());
                              },
                              icon: const Icon(
                                Icons.close,
                                color: textWhite,
                              )),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}
