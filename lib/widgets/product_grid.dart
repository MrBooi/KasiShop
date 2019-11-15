import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;

  ProductGrid({this.showFavorites});

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products =
        showFavorites ? productsData.favoriteItems : productsData.items;
    return GridView.builder(
      itemCount: products.length,
      padding: const EdgeInsets.all(10.0),
      itemBuilder: (ctx, index) {
        var item = products[index];
        return ChangeNotifierProvider.value(
          value: item,
          // builder: (ctx) => item,
          child: ProductItem(
              // id: item.id,
              // title: item.title,
              // imageUrl: item.imageUrl,
              ),
        );
      },
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10),
    );
  }
}
