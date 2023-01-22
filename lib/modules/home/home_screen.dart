import 'dart:async';
import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive/hive.dart';
import 'package:Arpan/global/models/shop_model.dart';
import 'package:Arpan/global/utils/constants.dart';
import 'package:Arpan/global/utils/router.dart';
import 'package:Arpan/global/utils/screen_wrapper.dart';
import 'package:Arpan/global/utils/theme_data.dart';
import 'package:Arpan/global/widgets/custom_app_bar.dart';
import 'package:Arpan/global/widgets/custom_bottom_bar.dart';
import 'package:Arpan/global/widgets/custom_drawer.dart';
import 'package:Arpan/modules/order/models/order_item_response.dart';
import 'package:Arpan/modules/order/services/order_service.dart';
import 'package:Arpan/modules/others/services/others_service.dart';

import '../../global/models/notice_model.dart';
import '../../global/models/settings_model.dart';
import '../../global/networking/responses/home_response.dart';
import '../../global/utils/colors_converter.dart';
import '../../global/utils/show_toast.dart';
import '../../global/utils/utils.dart';
import '../../main.dart';
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

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();
  late HomeResponse _homeResponse;
  List<Widget> imageSliders = [];
  List<Widget> noticeSliders = [];
  final homeService = HomeService();
  late TabController tabController;
  final double expandedHeight = 340.0;
  final double collapsedHeight = 5;
  Map<int, dynamic> itemKeys = {};

  // prevent animate when press on tab bar
  bool pauseRectGetterIndex = false;

  // States
  var loadingMain = true;
  var error = "";
  var enableCarouselSlider = false;
  var enableNoticesSlider = false;
  var showShopCategories = false;

  var currentSelectedCategory = 0;
  var filteredShops = <Shop>[];

  bool isCollapsed = false;

  OrderItemResponse? lastOrderData;

  Timer? _autoRefreshTimer;

  void getLastOrderData({bool? silently}) async {
    // debugPrint("Get Last Order Data Called");
    var data = await OrderService().getLastOrder();
    if (data != null) {
      if (data.orderId != null) {
        setState(() {
          lastOrderData = data;
        });
      }
    } else {
      setState(() {
        lastOrderData = null;
      });
    }
  }

  void getHomeResponse({bool? silently}) async {
    // debugPrint("Get Home Response Called. Silently : $silently");
    if (!mounted) return;
    var response = await homeService.getHomeDataMain();
    if (response == null) {
      // debugPrint("Response is null");
      if (silently != true) {
        showDialog<void>(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Connection failed!'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text(
                        'Failed to fetch data. Are you sure you\'re connected to internet?'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Yes, Reload'),
                  onPressed: () {
                    navigatorKey.currentState?.pop();
                    getHomeResponse();
                  },
                ),
              ],
            );
          },
        );
      }
    } else {
      // debugPrint(response.toString());
      _homeResponse = response;
      if (_homeResponse.banners != null ||
          _homeResponse.shops != null ||
          _homeResponse.shopCategories != null ||
          _homeResponse.notices != null ||
          _homeResponse.settings != null) {
        Hive.box<Settings>("settingsBox")
            .put("current", _homeResponse.settings!);
        if (mounted && silently != true) {
          checkSettingsForAlertDialog(context, _homeResponse.settings!);
        }
        setState(() {
          loadingMain = false;
          error = "";
          if (_homeResponse.banners != null) {
            if (_homeResponse.banners!.isNotEmpty) {
              imageSliders = getImageSliders(_homeResponse.banners!, context);
              enableCarouselSlider = true;
            }
          }
          if (_homeResponse.notices != null) {
            if (_homeResponse.notices!.isNotEmpty) {
              var tempNotices = <Notice>[];
              for (Notice notice in _homeResponse.notices!) {
                if (notice.timeBased == true) {
                  if (checkNoticeStatus(notice)) {
                    tempNotices.add(notice);
                  }
                } else {
                  tempNotices.add(notice);
                }
              }
              noticeSliders = getNoticeSliders(tempNotices, context);
              enableNoticesSlider = true;
            }
          }
          if (_homeResponse.shopCategories != null) {
            var filCatsTemp = _homeResponse.shopCategories!
                .where((element) => _homeResponse.shops!.any((element1) =>
                    element1.categories
                        ?.any((element2) => element2 == element.id) ??
                    false))
                .toList();
            _homeResponse.shopCategories = filCatsTemp;
            _homeResponse.shopCategories!
                .insert(0, category_model.Category(name: "All", id: "ALL"));

            if (silently != true) {
              tabController = TabController(
                  length: _homeResponse.shopCategories!.length, vsync: this);
            }
            showShopCategories = true;
          }
        });
        if (_homeResponse.shops != null && silently != true) {
          filterShops(0);
        }
      } else {
        // debugPrint("Response get error");
        if (!mounted) return;
        showToast(context, "No data found");
      }
    }
    getLastOrderData(silently: silently);
  }

  void filterShops(int index) {
    currentSelectedCategory = index;
    if (_homeResponse.shops != null && _homeResponse.shopCategories != null) {
      setState(() {
        if (currentSelectedCategory != 0) {
          filteredShops = _homeResponse.shops!
              .where((element) => element.categories!.contains(
                  _homeResponse.shopCategories![currentSelectedCategory].id))
              .toList();
        } else {
          filteredShops = _homeResponse.shops!;
        }
      });
    }
  }

  void openShop(String shopId, String name, String icon, String shopLocation,
      String coverPhoto, List<Notices>? notices) {
    navigatorKey.currentState?.pushNamed(Routes.products, arguments: {
      "shopId": shopId,
      "shopName": name,
      "shopIcon": icon,
      "shopLocation": shopLocation,
      "shopCoverPhoto": coverPhoto,
      "notices": notices
    });
  }

  @override
  void initState() {
    super.initState();
    // debugPrint("User Entered The HomePage First Time");
    getHomeResponse();
    // _autoRefreshTimer = Timer.periodic(
    //     const Duration(seconds: autoRefreshDelaySeconds),
    //     (Timer t) => getLastOrderData(silently: true));
  }

  @override
  void dispose() {
    // _autoRefreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _refresh() async {
    setState(() {
      loadingMain = true;
    });
    getHomeResponse();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
      onLeaveScreen: () {
        debugPrint("User Left The HomePage");
        _autoRefreshTimer?.cancel();
      },
      routeName: Routes.home,
      onEnterScreen: () {
        getHomeResponse(silently: true);
        debugPrint("User Returned To The HomePage");
        // _autoRefreshTimer = Timer.periodic(
        //     const Duration(seconds: autoRefreshDelaySeconds),
        //     (Timer t) => getHomeResponse(silently: true));
      },
      child: Scaffold(
        appBar: const CustomAppBar(
          height: appBarHeight,
          title: "Arpan",
        ),
        backgroundColor: bgOffWhite,
        bottomNavigationBar: lastOrderData != null
            ? CustomBottomBar(context, lastOrderData!)
            : null,
        drawer: customDrawer(context),
        body: loadingMain
            ? const Center(
                child: CircularProgressIndicator(
                  color: textBlue,
                ),
              )
            : buildSliverScrollView(),
      ),
    );
  }

  Widget buildSliverScrollView() {
    return RefreshIndicator(
      key: _refreshIndicatorKey,
      onRefresh: _refresh,
      child: CustomScrollView(
        slivers: [
          buildHomeStickyTabs(),
          buildBody(),
        ],
      ),
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
              filteredShops[index].notices);
        }, checkShopStatus(filteredShops[index].activeHours),
            filteredShops[index].activeHours),
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
      enableNoticesSlider: enableNoticesSlider,
      noticeSliders: noticeSliders,
      isCollapsed: isCollapsed,
      onCollapsed: onCollapsed,
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      onSelected: (int index) {
        filterShops(index);
      },
    );
  }

  Card buildShopCard(String image, String name, String location,
      VoidCallback onClick, bool shopStatus, String? activeHours) {
    return Card(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10.0))),
      color: bgWhite,
      elevation: 2,
      child: InkWell(
        onTap: shopStatus
            ? onClick
            : () {
                showToast(context, "This shop is currently closed!");
              },
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(45),
                    child: CachedNetworkImage(
                      height: 90,
                      width: 90,
                      imageUrl: image,
                      placeholder: (context, url) =>
                          Image.asset("assets/images/transparent.png"),
                      errorWidget: (context, url, error) => Image.asset(
                        "assets/images/Default_Image_Thumbnail.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 16,
                            color: textBlack,
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
                            fontSize: 13,
                            color: textBlack,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            shopStatus
                ? Container()
                : ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      child: Center(
                        child: Text(
                          "Closed Now!\nWill be open at ${convertTo12HoursFormat(activeHours!.split("TO")[0])}",
                          style: TextStyle(color: textWhite),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      color: overlayColor,
                      width: double.infinity,
                      height: 90,
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
  return carouselResponse.map(
    (item) {
      // debugPrint("CarouselImageLink: ${serverFilesBaseURL + item.icon.toString()}");
      return Padding(
        padding: const EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: CachedNetworkImage(
            imageUrl: serverFilesBaseURL + item.icon!,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Image.asset("assets/images/transparent.png"),
            errorWidget: (context, url, error) => Image.asset(
              "assets/images/Default_Image_Thumbnail.png",
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    },
  ).toList();
}

List<Widget> getNoticeSliders(
    List<Notice> carouselResponse, BuildContext context) {
  return carouselResponse
      .map(
        (item) => SizedBox(
          height: 50,
          child: Card(
            color: HexColor.fromHex(item.backgroundColorHex!),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  item.textTitle.toString(),
                  style: TextStyle(color: HexColor.fromHex(item.textColorHex!)),
                ),
              ),
            ),
          ),
        ),
      )
      .toList();
}
