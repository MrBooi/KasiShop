import 'package:flutter/material.dart';
import 'package:kasishop/widgets/app_drawer.dart';
import 'package:provider/provider.dart';

import '../providers/products_provider.dart';
import '../widgets/user_product_item.dart';
import '../screens/edit_product_screen.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';

  Future<void> _refreshProducts(BuildContext ctx) async {
    await Provider.of<Products>(ctx, listen: false).fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () =>
                Navigator.pushNamed(context, EditProductScreen.routeName),
          )
        ],
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _refreshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshProducts(context),
                    child: Consumer<Products>(
                      builder: (ctx, productData, _) => Padding(
                        padding: const EdgeInsets.all(8),
                        child: ListView.builder(
                            itemCount: productData.items.length,
                            itemBuilder: (_, index) {
                              var item = productData.items[index];
                              return Column(
                                children: <Widget>[
                                  UserProductItem(
                                    id: item.id,
                                    title: item.title,
                                    imageUrl: item.imageUrl,
                                  ),
                                  Divider()
                                ],
                              );
                            }),
                      ),
                    ),
                  ),
      ),
    );
  }
}
