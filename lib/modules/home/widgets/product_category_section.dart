import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:ui_test/global/models/product_model.dart';
import 'package:ui_test/global/utils/constants.dart';
import 'package:ui_test/global/utils/theme_data.dart';
import 'package:ui_test/modules/home/models/product_category_file.dart';

class CategorySection extends StatelessWidget {
  final ProductCategorized category;
  const CategorySection({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      margin: const EdgeInsets.only(bottom: 16),
      color: bgWhite,
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
        const SizedBox(height: 16),
        _sectionTitle(context),
        const SizedBox(height: 8.0),
        // category.subtitle != null ? _sectionSubtitle(context) : const SizedBox(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _sectionTitle(BuildContext context) {
    return Row(
      children: [
        Text(
          category.name,
          style: _textTheme(context).headline6,
        )
      ],
    );
  }

  Widget _buildFoodTile({
    required BuildContext context,
    required bool isLastIndex,
    required Product food,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildFoodDetail(food: food, context: context),
            _buildFoodImage(food.icon),
          ],
        ),
        !isLastIndex ? const Divider(height: 16.0) : const SizedBox(height: 8.0)
      ],
    );
  }

  Widget _buildFoodImage(String? url) {
    if(url == null){
      return Container();
    }
    return CachedNetworkImage(
      imageUrl: serverFilesBaseURL + url.toString(),
      width: 64,
      height: 64,
      placeholder: (context, url) =>
      const CircularProgressIndicator(),
      errorWidget: (context, url, error) =>
      const Icon(Icons.error),
    );
  }

  Widget _buildFoodDetail({
    required BuildContext context,
    required Product food,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(food.name!, style: _textTheme(context).subtitle1),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              "Price : ${food.price} ",
              style: _textTheme(context).caption,
              ),
            Text(
              food.offerPrice.toString(),
              style: _textTheme(context).caption?.copyWith(decoration: TextDecoration.lineThrough),
            ),
          ],
        ),
      ],
    );
  }

  TextTheme _textTheme(context) => Theme.of(context).textTheme;
}
