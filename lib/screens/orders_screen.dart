import 'package:flutter/material.dart';
import 'package:kasishop/widgets/app_drawer.dart';
import 'package:kasishop/widgets/order_item.dart';

import 'package:provider/provider.dart' ;

import 'package:kasishop/providers/orders.dart' show Orders;


class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, index) => OrderItem(
          order: orderData.orders[index],
        ),
      ),
    );
  }
}
