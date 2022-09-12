import 'package:flutter/material.dart';
import 'package:ui_test/modules/home/widgets/order_app_bar.dart';

import '../../global/utils/theme_data.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const OrderAppBar(
        title: "Order",
        height: appBarHeight,
      ),
      backgroundColor: bgOffWhite,
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10, top: 15, bottom: 5),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      controller: nameController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8), // Added this
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Name',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      controller: phoneController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8), // A
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Phone',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: TextFormField(
                      style: const TextStyle(fontSize: 14),
                      controller: addressController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8), // A
                        isDense: true,
                        border: OutlineInputBorder(),
                        labelText: 'Address',
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Expanded(
                      child: TextFormField(
                        style: const TextStyle(fontSize: 14),
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        textAlignVertical: TextAlignVertical.top,
                        controller: noteController,
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.all(8), // A
                          isDense: true,
                          border: OutlineInputBorder(),
                          labelText: 'Note',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
