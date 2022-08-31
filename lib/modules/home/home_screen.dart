import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late HomeResponse _homeResponse;
  late List<Widget> imageSliders;
  final homeService = HomeService();

  // States
  var loadingMain = true;
  var error = "";
  var enableCarouselSlider = false;
  var showShopCategories = false;

  var currentSelectedCategory = 0;
  var filteredShops = <Shop>[];

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

  void openShop(String shopId, String name, String icon, String coverPhoto) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductsPage(
            shopId: shopId,
            shopName: name,
            shopIcon: icon,
            shopCoverPhoto: coverPhoto,
          ),
        ));
  }

  int _current = 0;
  final CarouselController _controller = CarouselController();

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
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            enableCarouselSlider
                ? CarouselSlider(
                    items: imageSliders,
                    carouselController: _controller,
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        height: 150,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                  )
                : Container(),
            enableCarouselSlider
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imageSliders.asMap().entries.map((entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 7.0,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? bgWhite
                                      : bgBlue)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  )
                : Container(),
            showShopCategories
                ? SizedBox(
                    height: 45,
                    child: ListView.builder(
                      physics: const ClampingScrollPhysics(),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: _homeResponse.shopCategories!.length,
                      itemBuilder: (BuildContext context, int index) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: currentSelectedCategory != index
                                ? InkWell(
                                    onTap: () {
                                      filterShops(index);
                                    },
                                    child: Text(
                                      _homeResponse.shopCategories![index].name
                                          .toString(),
                                      style: const TextStyle(
                                          color: textBlue, fontSize: 15),
                                    ),
                                  )
                                : IntrinsicWidth(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          _homeResponse
                                              .shopCategories![index].name
                                              .toString(),
                                          style: const TextStyle(
                                              color: textBlue, fontSize: 15),
                                        ),
                                        ConstrainedBox(
                                          constraints: BoxConstraints.loose(
                                              Size.infinite),
                                          child: Container(
                                            height: 5,
                                            decoration: BoxDecoration(
                                                color: textBlue,
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Container(),
            filteredShops.isNotEmpty
                ? ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: filteredShops.length,
                    itemBuilder: (BuildContext context, int index) => Container(
                          child: buildShopCard(
                              serverFilesBaseURL +
                                  filteredShops[index].icon.toString(),
                              filteredShops[index].name.toString(),
                              filteredShops[index].location.toString(), () {
                            openShop(
                              filteredShops[index].id.toString(),
                              filteredShops[index].name.toString(),
                              filteredShops[index].icon.toString(),
                              filteredShops[index].coverPhoto.toString(),
                            );
                          }),
                        ))
                : Container(),
          ],
        ),
      ),
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
                child: Image(
                  height: 100,
                  width: 100,
                  image: NetworkImage(image),
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
            child: Image.network(
              serverFilesBaseURL + item.icon!,
              fit: BoxFit.cover,
            ),
          ),
        ),
      )
      .toList();
}
