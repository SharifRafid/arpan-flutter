import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:ui_test/global/models/cart_item_model.dart';
import 'package:ui_test/global/models/shop_model.dart';
import 'package:ui_test/global/utils/show_toast.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/global/widgets/custom_app_bar.dart';
import 'package:ui_test/modules/home/models/product_category_file.dart';
import 'package:ui_test/modules/home/services/home_service.dart';
import 'package:ui_test/modules/home/widgets/product_sticky_tab.dart';
import 'package:ui_test/modules/home/widgets/products_app_bar.dart';

import '../../global/models/category_model.dart';
import '../../global/models/product_model.dart';
import '../../global/networking/responses/products_response.dart';
import 'cart_screen.dart';
import 'widgets/product_category_section.dart';

class ProductsPage extends StatefulWidget {
  final String shopId;
  final String shopName;
  final String shopIcon;
  final String shopCoverPhoto;
  final String shopLocation;
  final List<Notices>? notices;

  const ProductsPage(
      {Key? key,
      required this.shopId,
      required this.shopName,
      required this.shopIcon,
      required this.shopLocation,
      required this.shopCoverPhoto,
      required this.notices})
      : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage>
    with SingleTickerProviderStateMixin {
  HomeService homeService = HomeService();
  List<ProductCategorized> _categorizedProducts = [];
  var productsLoaded = false;

  void fetchData() async {
    ProductsResponse? pR = await homeService.getProductsOfShop(widget.shopId);
    if (pR == null) {
      if (!mounted) return;
      showToast(context, "Failed to fetch data");
    } else {
      if (pR.shop == null) {
        if (!mounted) return;
        showToast(context, "Failed to fetch data");
        return;
      }
      if (pR.products == null) {
        if (!mounted) return;
        showToast(context, "Failed to fetch data");
        return;
      }
      _categorizedProducts.clear();
      for (var category in pR.shop!.productCategories!) {
        List<Product> tempL = [];
        for (var productT in pR.products!) {
          if (productT.categories != null) {
            if (productT.categories!.isNotEmpty) {
              if (productT.categories!.contains(category)) {
                tempL.add(productT);
              }
            }
          }
        }
        Category catTemp = Category(name: "Unnamed", id: "Unnamed", order: 1);
        for (var catP in pR.shopCategories!) {
          if (catP.id != null) {
            if (catP.id == category) {
              catTemp = Category(name: catP.name, id: catP.id, order: catP.order);
            }
          }
        }
        if(tempL.isNotEmpty){
          _categorizedProducts.add(ProductCategorized(
              id: category,
              name: catTemp.name.toString(),
              order: catTemp.order!,
              products: tempL));
        }
      }
      tabController = TabController(length: _categorizedProducts.length, vsync: this);
      setState(() {
        productsLoaded = true;
      });
    }
  }

  bool isCollapsed = false;
  late AutoScrollController scrollController;
  late TabController tabController;
  final double expandedHeight = 270.0;
  final double collapsedHeight = 0;

  final listViewKey = RectGetter.createGlobalKey();
  Map<int, dynamic> itemKeys = {};

  // prevent animate when press on tab bar
  bool pauseRectGetterIndex = false;

  void addItemToCart(Product product) async {
    Box box = Hive.box<CartItemMain>("cart");
    var result = box.values.where((element) => element.sId == product.id);
    CartItemMain cartItemMain;
    if (result.isEmpty) {
      cartItemMain = CartItemMain();
      cartItemMain.sId = product.id;
      cartItemMain.productItem = true;
      cartItemMain.productArpanProfit = product.arpanCharge;
      cartItemMain.productItemAmount = 1;
      cartItemMain.productItemCategoryTag =
          product.categories != null ? product.categories![0] : "";
      cartItemMain.productItemKey = product.id;
      cartItemMain.productItemDesc = product.shortDescription;
      cartItemMain.productItemOfferPrice = product.offerPrice;
      cartItemMain.productItemPrice = product.price;
      cartItemMain.productItemName = product.name;
      cartItemMain.productItemImage = product.icon;
      cartItemMain.productItemShopKey = product.shop;
      cartItemMain.productItemShopName = widget.shopName;
      await box.add(cartItemMain);
      await cartItemMain.save();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Item added to cart"),
          duration: const Duration(milliseconds: 500),
          action: SnackBarAction(
            label: 'Open cart',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
          ),
        ),
      );
    } else {
      cartItemMain = result.elementAt(0);
      cartItemMain.productItemAmount = cartItemMain.productItemAmount! + 1;
      await cartItemMain.save();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Cart updated"),
          duration: const Duration(milliseconds: 1000),
          action: SnackBarAction(
            label: 'Open cart',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const CartScreen()));
            },
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    scrollController = AutoScrollController();
    fetchData();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    tabController.dispose();
    super.dispose();
  }

  List<int> getVisibleItemsIndex() {
    Rect? rect = RectGetter.getRectFromKey(listViewKey);
    List<int> items = [];
    if (rect == null) return items;
    itemKeys.forEach((index, key) {
      Rect? itemRect = RectGetter.getRectFromKey(key);
      if (itemRect == null) return;
      if (itemRect.top > rect.bottom) return;
      if (itemRect.bottom < rect.top) return;
      items.add(index);
    });
    return items;
  }

  void onCollapsed(bool value) {
    if (this.isCollapsed == value) return;
    setState(() => this.isCollapsed = value);
  }

  bool onScrollNotification(ScrollNotification notification) {
    if (pauseRectGetterIndex) return true;
    int lastTabIndex = tabController.length - 1;
    List<int> visibleItems = getVisibleItemsIndex();

    bool reachLastTabIndex = visibleItems.isNotEmpty &&
        visibleItems.length <= 2 &&
        visibleItems.last == lastTabIndex;
    if (reachLastTabIndex) {
      tabController.animateTo(lastTabIndex);
    } else if (visibleItems.isNotEmpty) {
      int sumIndex = visibleItems.reduce((value, element) => value + element);
      int middleIndex = sumIndex ~/ visibleItems.length;
      if (tabController.index != middleIndex)
        tabController.animateTo(middleIndex);
    }
    return false;
  }

  void animateAndScrollTo(int index) {
    pauseRectGetterIndex = true;
    tabController.animateTo(index);
    scrollController
        .scrollToIndex(index, preferPosition: AutoScrollPosition.begin)
        .then((value) => pauseRectGetterIndex = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgOffWhite,
      appBar: ProductsAppBar(
        height: appBarHeight,
        title: widget.shopName,
      ),
      body: Container(
        child: productsLoaded == true
            ? RectGetter(
                key: listViewKey,
                child: NotificationListener<ScrollNotification>(
                  onNotification: onScrollNotification,
                  child: buildSliverScrollView(),
                ),
              )
            : const Center(
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }

  Widget buildSliverScrollView() {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        buildAppBar(),
        buildBody(),
      ],
    );
  }

  SliverAppBar buildAppBar() {
    return ProductStickyTab(
        data: _categorizedProducts,
        expandedHeight: expandedHeight,
        collapsedHeight: collapsedHeight,
        isCollapsed: isCollapsed,
        onCollapsed: onCollapsed,
        tabController: tabController,
        onTap: (index) => animateAndScrollTo(index),
        shopCoverPhoto: widget.shopCoverPhoto,
        shopName: widget.shopName,
        shopIcon: widget.shopIcon,
        shopLocation: widget.shopLocation,
        shopNotices: widget.notices);
  }

  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => buildCategoryItem(index),
        childCount: _categorizedProducts.length,
      ),
    );
  }

  Widget buildCategoryItem(int index) {
    itemKeys[index] = RectGetter.createGlobalKey();
    ProductCategorized category = _categorizedProducts[index];
    return RectGetter(
      key: itemKeys[index],
      child: AutoScrollTag(
        key: ValueKey(index),
        index: index,
        controller: scrollController,
        child: CategorySection(category: category, onClickAdd: addItemToCart),
      ),
    );
  }
}
