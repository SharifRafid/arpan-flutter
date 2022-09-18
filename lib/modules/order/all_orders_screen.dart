import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/show_toast.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/home/widgets/order_app_bar.dart';
import 'package:ui_test/modules/order/models/order_item_response.dart';
import 'package:ui_test/modules/order/order_details_screen.dart';
import 'package:ui_test/modules/order/services/order_service.dart';

import '../../global/utils/utils.dart';

class AllOrdersScreen extends StatefulWidget {
  const AllOrdersScreen({Key? key}) : super(key: key);

  @override
  State<AllOrdersScreen> createState() => _AllOrdersScreenState();
}

class _AllOrdersScreenState extends State<AllOrdersScreen> {
  OrderService orderService = OrderService();

  List<OrderItemResponse> orders = [];

  bool loading = true;

  void loadOrdersData() async {
    var response = await orderService.getOrders();
    if (response == null) {
      if (!mounted) return;
      showToast(context, "Failed to load orders data");
    } else {
      orders = response;
      setState(() {
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    loadOrdersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const OrderAppBar(
          height: appBarHeight,
          title: "All orders",
        ),
        backgroundColor: bgOffWhite,
        body: loading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [for (var order in orders) buildCard(order)],
                ),
              ));
  }

  Card buildCard(OrderItemResponse order) {
    var time = fetchTime(order.orderPlacingTimeStamp!);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: InkWell(
        onTap: (){
          if (!mounted) return;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => OrderDetailsScreen(order)),
            ModalRoute.withName('/'),
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        bottomLeft: Radius.circular(5)),
                    color: bgWhite,
                  ),
                  height: 45,
                  child: Center(
                    child: Text(
                      order.orderId.toString(),
                      style: const TextStyle(
                          color: textBlack, fontWeight: FontWeight.bold),
                    ),
                  )),
            ),
            Container(
              height: 45,
              width: 1,
              color: const Color(0x2C333333),
            ),
            Expanded(
              child: Container(
                height: 45,
                child: Center(
                  child: Text(
                    time.toString(),
                    style: const TextStyle(
                        color: textBlack, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(5),
                      topRight: Radius.circular(5)),
                  color: order.orderStatus == "PENDING"
                      ? const Color(0xFF262626)
                      : order.orderStatus == "VERIFIED"
                          ? const Color(0xFFFA831B)
                          : order.orderStatus == "PICKED UP"
                              ? const Color(0xFFED9D34)
                              : order.orderStatus == "PROCESSING"
                                  ? const Color(0xFFED9D34)
                                  : const Color(0xFF43A047),
                ),
                height: 45,
                child: Center(
                  child: Text(order.orderStatus.toString(),
                      style: const TextStyle(
                        color: textWhite,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
