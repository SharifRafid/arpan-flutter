import 'dart:collection';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ui_test/global/models/shop_model.dart';
import 'package:ui_test/global/utils/constants.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/global/widgets/custom_app_bar.dart';
import 'package:ui_test/global/widgets/custom_bottom_bar.dart';
import 'package:ui_test/global/widgets/custom_drawer.dart';
import 'package:ui_test/modules/order/models/order_item_response.dart';
import 'package:ui_test/modules/order/services/order_service.dart';
import 'package:ui_test/modules/others/services/others_service.dart';

import '../../global/models/notice_model.dart';
import '../../global/models/settings_model.dart';
import '../../global/networking/responses/home_response.dart';
import '../../global/utils/colors_converter.dart';
import '../../global/utils/show_toast.dart';
import '../../global/utils/utils.dart';
import 'products_screen.dart';
import 'services/home_service.dart';
import '../../global/models/banner_model.dart' as banner_model;
import '../../global/models/category_model.dart' as category_model;
import 'widgets/home_sticky_tabs.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
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

  void getLastOrderData() async {
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

  void getHomeResponse() async {
    if (!mounted) return;
    var response = await homeService.getHomeDataMain();
    if (response == null) {
      if (kDebugMode) {
        print("Response is null");
      }
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
                  Navigator.pop(context);
                  getHomeResponse();
                },
              ),
            ],
          );
        },
      );
    } else {
      _homeResponse = response;
      if (_homeResponse.banners != null ||
          _homeResponse.shops != null ||
          _homeResponse.shopCategories != null ||
          _homeResponse.notices != null ||
          _homeResponse.settings != null) {
        Hive.box<Settings>("settingsBox")
            .put("current", _homeResponse.settings!);
        if (mounted) {
          checkSettings(context, _homeResponse.settings!);
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
              noticeSliders = getNoticeSliders(_homeResponse.notices!, context);
              enableNoticesSlider = true;
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
    getLastOrderData();
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
      String coverPhoto, List<Notices>? notices) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsPage(
              shopId: shopId,
              shopName: name,
              shopIcon: icon,
              shopLocation: shopLocation,
              shopCoverPhoto: coverPhoto,
              notices: notices),
        ));
  }

  void initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    var authBox = Hive.box('authBox');
    if (authBox.get("accessToken", defaultValue: "") == "" ||
        authBox.get("refreshToken", defaultValue: "") == "") {
      return;
    }

    String? token;
    if (kIsWeb) {
      token = await messaging.getToken(
        vapidKey:
            "BIgHP7EqgpZXidJsM7wBfTzSgprBDxTK_3FZYju4oP5ggJLUWo2gna-KGDTWgIicbpuoA9VxvLtXZN0sDhrf2XA",
      );
    } else {
      token = await messaging.getToken();
    }

    if (token != null) {
      if (authBox.get("FCMTOKEN", defaultValue: "") == "" ||
          authBox.get("FCMTOKEN", defaultValue: "") != token) {
        HashMap<String, dynamic> hashMap = HashMap();
        hashMap["fcmToken"] = token;
        String? response = await OthersService().addRegistrationToken(hashMap);
        if (response != null) {
          authBox.put("FCMTOKEN", token);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getHomeResponse();
    initFirebaseMessaging();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');
      if (message.notification != null) {
        debugPrint(
            'Message also contained a notification: ${message.notification}');
      }
      getLastOrderData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              filteredShops[index].notices);
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
              placeholder: (context, url) =>
                  Image.asset("assets/images/transparent.png"),
              errorWidget: (context, url, error) => Image.asset(
                "assets/images/Default_Image_Thumbnail.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      )
      .toList();
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
