import 'package:flutter/material.dart';
import 'package:ui_test/global/utils/constants.dart';
import 'package:ui_test/global/utils/show_toast.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/global/widgets/custom_app_bar.dart';
import 'package:ui_test/modules/home/services/home_service.dart';

import '../../global/networking/responses/products_response.dart';

class ProductsPage extends StatefulWidget {
  final String shopId;
  final String shopName;
  final String shopIcon;
  final String shopCoverPhoto;

  const ProductsPage(
      {Key? key,
      required this.shopId,
      required this.shopName,
      required this.shopIcon,
      required this.shopCoverPhoto})
      : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  HomeService homeService = HomeService();
  late ProductsResponse _productsResponse;

  var productsLoaded = false;

  void fetchData() async {
    ProductsResponse? pR = await homeService.getProductsOfShop(widget.shopId);
    if (pR == null) {
      if (!mounted) return;
      showToast(context, "Failed to fetch data");
    } else {
      _productsResponse = pR;
      setState(() {
        productsLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(height: appBarHeight, title: widget.shopName),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      serverFilesBaseURL + widget.shopCoverPhoto,
                      fit: BoxFit.cover,
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: Image.network(
                        serverFilesBaseURL + widget.shopIcon,
                        height: 100,
                        width: 100,
                      ),
                    )
                  ],
                ),
              ),
            ),
            const Center(
              child: CircularProgressIndicator(),
            )
          ],
        ),
      ),
    );
  }
}
