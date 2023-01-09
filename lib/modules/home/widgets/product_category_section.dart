import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ui_test/global/models/product_model.dart';
import 'package:ui_test/global/utils/constants.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/global/utils/utils.dart';
import 'package:ui_test/modules/home/models/product_category_file.dart';

import '../../../global/utils/show_toast.dart';

class CategorySection extends StatelessWidget {
  final ProductCategorized category;
  final void Function(Product product) onClickAdd;

  const CategorySection({
    Key? key,
    required this.category,
    required this.onClickAdd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      margin: const EdgeInsets.only(bottom: 16, top: 5),
      color: bgOffWhite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTileHeader(context),
          _buildFoodTileList(context),
        ],
      ),
    );
  }

  Widget _buildFoodTileList(BuildContext context) {
    return Column(
      children: List.generate(
        category.products.length,
        (index) {
          final food = category.products[index];
          bool isLastIndex = index == category.products.length - 1;
          return _buildFoodTile(
            food: food,
            context: context,
            isLastIndex: isLastIndex,
          );
        },
      ),
    );
  }

  Widget _buildSectionTileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 5),
        _sectionTitle(context),
        const SizedBox(height: 6.0),
        // category.subtitle != null ? _sectionSubtitle(context) : const SizedBox(),
        const SizedBox(height: 5),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8.0, 0),
      child: Row(
        children: [
          Text(
            category.name,
            style: _textTheme(context).headline6,
          )
        ],
      ),
    );
  }

  Widget _buildFoodTile({
    required BuildContext context,
    required bool isLastIndex,
    required Product food,
  }) {
    return Column(
      children: [
        checkShopStatus(food.activeHours)
            ? Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                color: bgWhite,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildFoodDetail(food: food, context: context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _buildFoodImage(food.icon),
                          _buildAddIcon(food),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                color: bgWhite,
                elevation: 2,
                child: InkWell(
                  onTap: () {
                    showToast(context, "This shop is currently closed!");
                  },
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildFoodDetail(food: food, context: context),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildFoodImage(food.icon),
                              ],
                            )
                          ],
                        ),
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          child: Center(
                            child: Text(
                              "Unavailable now!\nWill be available at ${convertTo12HoursFormat(food.activeHours!.split("TO")[0])}",
                              style: TextStyle(color: textWhite),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          color: overlayColor,
                          width: double.infinity,
                          height: 105,
                        ),
                      )
                    ],
                  ),
                ),
              ),
        !isLastIndex ? const SizedBox(height: 2.0) : const SizedBox(height: 2.0)
      ],
    );
  }

  Widget _buildAddIcon(Product food) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4.0))),
        color: bgBlue,
        child: InkWell(
          onTap: () {
            onClickAdd(food);
          },
          child: const Padding(
            padding: EdgeInsets.all(14.0),
            child: Icon(
              Icons.add,
              color: textWhite,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFoodImage(String? url) {
    if (url == null) {
      return Container();
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox.fromSize(
        size: const Size.fromRadius(38),
        child: CachedNetworkImage(
          imageUrl: serverFilesBaseURL + url.toString(),
          width: 76,
          height: 76,
          placeholder: (context, url) =>
              Image.asset("assets/images/transparent.png"),
          errorWidget: (context, url, error) =>
              Image.asset("assets/images/transparent.png"),
        ),
      ),
    );
  }

  Widget _buildFoodDetail({
    required BuildContext context,
    required Product food,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
            width: 200,
            child: Text(food.name!, style: _textTheme(context).subtitle1)),
        SizedBox(
          width: 200,
          child: Text(food.shortDescription!,
              style: _textTheme(context).bodyText1),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Text(
              "৳ ${food.price} ",
              style: _textTheme(context).subtitle1,
            ),
          ],
        ),
      ],
    );
  }

  TextTheme _textTheme(context) => Theme.of(context).textTheme;
}
