import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/home/models/product_category_file.dart';

import '../../../global/utils/constants.dart';

class ProductStickyTab extends SliverAppBar {
  final List<ProductCategorized> data;
  final bool isCollapsed;
  final double expandedHeight;
  final double collapsedHeight;
  final TabController tabController;
  final void Function(bool isCollapsed) onCollapsed;
  final void Function(int index) onTap;
  final String shopCoverPhoto;
  final String shopIcon;
  final String shopLocation;
  final String shopName;

  ProductStickyTab({
    required this.data,
    required this.isCollapsed,
    required this.expandedHeight,
    required this.collapsedHeight,
    required this.onCollapsed,
    required this.onTap,
    required this.tabController,
    required this.shopCoverPhoto,
    required this.shopIcon,
    required this.shopLocation,
    required this.shopName,
  }) : super(
            elevation: 4.0,
            pinned: true,
            forceElevated: true,
            excludeHeaderSemantics: true);

  @override
  Color? get backgroundColor => bgOffWhite;

  @override
  List<Widget>? get actions {
    return <Widget>[Container()];
  }

  @override
  Widget? get title {
    return Container();
  }

  @override
  Widget? get leading {
    return Container();
  }

  @override
  PreferredSizeWidget? get bottom {
    return PreferredSize(
      preferredSize: const Size.fromHeight(48),
      child: Container(
        color: bgOffWhite,
        child: TabBar(
          isScrollable: true,
          controller: tabController,
          labelColor: textBlue,
          indicator: MaterialIndicator(
              color: textBlue,
              paintingStyle: PaintingStyle.fill,
              bottomLeftRadius: 5,
              bottomRightRadius: 5,
              horizontalPadding: 10),
          unselectedLabelColor: textBlue,
          tabs: data.map((e) {
            return Tab(text: e.name);
          }).toList(),
          onTap: onTap,
        ),
      ),
    );
  }

  @override
  Widget? get flexibleSpace {
    return LayoutBuilder(
      builder: (
        BuildContext context,
        BoxConstraints constraints,
      ) {
        final top = constraints.constrainHeight();
        final collapsedHight =
            MediaQuery.of(context).viewPadding.top + kToolbarHeight + 48;
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          onCollapsed(collapsedHight != top);
        });

        return FlexibleSpaceBar(
          collapseMode: CollapseMode.pin,
          background: Column(
            children: [
              SizedBox(
                height: 200,
                child: Column(
                  children: [
                    Expanded(
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          CachedNetworkImage(
                            height: 130,
                            imageUrl: serverFilesBaseURL + shopCoverPhoto,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ],
                      ),
                    ),
                    Card(
                      color: bgOffWhite,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      elevation: .1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: SizedBox.fromSize(
                              size: const Size.fromRadius(30),
                              child: CachedNetworkImage(
                                height: 60,
                                width: 60,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageUrl: serverFilesBaseURL + shopIcon,
                                fit: BoxFit.cover,
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
                                    shopName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: textBlack,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.location_on,
                                        size: 14,
                                        color: textGrey,
                                      ),
                                      Text(
                                        shopLocation,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: textGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
