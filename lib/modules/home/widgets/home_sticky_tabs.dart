import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:ui_test/global/models/category_model.dart';
import 'package:ui_test/modules/home/widgets/image_slider.dart';
import 'package:ui_test/modules/order/parcel_order_screen.dart';
import 'package:ui_test/modules/order/pick_drop_order_screen.dart';

import '../../../global/utils/theme_data.dart';
import '../../order/custom_order_screen.dart';
import '../../order/medicine_order_screen.dart';

class HomeStickyTabs extends SliverAppBar {
  final TabController tabController;
  final List<Category> categories;
  final int currentSelectedCategory;
  final bool enableCarouselSlider;
  final bool isCollapsed;
  final Function onSelected;
  final List<Widget> imageSliders;
  final void Function(bool isCollapsed) onCollapsed;
  final double expandedHeight;
  final double collapsedHeight;

  const HomeStickyTabs({
    required this.tabController,
    required this.categories,
    required this.currentSelectedCategory,
    required this.enableCarouselSlider,
    required this.imageSliders,
    required this.isCollapsed,
    required this.onCollapsed,
    required this.onSelected,
    required this.expandedHeight,
    required this.collapsedHeight,
  }) : super(
            elevation: 0.0,
            pinned: true,
            forceElevated: true,
            scrolledUnderElevation: 3.0);

  @override
  Color? get backgroundColor => bgOffWhite;

  @override
  Widget? get title => Container();

  @override
  Widget? get leading => Container();

  @override
  List<Widget>? get actions {
    return <Widget>[Container()];
  }

  @override
  Widget? get flexibleSpace {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final top = constraints.constrainHeight();
        final collapsedHight = MediaQuery.of(context).viewPadding.top;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          onCollapsed(collapsedHight != top);
        });
        return FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Column(
            children: [
              enableCarouselSlider == true
                  ? ImageSlider(imageSliders)
                  : Container(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const CustomOrderScreen()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.dashboard_customize,
                              color: bgBlue,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Custom Order",
                                style: TextStyle(color: textBlue,fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) => const MedicineOrderScreen())
                          );
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.medical_services,
                              color: bgBlue,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Medicine",
                                style: TextStyle(color: textBlue,fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const ParcelOrderScreen()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.delivery_dining_rounded,
                              color: bgBlue,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Parcel",
                                style: TextStyle(color: textBlue,fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    height: 80,
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      const PickDropOrderScreen()));
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.cached_rounded,
                              color: bgBlue,
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Pick & Drop",
                                style: TextStyle(color: textBlue,fontSize: 12),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  PreferredSizeWidget? get bottom {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: buildTabBar(
          tabController, categories, currentSelectedCategory, onSelected),
    );
  }
}

TabBar buildTabBar(TabController tabController, List<Category> categories,
    int currentSelectedCategory, Function onSelected) {
  return TabBar(
    tabs: categories.map((e) {
      return Tab(
        text: e.name!,
      );
    }).toList(),
    isScrollable: true,
    controller: tabController,
    indicator: MaterialIndicator(
        color: textBlue,
        paintingStyle: PaintingStyle.fill,
        bottomLeftRadius: 5,
        bottomRightRadius: 5,
        horizontalPadding: 10),
    labelColor: textBlue,
    unselectedLabelColor: textBlue,
    onTap: (index) {
      onSelected(index);
    },
  );
}
