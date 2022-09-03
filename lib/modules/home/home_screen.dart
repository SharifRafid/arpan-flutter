import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rect_getter/rect_getter.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:ui_test/global/models/shop_model.dart';
import 'package:ui_test/global/utils/constants.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/global/widgets/custom_app_bar.dart';

import '../../global/networking/responses/home_response.dart';
import '../../global/utils/show_toast.dart';
import 'products_screen.dart';
import 'services/home_service.dart';
import '../../global/models/banner_model.dart' as banner_model;
import '../../global/models/category_model.dart' as category_model;
import 'widgets/home_sticky_tabs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late HomeResponse _homeResponse;
  late List<Widget> imageSliders;
  final homeService = HomeService();
  late TabController tabController;
  final double expandedHeight = 200.0;
  final double collapsedHeight = 5;
  Map<int, dynamic> itemKeys = {};

  // prevent animate when press on tab bar
  bool pauseRectGetterIndex = false;

  // States
  var loadingMain = true;
  var error = "";
  var enableCarouselSlider = false;
  var showShopCategories = false;

  var currentSelectedCategory = 0;
  var filteredShops = <Shop>[];

  bool isCollapsed = false;

  void getHomeResponse() async {
    if (mounted) {
      var response = await homeService.getHomeDataMain();
      if (response == null) {
        if (kDebugMode) {
          print("Response is null");
        }
      } else {
        _homeResponse = response;
        if (_homeResponse.banners != null ||
            _homeResponse.shops != null ||
            _homeResponse.shopCategories != null ||
            _homeResponse.notices != null ||
            _homeResponse.settings != null) {
          setState(() {
            loadingMain = false;
            error = "";
            if (_homeResponse.banners != null) {
              if (_homeResponse.banners!.isNotEmpty) {
                imageSliders = getImageSliders(_homeResponse.banners!, context);
                enableCarouselSlider = true;
              }
            }
            if (_homeResponse.shopCategories != null) {
              _homeResponse.shopCategories!
                  .insert(0, category_model.Category(name: "All", id: "ALL"));
              tabController = TabController(
                  length: _homeResponse.shopCategories!.length, vsync: this);
              showShopCategories = true;
            }
          });
          if (_homeResponse.shops != null) {
            filterShops(0);
          }
        } else {
          if (kDebugMode) {
            print("Response get error");
          }
          if (!mounted) return;
          showToast(context, "No data found");
        }
      }
    }
  }

  void filterShops(int index) {
    currentSelectedCategory = index;
    if (_homeResponse.shops != null && _homeResponse.shopCategories != null) {
      setState(() {
        if (currentSelectedCategory == 0) {
          filteredShops = _homeResponse.shops!;
        } else {
          filteredShops = _homeResponse.shops!
              .where((element) => element.categories!.contains(
                  _homeResponse.shopCategories![currentSelectedCategory].id))
              .toList();
        }
      });
    }
  }

  void openShop(String shopId, String name, String icon, String shopLocation,
      String coverPhoto) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsPage(
            shopId: shopId,
            shopName: name,
            shopIcon: icon,
            shopLocation: shopLocation,
            shopCoverPhoto: coverPhoto,
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    getHomeResponse();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        height: appBarHeight,
        title: "Arpan",
      ),
      backgroundColor: bgOffWhite,
      body: loadingMain
          ? const Center(
              child: CircularProgressIndicator(
                color: textBlue,
              ),
            )
          : buildSliverScrollView(),
    );
  }

  Widget buildSliverScrollView() {
    return CustomScrollView(
      slivers: [
        buildHomeStickyTabs(),
        buildBody(),
      ],
    );
  }

  SliverList buildBody() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => buildShopCard(
            serverFilesBaseURL + filteredShops[index].icon.toString(),
            filteredShops[index].name.toString(),
            filteredShops[index].location.toString(), () {
          openShop(
            filteredShops[index].id.toString(),
            filteredShops[index].name.toString(),
            filteredShops[index].icon.toString(),
            filteredShops[index].location.toString(),
            filteredShops[index].coverPhoto.toString(),
          );
        }),
        childCount: filteredShops.length,
      ),
    );
  }

  void onCollapsed(bool value) {
    if (isCollapsed == value) return;
    setState(() => isCollapsed = value);
  }

  Widget buildHomeStickyTabs() {
    return HomeStickyTabs(
      tabController: tabController,
      categories: _homeResponse.shopCategories!,
      currentSelectedCategory: currentSelectedCategory,
      enableCarouselSlider: enableCarouselSlider,
      imageSliders: imageSliders,
      isCollapsed: isCollapsed,
      onCollapsed: onCollapsed,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      onSelected: (int index) {
        filterShops(index);
      },
    );
  }

  Card buildShopCard(
      String image, String name, String location, VoidCallback onClick) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      color: bgWhite,
      elevation: 2,
      child: InkWell(
        onTap: onClick,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox.fromSize(
                size: const Size.fromRadius(50),
                child: CachedNetworkImage(
                  height: 100,
                  width: 100,
                  imageUrl: image,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 17,
                        color: textBlue,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Divider(
                        thickness: .5,
                        height: .5,
                        color: textBlack,
                      ),
                    ),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 14,
                        color: textBlue,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

List<Widget> getImageSliders(
    List<banner_model.Banner> carouselResponse, BuildContext context) {
  return carouselResponse
      .map(
        (item) => Padding(
          padding: const EdgeInsets.only(top: 10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: serverFilesBaseURL + item.icon!,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
        ),
      )
      .toList();
}
